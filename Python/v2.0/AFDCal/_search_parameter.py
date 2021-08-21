# -*- coding: utf-8 -*-

import numpy as np
import timeit
import math
from numpy.fft import fft, ifft
from numpy.matlib import repmat

def search_r(self,ch_i):
    N=self.N_r
    tol=self.tol_r
    # init
    f_r=self.remainder.copy()
    while len(self.r_store) < (ch_i+1):
        self.r_store.append([])
    while len(self.r_store[ch_i]) < (self.level+1+1):
        self.r_store[ch_i].append([])
    self.r_store[ch_i][self.level+1]=[]
    for j in range(int(N)-1):
        if self.decompMethod=='Single Channel Conventional AFD':
            # S
            phase_a=np.array([self.t[ch_i,:]])
            Base_r=self.Base_r[ch_i]
            S=np.zeros((np.shape(Base_r)[0],np.shape(Base_r)[1]),dtype=np.complex_)
            for i in range(np.shape(Base_r)[0]):
                S[i,:]=np.conj(np.transpose(Base_r[i,:,:] @ (np.conj(np.transpose(np.array([f_r[ch_i,:]])))*self.Weight)))
            abs_S=np.abs(S)
            min_S_loc=np.where(abs_S==np.nanmin(abs_S))
            min_row_i=min_S_loc[0][0]
            min_col_i=min_S_loc[1][0]
            # r
            min_S=abs_S[min_row_i,min_col_i]
            r=self.dic_an[ch_i][min_row_i,min_col_i]
        elif self.decompMethod=='Single Channel Fast AFD':
            # S
            phase_a=np.array([self.t[ch_i,:]])
            Base=self.Base_r[ch_i][0,:,:]
            S=ifft(repmat(fft(np.array([f_r[ch_i,:]])*np.transpose(self.Weight),np.shape(f_r)[1]),np.shape(Base)[0],1)*Base,np.shape(f_r)[1],1)
            abs_S=np.abs(S)
            min_S_loc=np.where(abs_S==np.nanmin(abs_S))
            min_row_i=min_S_loc[0][0]
            min_col_i=min_S_loc[1][0]
            # r
            min_S=abs_S[min_row_i,min_col_i]
            r=self.dic_an[ch_i][0,min_row_i]*math.e**(phase_a[0,min_col_i]*1j)
        f_r[ch_i,:]=f_r[ch_i,:]*(1-np.conj(r)*math.e**(1j*phase_a))/(math.e**(1j*phase_a)-r)
        if min_S/np.shape(self.t)[1]>tol:
            break
        else:
            self.r_store[ch_i][self.level+1].append(r)
