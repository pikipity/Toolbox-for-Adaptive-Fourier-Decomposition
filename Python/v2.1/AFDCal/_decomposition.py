from numpy import ndarray
from typing import Union, Optional, Dict, List, Tuple
import numpy as np
import numpy.fft as pyfft
import numpy.matlib as pymat
from math import pi

import warnings
from time import time

from ._utils import Unit_Disk, Circle_Disk, e_a, calCoef, calS1, calS1_noconj

def genDic(self, 
           dist : float,
           max_an_mag : float):
    """
    Generate searching dictionary

    Parameters
    -------------
    dist : float
        Distance between two adjacent magnitude values
    max_an_mag: float
        Maximum magnitude of an
    """
    # Check generation method
    if (self.decompMethod == 2 or self.decompMethod == 4) and self.dicGenMethod == 1:
        self.setDecompMethod(2)
        warnings.warn("The fast AFD must use the 'circle' dictionary. But the given dictionary generation method is 'square'. To use the fast AFD, the dictionary generation method is automatically changed to 'circle'.")
    # Check inputs
    if dist < 0 or dist > 1:
        raise ValueError("The distance between two adjacent magnitude values must be within 0~1")
    if max_an_mag < 0 or max_an_mag > 1:
        raise ValueError("The maximum magnitude must be within 0~1")
    if len(self.s) == 0:
        raise ValueError("Please load input signal first")
    # Generate searching dictionary
    start_time = time()
    N_ch, N_sample = self.G.shape
    if self.decompMethod == 1 or self.decompMethod == 5 or self.decompMethod == 3:
        if self.dicGenMethod == 1:
            self.dic_an = [Unit_Disk(dist, max_an_mag) for _ in range(N_ch)]
        elif self.dicGenMethod == 2:
            self.dic_an = [Circle_Disk(dist, max_an_mag, N_sample, 2*pi-2*pi/N_sample) for _ in range(N_ch)]
        else:
            raise ValueError('Unknown dicGenMethod')
    elif self.decompMethod == 2 or self.decompMethod == 4:
        if self.dicGenMethod == 1:
            raise ValueError("The fast AFD cannot use the 'square' dictionary.")
        elif self.dicGenMethod == 2:
            self.dic_an = [Circle_Disk(dist, max_an_mag, N_sample, 0) for _ in range(N_ch)]
            self.dic_an_search = [Circle_Disk(dist, max_an_mag, N_sample, 2*pi-2*pi/N_sample) for _ in range(N_ch)]
        else:
            raise ValueError('Unknown dicGenMethod')
    else:
        raise ValueError('Unknown decompMethod')
    self.time_genDic = time() - start_time

def genEva(self):
    """
    Generate evaluators
    """
    # Check dictionary
    if len(self.dic_an) == 0:
        raise ValueError("Please generate the searching dictionary first!!")

    start_time = time()

    # Initilize evaluator
    N_ch, N_sample = self.G.shape
    self.Base = [np.zeros((self.dic_an[i_ch].shape[0], self.dic_an[i_ch].shape[1], N_sample), 'complex') for i_ch in range(N_ch)]
    # Generate evaluators
    if self.decompMethod == 1 or self.decompMethod == 3:
        for i_ch in range(N_ch):
            dic_row, dic_col = self.dic_an[i_ch].shape
            for i in range(dic_row):
                for j in range(dic_col):
                    if not np.isnan(self.dic_an[i_ch][i,j]):
                        self.Base[i_ch][i,j,:] = e_a(self.dic_an[i_ch][i,j], self.t[[i_ch],:])
    elif self.decompMethod == 2 or self.decompMethod == 4:
        for i_ch in range(N_ch):
            dic_row, dic_col = self.dic_an[i_ch].shape
            for i in range(dic_row):
                for j in range(dic_col):
                    if not np.isnan(self.dic_an[i_ch][i,j]):
                        self.Base[i_ch][i,j,:] = pyfft.fft(e_a(self.dic_an[i_ch][i,j], self.t[[i_ch],:]), N_sample) 
    elif self.decompMethod == 5:
        for i_ch in range(N_ch):
            dic_row, dic_col = self.dic_an[i_ch].shape
            for i in range(dic_row):
                for j in range(dic_col):
                    if not np.isnan(self.dic_an[i_ch][i,j]):
                        base_tmp = np.zeros((1,self.Base[i_ch].shape[-1]), 'complex')
                        base_tmp[0,:] = e_a(self.dic_an[i_ch][i,j], self.t[[i_ch],:])
                        normalize_term = np.sqrt(np.abs(calS1(base_tmp, base_tmp, self.weight)))
                        self.Base[i_ch][i,j,:] = base_tmp[0,:] / normalize_term
    else:
        raise ValueError('Unknown decompMethod')

    self.time_genEva = time() - start_time

def init_decomp(self):
    """
    Initilize decomposition
    """
    N_ch, _ = self.G.shape
    # Remove historical decomposition
    self.S1 = [[] for _ in range(N_ch)] # Energy distribution
    self.max_loc = [[] for _ in range(N_ch)] # Location of maximum energy
    self.an = [[] for _ in range(N_ch)] # Searching results of the basis parameter
    self.coef = [[] for _ in range(N_ch)] # Decomposition coefficients 
    self.level = 0 # Decomposition level (initial level is 0)
    self.remainder = [[] for _ in range(N_ch)] # Decomposition remainder
    for i_ch in range(N_ch):
        self.remainder[i_ch].append(self.G[[i_ch],:].copy())
    self.tem_B = [[] for _ in range(N_ch)] # Decomposition basis components
    self.deComp = [[] for _ in range(N_ch)] # Decomposition components
    self.run_time = [] # Running time of decomposition
    if self.decompMethod == 5:
        self.fenmu = [[] for _ in range(N_ch)] 
        self.GS_N = [[] for _ in range(N_ch)] 

    start_time = time()

    for i_ch in range(N_ch):
        if self.decompMethod == 5: # POAFD search a_n from n=0
            # Search a_0
            S1_tmp = []
            for i in range(self.Base[i_ch].shape[0]):
                S1_tmp.append(np.abs(calS1(self.Base[i_ch][i,:,:], self.remainder[i_ch][self.level], self.weight)).T)
            S1_tmp = np.concatenate(S1_tmp, 0) 
            self.S1[i_ch].append(S1_tmp)
            max_loc_tmp = np.argwhere(S1_tmp == np.amax(S1_tmp))
            self.max_loc[i_ch].append(max_loc_tmp)
            dic_an = self.dic_an[i_ch]
            an = dic_an[max_loc_tmp[0,0],max_loc_tmp[0,1]]
            self.an[i_ch].append(an)
            # calculate coefficient
            coef = calS1(self.Base[i_ch][max_loc_tmp[0,0], max_loc_tmp[0,1]:(max_loc_tmp[0,1]+1), :], self.remainder[i_ch][self.level], self.weight)
            self.coef[i_ch].append(coef)
            # calculate basis component
            tem_B = self.Base[i_ch][max_loc_tmp[0,0],max_loc_tmp[0,1]:(max_loc_tmp[0,1]+1),:]
            self.tem_B[i_ch].append(tem_B)
            # calculate decomposition component
            deComp = self.coef[i_ch][self.level] * self.tem_B[i_ch][self.level]
            self.deComp[i_ch].append(deComp)
            # Remainder
            remainder = self.G[[i_ch],:].copy()
            self.remainder[i_ch].append(remainder)
            # Base update term
            tem_GSD_tmp = []
            for i in range(self.Base[i_ch].shape[0]):
                tem_GSD_tmp.append(calS1_noconj(self.Base[i_ch][i,:,:], self.tem_B[i_ch][self.level], self.weight).T)
            tem_GSD_tmp = np.concatenate(tem_GSD_tmp, 0)
            self.fenmu[i_ch] = np.power(np.abs(tem_GSD_tmp), 2)
            GS_N_tmp = []
            for i in range(tem_GSD_tmp.shape[0]):
                GS_N_tmp.append(np.expand_dims(tem_GSD_tmp[i:(i+1),:].T @ self.tem_B[i_ch][self.level], axis = 0))
            self.GS_N[i_ch] = np.concatenate(GS_N_tmp, 0)
        else: # a_0 in other AFD must be 0
            # Initial stage: Do not need to search a_n. a_0=0
            self.S1[i_ch].append(None)
            self.max_loc[i_ch].append(None)
            an = 0
            self.an[i_ch].append(an)
            # Decomposition coefficient
            coef = calCoef(an, self.t[[i_ch],:], self.remainder[i_ch][self.level], self.weight)
            self.coef[i_ch].append(coef)
            # Basis component
            tem_B = (np.sqrt(1-np.abs(an)**2)/(1-np.conj(an)*np.exp(self.t[[i_ch],:]*1j)))
            self.tem_B[i_ch].append(tem_B)
            # Decomposition component
            deComp = self.coef[i_ch][self.level] * self.tem_B[i_ch][self.level]
            self.deComp[i_ch].append(deComp)
            # Remainder
            remainder = (self.remainder[i_ch][self.level]-coef*e_a(an, self.t[[i_ch],:])) * (1-np.conj(an) * np.exp(1j * self.t[[i_ch],:])) / (np.exp(1j * self.t[[i_ch],:])-an)
            self.remainder[i_ch].append(remainder)

    self.run_time.append(time() - start_time)

def nextDecomp(self):
    """
    Next decomposition
    """
    N_ch, _ = self.G.shape

    self.level += 1

    start_time = time()

    # Search a_n
    if self.decompMethod == 1 or self.decompMethod == 2 or self.decompMethod == 5:
        for i_ch in range(N_ch):
            if self.decompMethod == 1: # Conventional AFD
                S1_tmp = []
                for i in range(self.Base[i_ch].shape[0]):
                    S1_tmp.append(np.abs(calS1(self.Base[i_ch][i,:,:], self.remainder[i_ch][self.level], self.weight)).T)
                S1_tmp = np.concatenate(S1_tmp, 0) 
            elif self.decompMethod == 2: # Fast AFD
                Base = self.Base[i_ch][0,:,:]
                S1_tmp = np.abs(pyfft.ifft(pymat.repmat(pyfft.fft(self.remainder[i_ch][self.level] * self.weight.T, self.t.shape[1]),Base.shape[0], 1) * Base, self.t.shape[1], 1))
                S1_tmp = S1_tmp.T
            elif self.decompMethod == 5: # POAFD
                fenmu = self.fenmu[i_ch]
                fenmu[fenmu>=0.999999] = 0
                fenmu = np.expand_dims(fenmu, 2)
                fenmu = np.repeat(fenmu, repeats = self.Base[i_ch].shape[2], axis = 2)
                Base_current = (self.Base[i_ch] - self.GS_N[i_ch]) / np.sqrt(1-fenmu)
                S1_tmp = []
                for i in range(Base_current.shape[0]):
                    S1_tmp.append(np.abs(calS1(Base_current[i,:,:], self.remainder[i_ch][self.level], self.weight)).T)
                S1_tmp = np.concatenate(S1_tmp, 0)
            else:
                raise ValueError('Unknown decompMethod') 
            
            self.S1[i_ch].append(S1_tmp)
            max_loc_tmp = np.argwhere(S1_tmp == np.amax(S1_tmp))
            self.max_loc[i_ch].append(max_loc_tmp)
            if self.decompMethod == 1 or self.decompMethod == 5:
                dic_an = self.dic_an[i_ch]
            elif self.decompMethod == 2:
                dic_an = self.dic_an_search[i_ch]
            else:
                raise ValueError('Unknown decompMethod') 
            an = dic_an[max_loc_tmp[0,0],max_loc_tmp[0,1]]
            self.an[i_ch].append(an)
            # Decomposition coefficient
            if self.decompMethod == 5:
                coef = calS1(Base_current[max_loc_tmp[0,0],max_loc_tmp[0,1]:(max_loc_tmp[0,1]+1),:], self.remainder[i_ch][self.level], self.weight)
            else:
                coef = calCoef(an, self.t[[i_ch],:], self.remainder[i_ch][self.level], self.weight)
            self.coef[i_ch].append(coef)
            # Basis component
            if self.decompMethod == 5:
                tem_B = Base_current[max_loc_tmp[0,0],max_loc_tmp[0,1]:(max_loc_tmp[0,1]+1),:]
            else:
                tem_B = (np.sqrt(1-np.abs(an)**2)/(1-np.conj(an)*np.exp(self.t[[i_ch],:]*1j))) * ((np.exp(1j*self.t[[i_ch],:])-self.an[i_ch][self.level-1]) / (np.sqrt(1-np.abs(self.an[i_ch][self.level-1])**2))) * self.tem_B[i_ch][self.level-1]
            self.tem_B[i_ch].append(tem_B)
            # Decomposition component
            deComp = self.coef[i_ch][self.level] * self.tem_B[i_ch][self.level]
            self.deComp[i_ch].append(deComp)
            # Remainder
            if self.decompMethod == 5:
                remainder = self.G[[i_ch],:].copy()
            else:
                remainder = (self.remainder[i_ch][self.level]-coef*e_a(an, self.t[[i_ch],:])) * (1-np.conj(an) * np.exp(1j * self.t[[i_ch],:])) / (np.exp(1j * self.t[[i_ch],:])-an)
            self.remainder[i_ch].append(remainder)
            # Base update term
            if self.decompMethod == 5:
                tem_GSD_tmp = []
                for i in range(self.Base[i_ch].shape[0]):
                    tem_GSD_tmp.append(calS1_noconj(self.Base[i_ch][i,:,:], self.tem_B[i_ch][self.level], self.weight).T)
                tem_GSD_tmp = np.concatenate(tem_GSD_tmp, 0)
                self.fenmu[i_ch] = self.fenmu[i_ch] + np.power(np.abs(tem_GSD_tmp), 2)
                GS_N_tmp = []
                for i in range(tem_GSD_tmp.shape[0]):
                    GS_N_tmp.append(np.expand_dims(tem_GSD_tmp[i:(i+1),:].T @ self.tem_B[i_ch][self.level], axis = 0))
                self.GS_N[i_ch] = self.GS_N[i_ch] + np.concatenate(GS_N_tmp, 0)
            else:
                pass

    elif self.decompMethod == 3 or self.decompMethod == 4:
        if self.decompMethod == 3: # Multi-channel Conventional AFD
            S1_tmp_sum = []
            for i_ch in range(N_ch):
                S1_tmp = []
                for i in range(self.Base[i_ch].shape[0]):
                    S1_tmp.append(np.abs(calS1(self.Base[i_ch][i,:,:], self.remainder[i_ch][self.level], self.weight)).T)
                S1_tmp = np.concatenate(S1_tmp, 0) 
                if S1_tmp_sum == []:
                    S1_tmp_sum = S1_tmp.copy()
                else:
                    S1_tmp_sum = S1_tmp_sum + S1_tmp
            S1_tmp = S1_tmp_sum/N_ch
        elif self.decompMethod == 4: # Multi-channel Fast AFD
            S1_tmp_sum = []
            for i_ch in range(N_ch):
                Base = self.Base[i_ch][0,:,:]
                S1_tmp = np.abs(pyfft.ifft(pymat.repmat(pyfft.fft(self.remainder[i_ch][self.level] * self.weight.T, self.t.shape[1]),Base.shape[0], 1) * Base, self.t.shape[1], 1))
                S1_tmp = S1_tmp.T
                if S1_tmp_sum == []:
                    S1_tmp_sum = S1_tmp.copy()
                else:
                    S1_tmp_sum = S1_tmp_sum + S1_tmp
            S1_tmp = S1_tmp_sum/N_ch
        else:
            raise ValueError('Unknown decompMethod') 
        
        for i_ch in range(N_ch):
            if i_ch == 0:
                self.S1[i_ch].append(S1_tmp)
                max_loc_tmp = np.argwhere(S1_tmp == np.amax(S1_tmp))
                self.max_loc[i_ch].append(max_loc_tmp)
                if self.decompMethod == 1 or self.decompMethod == 5 or self.decompMethod == 3:
                    dic_an = self.dic_an[i_ch]
                elif self.decompMethod == 2 or self.decompMethod == 4:
                    dic_an = self.dic_an_search[i_ch]
                else:
                    raise ValueError('Unknown decompMethod') 
                an = dic_an[max_loc_tmp[0,0],max_loc_tmp[0,1]]
                self.an[i_ch].append(an)
                # Decomposition coefficient
                if self.decompMethod == 5:
                    coef = calS1(Base_current[max_loc_tmp[0,0],max_loc_tmp[0,1]:(max_loc_tmp[0,1]+1),:], self.remainder[i_ch][self.level], self.weight)
                else:
                    coef = calCoef(an, self.t[[i_ch],:], self.remainder[i_ch][self.level], self.weight)
                self.coef[i_ch].append(coef)
                # Basis component
                if self.decompMethod == 5:
                    tem_B = Base_current[max_loc_tmp[0,0],max_loc_tmp[0,1]:(max_loc_tmp[0,1]+1),:]
                else:
                    tem_B = (np.sqrt(1-np.abs(an)**2)/(1-np.conj(an)*np.exp(self.t[[i_ch],:]*1j))) * ((np.exp(1j*self.t[[i_ch],:])-self.an[i_ch][self.level-1]) / (np.sqrt(1-np.abs(self.an[i_ch][self.level-1])**2))) * self.tem_B[i_ch][self.level-1]
                self.tem_B[i_ch].append(tem_B)
                # Decomposition component
                deComp = self.coef[i_ch][self.level] * self.tem_B[i_ch][self.level]
                self.deComp[i_ch].append(deComp)
                # Remainder
                if self.decompMethod == 5:
                    remainder = self.G[[i_ch],:].copy()
                else:
                    remainder = (self.remainder[i_ch][self.level]-coef*e_a(an, self.t[[i_ch],:])) * (1-np.conj(an) * np.exp(1j * self.t[[i_ch],:])) / (np.exp(1j * self.t[[i_ch],:])-an)
                self.remainder[i_ch].append(remainder)
                # Base update term
                if self.decompMethod == 5:
                    tem_GSD_tmp = []
                    for i in range(self.Base[i_ch].shape[0]):
                        tem_GSD_tmp.append(calS1_noconj(self.Base[i_ch][i,:,:], self.tem_B[i_ch][self.level], self.weight).T)
                    tem_GSD_tmp = np.concatenate(tem_GSD_tmp, 0)
                    self.fenmu[i_ch] = self.fenmu[i_ch] + np.power(np.abs(tem_GSD_tmp), 2)
                    GS_N_tmp = []
                    for i in range(tem_GSD_tmp.shape[0]):
                        GS_N_tmp.append(np.expand_dims(tem_GSD_tmp[i:(i+1),:].T @ self.tem_B[i_ch][self.level], axis = 0))
                    self.GS_N[i_ch] = self.GS_N[i_ch] + np.concatenate(GS_N_tmp, 0)
                else:
                    pass
            else:
                self.S1[i_ch].append(self.S1[i_ch-1][-1])
                self.max_loc[i_ch].append(self.max_loc[i_ch-1][-1])
                self.an[i_ch].append(self.an[i_ch-1][-1])
                # Decomposition coefficient
                self.coef[i_ch].append(self.coef[i_ch-1][-1])
                # Basis component
                self.tem_B[i_ch].append(self.tem_B[i_ch-1][-1])
                # Decomposition component
                self.deComp[i_ch].append(self.deComp[i_ch-1][-1])
                # Remainder
                self.remainder[i_ch].append(self.remainder[i_ch-1][-1])
    else:
        raise ValueError('Unknown decompMethod')


    self.run_time.append(time() - start_time)

def reconstrct(self, level):
    """
    Calculate reconstructed signal
    """
    if level > self.level:
        raise ValueError("The current decomposition level is {:n}. If you want to reconstruct the signal using decomposition components in higher levels, please use 'nextDecomp()' to get more components.")
    N_ch, _ = self.G.shape
    re_sig = np.zeros_like(self.G)
    for i_ch in range(N_ch):
        select_deComp = self.deComp[i_ch][:level+1]
        re_sig[[i_ch],:] = self.deComp[i_ch][0]
        k = 1
        while k < len(select_deComp):
            re_sig[[i_ch],:] = re_sig[[i_ch],:] + select_deComp[k]
            k += 1
    return np.real(re_sig)

def decomp(self, level):
    """
    Decompose from the initial decomposition to the given level.
    """
    if self.level >= level:
        warnings.warn("The current decomposition already inlcudes the given level.")
    if self.level == 0:
        self.init_decomp()
    while self.level < level:
        self.nextDecomp()



    
    