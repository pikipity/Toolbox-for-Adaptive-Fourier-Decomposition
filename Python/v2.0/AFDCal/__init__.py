# -*- coding: utf-8 -*-

# =============================================================================
# from numpy import *
# import numpy as np
# from numpy.matlib import repmat
# from numpy.fft import fft, ifft
# from scipy.signal import hilbert
# import pickle 
# import os
# from scipy.io import loadmat
# from matplotlib import pyplot as pt
# from matplotlib import cm
# from datetime import datetime
# import math
# =============================================================================

import importlib

class AFDCal:
    def __init__(self,s=[]):
        self.log=''
        self.setInputSignal(s)
        
    from ._logfun import addLog, dispLog
    from ._initfun import setInputSignal, initSetting, set_an, set_coef, set_dic_an, set_parameters_searchingZeros, set_r, setAFDMethod, setDecompMethod, setDicGenMethod
    from ._side import isempty, checkInput, Unit_Disk, Circle_Disk, e_a, e_a_r
    from ._decomposition import genDic, genEva, init_decomp
    from ._plot import plot_sig, plot_ori_sig, plot_point, plot_dic, plot_evaluator
    from ._search_parameter import search_r