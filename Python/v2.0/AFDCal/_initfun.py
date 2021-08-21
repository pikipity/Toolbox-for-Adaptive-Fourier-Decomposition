# -*- coding: utf-8 -*-

from datetime import datetime
import numpy as np
from numpy.matlib import repmat
from scipy.signal import hilbert
import math

def setInputSignal(self,inputSig):
    logStr = '---------- '+datetime.now().strftime('%Y-%m-%d %I:%M:%S.%f %p')+' ----------'
    self.addLog(logStr)
    # Init input signal
    self.s = inputSig
    # Check input
    errorFlag = self.checkInput()
    if not self.isempty(errorFlag):
        for error_i in range(len(errorFlag)):
            if error_i == 1:
                logStr='warning: Input is empty. Please remember to set a input signal by "setInputSignal"'
                self.addLog(logStr)
                print(logStr)
            elif error_i == 2:
                logStr = 'warning: Please double check input signal. The first dimension should be channel. The second dimension should be sample.'
                self.addLog(logStr)
                print(logStr)
            elif error_i == 3:
                logStr = 'Error: The dimension of input signal is wrong. The input signal only can have 2 dimentions.'
                self.addLog(logStr)
                raise ValueError('The dimension of input signal is wrong. The input signal only can have 2 dimentions.')
    self.addLog('Input new signal')
    self.addLog('Initialize settings')
    # Init calculation settings
    self.initSetting()
    self.addLog('Set input signal correctly')
        

def initSetting(self):
    if self.isempty(self.s):
        # empty input signal
        logStr = 'warning: Because there is not input signal, the computational settings are not initialized successfully.'
        self.addLog(logStr)
        print(logStr)
        self.G = []
        self.t = []
        self.Weight = []
    else:
        if np.isreal(self.s).all():
            self.G = np.transpose(hilbert(np.transpose(self.s)))
        else:
            self.G = self.s.copy()
        K = np.shape(self.G)[1]
        ch_num = np.shape(self.G)[0]
        self.t = repmat(np.arange(0,2*math.pi,2*math.pi/K), ch_num, 1)
        self.Weight = np.ones((K,1))
    self.S1=[]
    self.max_loc=[]
    self.an=[]
    self.coef=[]
    self.level=[]
    self.dic_an=[]
    self.Base=[]
    self.remainder=[]
    self.tem_B=[]
    self.deComp=[]
    self.decompMethod = 'Single Channel Conventional AFD'
    self.dicGenMethod = 'square'
    self.AFDMethod = 'core'
    self.run_time=[]
    self.time_genDic=[]
    self.time_genEva=[]
    #
    self.r_store=[]
    self.InProd=[]
    self.OutProd=[]
    self.Base_r=[]
    self.N_r=1e3
    self.tol_r=1e-3
    #
    self.addLog('Initialize settings correctly')

# =============================================================================
#     def genWeight(self,method_no,n,newtonOrder):
#         y = np.ones([n,1])
#         if method_no == 2:
#             y = np.zeros([n,1])
#             Newton = np.zeros([newtonOrder+1,newtonOrder])
#             Newton[0:2,0]=np.array([1/2,1/2])
#             Newton[0:3,1]=np.array([1/6,4/6,1/6])
#             Newton[0:4,2]=np.array([1/8,3/8,3/8,1/8])
#             Newton[0:5,3]=np.array([7/90,16/45,2/15,16/45,7/90])
#             Newton[0:6,4]=np.array([19/288,25/96,25/144,25/144,25/96,19/288])
#             Newton[0:7,5]=np.array([41/840,9/35,9/280,34/105,9/280,9/35,41/840])
#             k = np.floor((n-1)/newtonOrder)
#             if k>0:
#                 iter = np.arange(1,k+1,1)
#                 nonNewton = (Newton[:,6-1]!=0)
# =============================================================================

def setDicGenMethod(self,method_no):
    if method_no==1:
        self.dicGenMethod='square'
    elif method_no==2:
        self.dicGenMethod='circle'
    else:
        self.addLog('error: Because the specific dicGenMethod is unknown, setDicGenMethod is not successful.')
        raise ValueError('Because the specific dicGenMethod is unknown, setDicGenMethod is not successful.')
    self.addLog('setDicGenMethod is successful.')
    
def setDecompMethod(self,method_no):
    if method_no==1:
        self.decompMethod = 'Single Channel Conventional AFD'
    elif method_no==2:
        self.decompMethod = 'Single Channel Fast AFD'
        self.addLog('Fast AFD only can use the "circle" dictionary. So the dicGenMethod is changed.')
        self.setDicGenMethod(2)
    else:
        self.addLog('error: Because the specific decompMethod is unknown, setDecompMethod is not successful.')
        raise ValueError('Because the specific decompMethod is unknown, setDecompMethod is not successful.')
    self.addLog('setDecompMethod is successful.')
    
def setAFDMethod(self,method_no):
    if method_no==1:
        self.AFDMethod='core'
    elif method_no==2:
        self.AFDMethod='unwinding'
    else:
        self.addLog('error: Because the specific AFDMethod is unknown, setAFDMethod is not successful.')
        raise ValueError('Because the specific AFDMethod is unknown, setAFDMethod is not successful.')
    self.addLog('setAFDMethod is successful.')
    
def set_r(self,r_store):
    self.r_store=r_store.copy()
    
def set_parameters_searchingZeros(self,N_r,tol_r):
    self.N_r=N_r
    self.tol_r=tol_r
    
def set_dic_an(self,dic_an):
    if self.decompMethod=='Single Channel Fast AFD':
        self.addLog('warning: Fast AFD is not allowed to set searching dictionary manually.')
        print('warning: Fast AFD is not allowed to set searching dictionary manually.')
        return
    # if np.shape(dic_an)[0]<np.shape(dic_an)[1]:
    #     self.addLog('warning: Because the specific searching dictionary is not correct, "set_dic_an" is not successful.')
    #     print('warning: Because the specific searching dictionary is not correct, "set_dic_an" is not successful.')
    #     return
    self.setDicGenMethod(1)
    for ch_i in range(np.shape(dic_an)[0]):
        dic_an[ch_i,:,:]=np.unique(dic_an[ch_i])
    self.dic_an=dic_an.copy()
    
def set_coef(self,coef):
    self.coef=coef.copy()
    
def set_an(self,an):
    self.an=an.copy()