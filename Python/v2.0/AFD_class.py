# -*- coding: utf-8 -*-

from numpy import *
import numpy as np
from numpy.matlib import repmat
from numpy.fft import fft, ifft
from scipy.signal import hilbert
import pickle 
import os
from scipy.io import loadmat
from matplotlib import pyplot as pt
from matplotlib import cm
from datetime import datetime
import math


class AFDCal:
    def __init__(self,s=[]):
        self.log=''
        self.setInputSignal(s)
        
    def setInputSignal(self,inputSig):
        logStr = '---------- '+datetime.now().strftime('%Y-%m-%d %I:%M:%S.%f %p')+' ----------'
        self.addLog(logStr)
        # Init input signal
        self.s = inputSig
        # Check input
        errorFlag = self.checkInput()
        if errorFlag:
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
        
        
    def addLog(self,logStr):
        self.log += '\n'
        self.log += logStr
        
    def checkInput(self):
        errorFlag=[]
        if not self.s:
            errorFlag.append(1)
        else:
            if np.shape(self.s)[1]<=np.shape(self.s)[0]:
                errorFlag.append(2)
            if len(np.shape(self.s))>2:
                errorFlag.append(3)
        return errorFlag
    
    def initSetting(self):
        if not self.s:
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
            self.t = np.matlib.repmat(np.arange(0,2*math.pi,2*math.pi/K), ch_num, 1)
            self.genWeight(1,K,0)
            
    def genWeight(self,method_no,n,newtonOrder):
        y = np.ones([n,1])
        if method_no == 2:
            y = np.zeros([n,1])
            Newton = np.zeros([newtonOrder+1,newtonOrder])
            Newton[0:2,0]=np.array([1/2,1/2])
            Newton[0:3,1]=np.array([1/6,4/6,1/6])
            Newton[0:4,2]=np.array([1/8,3/8,3/8,1/8])
            Newton[0:5,3]=np.array([7/90,16/45,2/15,16/45,7/90])
            Newton[0:6,4]=np.array([19/288,25/96,25/144,25/144,25/96,19/288])
            Newton[0:7,5]=np.array([41/840,9/35,9/280,34/105,9/280,9/35,41/840])
            k = np.floor((n-1)/newtonOrder)
            if k>0:
                iter = np.arange(1,k+1,1)
                nonNewton = (Newton[:,6-1]!=0)
                
            
            
            
if __name__=="__main__":
    pt.close('all')
    # load data
    s = loadmat('bump_signal.mat')
    s = s['G'].copy()
        