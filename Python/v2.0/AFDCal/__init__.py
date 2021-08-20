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
    from ._initfun import setInputSignal, initSetting
    from ._side import isempty, checkInput, Unit_Disk
    from ._decomposition import genDic