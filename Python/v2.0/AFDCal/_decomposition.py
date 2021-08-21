# -*- coding: utf-8 -*-

import numpy as np
import timeit
import math
from numpy.fft import fft

def genDic(self, dist, max_an_mag):
    # check inputs
    if dist<0 or dist>1:
        self.addLog('error: Because the specific dist is unknown, genDic is not successful.')
        raise ValueError('Because the specific dist is unknown, genDic is not successful.')
    if max_an_mag<0 or max_an_mag>1:
        self.addLog('error: Because the specific max_an_mag is unknown, genDic is not successful.')
        raise ValueError('Because the specific max_an_mag is unknown, genDic is not successful.')
    # init time recorder
    self.time_genDic = np.zeros((np.shape(self.G)[0],1))
    if self.decompMethod=='Single Channel Conventional AFD':
        if self.dicGenMethod=='square':
            for ch_i in range(np.shape(self.G)[0]):
                tic = timeit.default_timer()
                if len(self.dic_an)>=ch_i+1:
                    self.dic_an[ch_i] = self.Unit_Disk(dist, max_an_mag)
                else:
                    self.dic_an.append(self.Unit_Disk(dist, max_an_mag))
                self.time_genDic[ch_i,0] = timeit.default_timer() - tic
        elif self.dicGenMethod=='circle':
            K = np.shape(self.G)[1]
            for ch_i in range(np.shape(self.G)[0]):
                tic = timeit.default_timer()
                if len(self.dic_an)>=ch_i+1:
                    self.dic_an[ch_i] = self.Circle_Disk(dist,max_an_mag,np.array([np.arange(0,2*math.pi,2*math.pi/K)]))
                else:
                    self.dic_an.append(self.Circle_Disk(dist,max_an_mag,np.array([np.arange(0,2*math.pi,2*math.pi/K)])))
                self.time_genDic[ch_i,0] = timeit.default_timer() - tic
    elif self.decompMethod=='Single Channel Fast AFD':
        if self.dicGenMethod=='square':
            self.addLog('error: Because dicGenMethod is not correct (fast AFD only can use "circle"), genDic is not successful.')
            raise ValueError('Because dicGenMethod is not correct (fast AFD only can use "circle"), genDic is not successful.')
        elif self.dicGenMethod=='circle':
            K = np.shape(self.G)[1]
            for ch_i in range(np.shape(self.G)[0]):
                tic = timeit.default_timer()
                # cont=max_an_mag
                # ret1=np.array([np.arange(0,1+dist,dist)])
                # ret1[np.abs(ret1)>=cont] = None
                # ret = ret1.copy()
                # del ret1
                # remove_col=[]
                # for j in range(np.shape(ret)[1]):
                #     if np.sum(np.isnan(ret[:,j]))==np.shape(ret)[0]:
                #         remove_col.append(j)
                # abs_a = np.delete(ret, remove_col, 1)
                ret1 = self.Circle_Disk(dist,max_an_mag,np.array([np.arange(0,2*math.pi,2*math.pi/K)]))
                abs_a = np.array([np.unique(np.abs(ret1))])
                abs_a = np.array([abs_a[~np.isnan(abs_a)]])
                if len(self.dic_an)>=ch_i+1:
                    self.dic_an[ch_i] = abs_a
                else:
                    self.dic_an.append(abs_a)
                self.time_genDic[ch_i,0] = timeit.default_timer() - tic
    self.addLog('generate searching dictionary successfully.')
    
    
def genEva(self):
    self.time_genEva = np.zeros((np.shape(self.G)[0],1))
    if self.decompMethod == 'Single Channel Conventional AFD':
        self.Base=[]
        for ch_i in range(np.shape(self.G)[0]):
            tic = timeit.default_timer()
            dic_tmp=self.dic_an[ch_i]
            t_tmp=self.t[ch_i,:]
            self.Base.append(np.zeros((np.shape(dic_tmp)[0],np.shape(dic_tmp)[1],len(t_tmp)),dtype=np.complex_))
            for i in range(np.shape(dic_tmp)[0]):
                for j in range(np.shape(dic_tmp)[1]):
                    self.Base[ch_i][i,j,:]=self.e_a(dic_tmp[i,j],math.e**(1j*t_tmp))
            self.time_genEva[ch_i,0] = timeit.default_timer() - tic
        # evaluator for r
        if self.AFDMethod == 'unwinding':
            self.Base_r=[]
            for ch_i in range(np.shape(self.G)[0]):
                tic = timeit.default_timer()
                dic_tmp=self.dic_an[ch_i]
                t_tmp=self.t[ch_i,:]
                self.Base_r.append(np.zeros((np.shape(dic_tmp)[0],np.shape(dic_tmp)[1],len(t_tmp)),dtype=np.complex_))
                for i in range(np.shape(dic_tmp)[0]):
                    for j in range(np.shape(dic_tmp)[1]):
                        self.Base_r[ch_i][i,j,:]=self.e_a_r(dic_tmp[i,j],math.e**(1j*t_tmp))
                self.time_genEva[ch_i,0] += timeit.default_timer() - tic
    elif self.decompMethod == 'Single Channel Fast AFD':
        self.Base=[]
        for ch_i in range(np.shape(self.G)[0]):
            tic = timeit.default_timer()
            dic_tmp=self.dic_an[ch_i]
            t_tmp=self.t[ch_i,:]
            self.Base.append(np.zeros((np.shape(dic_tmp)[0],np.shape(dic_tmp)[1],len(t_tmp)),dtype=np.complex_))
            for i in range(np.shape(dic_tmp)[0]):
                for j in range(np.shape(dic_tmp)[1]):
                    self.Base[ch_i][i,j,:]=fft(self.e_a(dic_tmp[i,j],math.e**(1j*t_tmp)),len(t_tmp))
            self.time_genEva[ch_i,0] = timeit.default_timer() - tic
        # evaluator for r
        if self.AFDMethod == 'unwinding':
            self.Base_r=[]
            for ch_i in range(np.shape(self.G)[0]):
                tic = timeit.default_timer()
                dic_tmp=self.dic_an[ch_i]
                t_tmp=self.t[ch_i,:]
                self.Base_r.append(np.zeros((np.shape(dic_tmp)[0],np.shape(dic_tmp)[1],len(t_tmp)),dtype=np.complex_))
                for i in range(np.shape(dic_tmp)[0]):
                    for j in range(np.shape(dic_tmp)[1]):
                        self.Base_r[ch_i][i,j,:]=fft(self.e_a_r(dic_tmp[i,j],math.e**(1j*t_tmp)),len(t_tmp))
                self.time_genEva[ch_i,0] += timeit.default_timer() - tic
    self.addLog('generate evaluators successfully.')
    
def init_decomp(self,searching_an_flag=1):
    if self.isempty(self.s):
        self.addLog('warning: Because there is not input signal, the decomposition cannot be initilized.')
        print('warning: Because there is not input signal, the decomposition cannot be initilized.')
        return
    if self.decompMethod=='Single Channel Fast AFD' and self.dicGenMethod=='square':
        self.addLog('warning: AFD only can use circle searching dictionary.')
        print('warning: AFD only can use circle searching dictionary.')
        return
    self.level=-1
    K=np.shape(self.G)[0]
    self.remainder=self.G.copy()
    for ch_i in range(K):
        tic=timeit.default_timer()
        if searching_an_flag:
            # r
            if self.AFDMethod=='unwinding':
                self.search_r(ch_i)
                while len(self.InProd) < (ch_i+1):
                    self.InProd.append([])
                