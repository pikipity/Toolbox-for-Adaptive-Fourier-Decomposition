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
    if self.decompMethod == 2 and self.dicGenMethod == 1:
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
    if self.decompMethod == 1 or self.decompMethod == 5:
        if self.dicGenMethod == 1:
            self.dic_an = Unit_Disk(dist, max_an_mag)
        elif self.dicGenMethod == 2:
            _, sig_len = self.s.shape
            self.dic_an = Circle_Disk(dist, max_an_mag, sig_len, 2*pi-2*pi/sig_len)
        else:
            raise ValueError('Unknown dicGenMethod')
    elif self.decompMethod == 2:
        if self.dicGenMethod == 1:
            raise ValueError("The fast AFD cannot use the 'square' dictionary.")
        elif self.dicGenMethod == 2:
            _, sig_len = self.s.shape
            self.dic_an = Circle_Disk(dist, max_an_mag, sig_len, 0)
            self.dic_an_search = Circle_Disk(dist, max_an_mag, sig_len, 2*pi-2*pi/sig_len)
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
    dic_row, dic_col = self.dic_an.shape
    _, N_sample = self.t.shape
    self.Base = np.zeros((dic_row, dic_col, N_sample), 'complex')
    # Generate evaluators
    if self.decompMethod == 1:
        for i in range(dic_row):
            for j in range(dic_col):
                if not np.isnan(self.dic_an[i,j]):
                    self.Base[i,j,:] = e_a(self.dic_an[i,j], self.t)
    elif self.decompMethod == 2:
        for i in range(dic_row):
            for j in range(dic_col):
                if not np.isnan(self.dic_an[i,j]):
                    self.Base[i,j,:] = pyfft.fft(e_a(self.dic_an[i,j], self.t), N_sample) 
    elif self.decompMethod == 5:
        for i in range(dic_row):
            for j in range(dic_col):
                if not np.isnan(self.dic_an[i,j]):
                    base_tmp = np.zeros((1,self.Base.shape[-1]), 'complex')
                    base_tmp[0,:] = e_a(self.dic_an[i,j], self.t)
                    normalize_term = np.sqrt(np.abs(calS1(base_tmp, base_tmp, self.weight)))
                    self.Base[i,j,:] = base_tmp[0,:] / normalize_term
    else:
        raise ValueError('Unknown decompMethod')

    self.time_genEva = time() - start_time

def init_decomp(self):
    """
    Initilize decomposition
    """
    # Remove historical decomposition
    self.S1 = [] # Energy distribution
    self.max_loc = [] # Location of maximum energy
    self.an = [] # Searching results of the basis parameter
    self.coef = [] # Decomposition coefficients 
    self.level = 0 # Decomposition level (initial level is 0)
    self.remainder = [] # Decomposition remainder
    self.remainder.append(self.G.copy())
    self.tem_B = [] # Decomposition basis components
    self.deComp = [] # Decomposition components
    self.run_time = [] # Running time of decomposition

    start_time = time()

    if self.decompMethod == 5: # POAFD search a_n from n=0
        # Search a_0
        S1_tmp = []
        for i in range(self.Base.shape[0]):
            S1_tmp.append(np.abs(calS1(self.Base[i,:,:], self.remainder[self.level], self.weight)).T)
        S1_tmp = np.concatenate(S1_tmp, 0) 
        self.S1.append(S1_tmp)
        max_loc_tmp = np.argwhere(S1_tmp == np.amax(S1_tmp))
        self.max_loc.append(max_loc_tmp)
        dic_an = self.dic_an
        an = dic_an[max_loc_tmp[0,0],max_loc_tmp[0,1]]
        self.an.append(an)
        # calculate coefficient
        coef = calS1(self.Base[max_loc_tmp[0,0], max_loc_tmp[0,1]:(max_loc_tmp[0,1]+1), :], self.remainder[self.level], self.weight)
        self.coef.append(coef)
        # calculate basis component
        tem_B = self.Base[max_loc_tmp[0,0],max_loc_tmp[0,1]:(max_loc_tmp[0,1]+1),:]
        self.tem_B.append(tem_B)
        # calculate decomposition component
        deComp = self.coef[self.level] * self.tem_B[self.level]
        self.deComp.append(deComp)
        # Remainder
        remainder = self.G.copy()
        self.remainder.append(remainder)
        # Base update term
        tem_GSD_tmp = []
        for i in range(self.Base.shape[0]):
            tem_GSD_tmp.append(calS1_noconj(self.Base[i,:,:], self.tem_B[self.level], self.weight).T)
        tem_GSD_tmp = np.concatenate(tem_GSD_tmp, 0)
        self.fenmu = np.power(np.abs(tem_GSD_tmp), 2)
        GS_N_tmp = []
        for i in range(tem_GSD_tmp.shape[0]):
            GS_N_tmp.append(np.expand_dims(tem_GSD_tmp[i:(i+1),:].T @ self.tem_B[self.level], axis = 0))
        self.GS_N = np.concatenate(GS_N_tmp, 0)
    else: # a_0 in other AFD must be 0
        # Initial stage: Do not need to search a_n. a_0=0
        self.S1.append(None)
        self.max_loc.append(None)
        an = 0
        self.an.append(an)
        # Decomposition coefficient
        coef = calCoef(an, self.t, self.remainder[self.level], self.weight)
        self.coef.append(coef)
        # Basis component
        tem_B = (np.sqrt(1-np.abs(an)**2)/(1-np.conj(an)*np.exp(self.t*1j)))
        self.tem_B.append(tem_B)
        # Decomposition component
        deComp = self.coef[self.level] * self.tem_B[self.level]
        self.deComp.append(deComp)
        # Remainder
        remainder = (self.remainder[self.level]-coef*e_a(an, self.t)) * (1-np.conj(an) * np.exp(1j * self.t)) / (np.exp(1j * self.t)-an)
        self.remainder.append(remainder)

    self.run_time.append(time() - start_time)

def nextDecomp(self):
    """
    Next decomposition
    """
    self.level += 1

    start_time = time()

    # Search a_n
    if self.decompMethod == 1: # Conventional AFD
        S1_tmp = []
        for i in range(self.Base.shape[0]):
            S1_tmp.append(np.abs(calS1(self.Base[i,:,:], self.remainder[self.level], self.weight)).T)
        S1_tmp = np.concatenate(S1_tmp, 0) 
    elif self.decompMethod == 2: # Fast AFD
        Base = self.Base[0,:,:]
        S1_tmp = np.abs(pyfft.ifft(pymat.repmat(pyfft.fft(self.remainder[self.level] * self.weight.T, self.t.shape[1]),Base.shape[0], 1) * Base, self.t.shape[1], 1))
        S1_tmp = S1_tmp.T
    elif self.decompMethod == 5: # POAFD
        fenmu = self.fenmu
        fenmu[fenmu>=0.999999] = 0
        fenmu = np.expand_dims(fenmu, 2)
        fenmu = np.repeat(fenmu, repeats = self.Base.shape[2], axis = 2)
        Base_current = (self.Base - self.GS_N) / np.sqrt(1-fenmu)
        S1_tmp = []
        for i in range(Base_current.shape[0]):
            S1_tmp.append(np.abs(calS1(Base_current[i,:,:], self.remainder[self.level], self.weight)).T)
        S1_tmp = np.concatenate(S1_tmp, 0)
    else:
        raise ValueError('Unknown decompMethod') 
    self.S1.append(S1_tmp)
    max_loc_tmp = np.argwhere(S1_tmp == np.amax(S1_tmp))
    self.max_loc.append(max_loc_tmp)
    if self.decompMethod == 1 or self.decompMethod == 5:
        dic_an = self.dic_an
    elif self.decompMethod == 2:
        dic_an = self.dic_an_search
    else:
        raise ValueError('Unknown decompMethod') 
    an = dic_an[max_loc_tmp[0,0],max_loc_tmp[0,1]]
    self.an.append(an)
    # Decomposition coefficient
    if self.decompMethod == 5:
        coef = calS1(Base_current[max_loc_tmp[0,0],max_loc_tmp[0,1]:(max_loc_tmp[0,1]+1),:], self.remainder[self.level], self.weight)
    else:
        coef = calCoef(an, self.t, self.remainder[self.level], self.weight)
    self.coef.append(coef)
    # Basis component
    if self.decompMethod == 5:
        tem_B = Base_current[max_loc_tmp[0,0],max_loc_tmp[0,1]:(max_loc_tmp[0,1]+1),:]
    else:
        tem_B = (np.sqrt(1-np.abs(an)**2)/(1-np.conj(an)*np.exp(self.t*1j))) * ((np.exp(1j*self.t)-self.an[self.level-1]) / (np.sqrt(1-np.abs(self.an[self.level-1])**2))) * self.tem_B[self.level-1]
    self.tem_B.append(tem_B)
    # Decomposition component
    deComp = self.coef[self.level] * self.tem_B[self.level]
    self.deComp.append(deComp)
    # Remainder
    if self.decompMethod == 5:
        remainder = self.G.copy()
    else:
        remainder = (self.remainder[self.level]-coef*e_a(an, self.t)) * (1-np.conj(an) * np.exp(1j * self.t)) / (np.exp(1j * self.t)-an)
    self.remainder.append(remainder)
    # Base update term
    if self.decompMethod == 5:
        tem_GSD_tmp = []
        for i in range(self.Base.shape[0]):
            tem_GSD_tmp.append(calS1_noconj(self.Base[i,:,:], self.tem_B[self.level], self.weight).T)
        tem_GSD_tmp = np.concatenate(tem_GSD_tmp, 0)
        self.fenmu = self.fenmu + np.power(np.abs(tem_GSD_tmp), 2)
        GS_N_tmp = []
        for i in range(tem_GSD_tmp.shape[0]):
            GS_N_tmp.append(np.expand_dims(tem_GSD_tmp[i:(i+1),:].T @ self.tem_B[self.level], axis = 0))
        self.GS_N = self.GS_N + np.concatenate(GS_N_tmp, 0)
    else:
        pass


    self.run_time.append(time() - start_time)

def reconstrct(self, level):
    """
    Calculate reconstructed signal
    """
    if level > self.level:
        raise ValueError("The current decomposition level is {:n}. If you want to reconstruct the signal using decomposition components in higher levels, please use 'nextDecomp()' to get more components.")
    select_deComp = self.deComp[:level+1]
    re_sig = self.deComp[0]
    k = 1
    while k < len(select_deComp):
        re_sig = re_sig + select_deComp[k]
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



    
    