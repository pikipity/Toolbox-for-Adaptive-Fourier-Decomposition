from numpy import ndarray
from typing import Union, Optional, Dict, List, Tuple
import numpy as np
from math import pi
from functools import partial
from joblib import Parallel, delayed

import warnings


def Unit_Disk(dist : float,
              max_an_mag : float) -> ndarray:
    """
    Generate square searching dictionary

    Parameters
    -------------
    dist : float
        Distance between two adjacent magnitude values
    max_an_mag: float
        Maximum magnitude of an
    """
    t = np.arange(-1.0, 1.0 + dist, dist)
    t = np.expand_dims(t, axis = 0)

    _, n = t.shape
    real = np.repeat(t,n,0)
    image = np.repeat(t.T,n,1)

    ret1 = real + 1j * image
    ret1[np.abs(ret1)-max_an_mag >= 1e-15] = None

    row_num, _ = ret1.shape
    remove_row = []
    for i in range(row_num):
        if np.isnan(ret1[i,:]).all():
            remove_row.append(i)
    ret2 = np.delete(ret1, remove_row, 0)

    _, col_num = ret2.shape
    remove_col = []
    for i in range(col_num):
        if np.isnan(ret2[:,i]).all():
            remove_col.append(i)
    ret3 = np.delete(ret2,remove_col,1)

    return ret3

def Circle_Disk(dist : float,
                max_an_mag : float,
                sig_len : int,
                max_an_phase : float) -> ndarray:
    """
    Generate circle searching dictionary

    Parameters
    -------------
    dist : float
        Distance between two adjacent magnitude values
    max_an_mag : float
        Maximum magnitude of an
    sig_len : int
        Signal length
    max_an_phase : float
        Maximum phase of an
    """
    phase_a = np.arange(0.0, max_an_phase + 2*pi/sig_len, 2*pi/sig_len)
    phase_a = np.expand_dims(phase_a, axis = 0)
    abs_a = np.arange(0.0, 1.0 + dist, dist)
    abs_a = abs_a[0:-1]
    abs_a = np.expand_dims(abs_a, axis = 0)
    
    _, n_phase = phase_a.shape
    _, n_abs = abs_a.shape
    abs_a = np.repeat(abs_a,n_phase,0)
    phase_a = np.repeat(phase_a.T,n_abs,1)

    ret1 = abs_a * np.exp(1j * phase_a)
    ret1[np.abs(ret1)-max_an_mag >= 1e-15] = None

    row_num, _ = ret1.shape
    remove_row = []
    for i in range(row_num):
        if np.isnan(ret1[i,:]).all():
            remove_row.append(i)
    ret2 = np.delete(ret1, remove_row, 0)

    _, col_num = ret2.shape
    remove_col = []
    for i in range(col_num):
        if np.isnan(ret2[:,i]).all():
            remove_col.append(i)
    ret3 = np.delete(ret2,remove_col,1)

    return ret3

def e_a(a, t):
    """
    Evaluator
    """
    return ((1-np.abs(a)**2)**0.5)/(1-np.conj(a)*np.exp(1j*t))

def genWeight(N):
    return np.ones((N,1),'complex')

def intg(f,g,W):
    y = f.dot(g.T*W)
    return y/f.shape[1]