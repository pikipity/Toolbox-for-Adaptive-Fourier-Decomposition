# -*- coding: utf-8 -*-

import numpy as np
import timeit
import math
from numpy.fft import fft, ifft
from numpy.matlib import repmat

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
    self.run_time = np.zeros((np.shape(self.G)[0],1))
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
                self.InProd[ch_i]=[]
                inprod = self.blaschke1(self.r_store[ch_i][self.level+1],np.array([self.t[ch_i,:]]))
                self.InProd[ch_i].append(inprod)
                self.remainder=self.remainder/inprod
            # init energy dictribution
            while len(self.S1)<(ch_i+1):
                self.S1.append([])
            while len(self.S1[ch_i])<(self.level+1+1):
                self.S1[ch_i].append([])
            self.S1[ch_i][self.level+1]=[]
            while len(self.max_loc)<(ch_i+1):
                self.max_loc.append([])
            while len(self.max_loc[ch_i])<(self.level+1+1):
                self.max_loc[ch_i].append([])
            self.max_loc[ch_i][self.level+1]=[]
            # init an
            while len(self.an)<(ch_i+1):
                self.an.append([])
            while len(self.an[ch_i])<(self.level+1+1):
                self.an[ch_i].append([])
            self.an[ch_i][self.level+1]=[]
            an=0j
            self.an[ch_i][self.level+1].append(an)
        else:
            # r
            if self.AFDMethod=='unwinding':
                while len(self.InProd) < (ch_i+1):
                    self.InProd.append([])
                self.InProd[ch_i]=[]
                inprod = self.blaschke1(self.r_store[ch_i][self.level+1],np.array([self.t[ch_i,:]]))
                self.InProd[ch_i].append(inprod)
                self.remainder=self.remainder/inprod
            # init energy dictribution
            while len(self.S1)<(ch_i+1):
                self.S1.append([])
            while len(self.S1[ch_i])<(self.level+1+1):
                self.S1[ch_i].append([])
            self.S1[ch_i][self.level+1]=[]
            while len(self.max_loc)<(ch_i+1):
                self.max_loc.append([])
            while len(self.max_loc[ch_i])<(self.level+1+1):
                self.max_loc[ch_i].append([])
            self.max_loc[ch_i][self.level+1]=[]
            # init an
            an=self.an[ch_i][self.level+1][0]
        # coef
        while len(self.coef)<(ch_i+1):
            self.coef.append([])
        while len(self.coef[ch_i])<(0+1):
            self.coef[ch_i].append([])
        self.coef[ch_i][0]=[]
        t_tmp=np.array([self.t[ch_i,:]])
        e_a_tmp=self.e_a(an,math.e**(1j*t_tmp[0,:]))
        coef=e_a_tmp.conj() @ (np.transpose(np.array([self.remainder[ch_i,:]]))*self.Weight)/np.shape(t_tmp)[1]
        self.coef[ch_i][0].append(coef[0,0])
        # tem_B
        while len(self.tem_B)<(ch_i+1):
            self.tem_B.append([])
        self.tem_B[ch_i]=[]
        tem_B = np.sqrt(1-np.abs(an)**2)/(1-np.conj(an)*math.e**(t_tmp*1j))
        if self.AFDMethod == 'unwinding':
            while len(self.OutProd)<(ch_i+1):
                self.OutProd.append([])
            self.OutProd[ch_i]=[]
            self.OutProd[ch_i].append(tem_B)
            tem_B=tem_B*inprod
        self.tem_B[ch_i].append(tem_B)
        # deComp
        while len(self.deComp)<(ch_i+1):
            self.deComp.append([])
        self.deComp[ch_i]=[]
        deComp=coef*tem_B
        self.deComp[ch_i].append(deComp)
        # remainder
        self.remainder[ch_i,:]=(self.remainder[ch_i,:]-coef*e_a_tmp)*(1-np.conj(an)*math.e**(1j*t_tmp))/(math.e**(1j*t_tmp)-an)
        # time
        self.run_time[ch_i,0]=timeit.default_timer() - tic
    self.level += 1
    self.addLog('The decomposition has been initilized.')
    
def nextDecomp(self,searching_an_flag=1):
    if self.isempty(self.s):
        self.addLog('warning: Because there is not input signal, the decomposition cannot be initilized.')
        print('warning: Because there is not input signal, the decomposition cannot be initilized.')
        return
    if self.decompMethod=='Single Channel Fast AFD' and self.dicGenMethod=='square':
        self.addLog('warning: AFD only can use circle searching dictionary.')
        print('warning: AFD only can use circle searching dictionary.')
        return
    K=np.shape(self.G)[0]
    for ch_i in range(K):
        tic=timeit.default_timer()
        if searching_an_flag:
            # r
            if self.AFDMethod=='unwinding':
                self.search_r(ch_i)
                inprod = self.blaschke1(self.r_store[ch_i][self.level+1],np.array([self.t[ch_i,:]]))
                self.InProd[ch_i].append(inprod)
                self.remainder=self.remainder/inprod
            # search an
            if self.decompMethod=='Single Channel Conventional AFD':
                while len(self.S1)<(ch_i+1):
                    self.S1.append([])
                while len(self.S1[ch_i])<(self.level+1+1):
                    self.S1[ch_i].append([])
                Base=self.Base[ch_i]
                self.S1[ch_i][self.level+1]=np.zeros((np.shape(Base)[0],np.shape(Base)[1]),dtype=np.complex_)
                for i in range(np.shape(Base)[0]):
                    self.S1[ch_i][self.level+1][i,:]=np.conj(np.transpose(Base[i,:,:] @ (np.conj(np.transpose(np.array([self.remainder[ch_i,:]])))*self.Weight)))
                abs_S=np.abs(self.S1[ch_i][self.level+1])
                max_S_loc=np.where(abs_S==np.nanmax(abs_S))
                max_row_i=max_S_loc[0][0]
                max_col_i=max_S_loc[1][0]
                while len(self.max_loc)<(ch_i+1):
                    self.max_loc.append([])
                while len(self.max_loc[ch_i])<(self.level+1+1):
                    self.max_loc[ch_i].append([])
                self.max_loc[ch_i][self.level+1]=[]
                self.max_loc[ch_i][self.level+1].append([max_row_i,max_col_i])
                an=self.dic_an[ch_i][max_row_i,max_col_i]
                while len(self.an)<(ch_i+1):
                    self.an.append([])
                while len(self.an[ch_i])<(self.level+1+1):
                    self.an[ch_i].append([])
                self.an[ch_i][self.level+1]=[]
                self.an[ch_i][self.level+1].append(an)
            elif self.decompMethod=='Single Channel Fast AFD':
                phase_a=np.array([self.t[ch_i,:]])
                Base=self.Base[ch_i][0,:,:]
                while len(self.S1)<(ch_i+1):
                    self.S1.append([])
                while len(self.S1[ch_i])<(self.level+1+1):
                    self.S1[ch_i].append([])
                self.S1[ch_i][self.level+1]=ifft(repmat(fft(np.array([self.remainder[ch_i,:]])*np.transpose(self.Weight),np.shape(self.remainder)[1]),np.shape(Base)[0],1)*Base,np.shape(self.remainder)[1],1)
                abs_S=np.abs(self.S1[ch_i][self.level+1])
                max_S_loc=np.where(abs_S==np.nanmax(abs_S))
                max_row_i=max_S_loc[0][0]
                max_col_i=max_S_loc[1][0]
                while len(self.max_loc)<(ch_i+1):
                    self.max_loc.append([])
                while len(self.max_loc[ch_i])<(self.level+1+1):
                    self.max_loc[ch_i].append([])
                self.max_loc[ch_i][self.level+1]=[]
                self.max_loc[ch_i][self.level+1].append([max_row_i,max_col_i])
                an=self.dic_an[ch_i][0,max_row_i]*math.e**(phase_a[0,max_col_i]*1j)
                while len(self.an)<(ch_i+1):
                    self.an.append([])
                while len(self.an[ch_i])<(self.level+1+1):
                    self.an[ch_i].append([])
                self.an[ch_i][self.level+1]=[]
                self.an[ch_i][self.level+1].append(an)
        else:
            # r
            if self.AFDMethod=='unwinding':
                inprod = self.blaschke1(self.r_store[ch_i][self.level+1],np.array([self.t[ch_i,:]]))
                self.InProd[ch_i].append(inprod)
                self.remainder=self.remainder/inprod
            while len(self.S1)<(ch_i+1):
                self.S1.append([])
            while len(self.S1[ch_i])<(self.level+1+1):
                self.S1[ch_i].append([])
            self.S1[ch_i][self.level+1]=[]
            while len(self.max_loc)<(ch_i+1):
                self.max_loc.append([])
            while len(self.max_loc[ch_i])<(self.level+1+1):
                self.max_loc[ch_i].append([])
            self.max_loc[ch_i][self.level+1]=[]
            an=self.an[ch_i][self.level+1][0]
        
            