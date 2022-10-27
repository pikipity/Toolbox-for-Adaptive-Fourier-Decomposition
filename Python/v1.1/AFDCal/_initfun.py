from numpy import ndarray
from typing import Union, Optional, Dict, List, Tuple
import os.path as op
import numpy as np
import scipy.signal as pysig
from math import pi

from ._io import loaddata
from ._utils import genWeight

def initSetting(self):
    """
    Set all parameters to default values
    """
    self.s = [] # Original input signal
    self.G = [] # Analytic representation of the original input signal "s"
    self.t = [] # Phase of the original input signal "s"
    self.S1 = [] # Energy distribution
    self.max_loc = [] # Location of maximum energy
    self.weight = [] # Weight for computing numerical integration
    self.an = [] # Searching results of the basis parameter
    self.coef = [] # Decomposition coefficients 
    self.level = 0 # Decomposition level (initial level is 0)
    self.dic_an = [] # Searching dictionary of an
    self.Base = [] # Evaluators of searching an
    self.remainder = [] # Decomposition remainder
    self.tem_B = [] # Decomposition basis components
    self.deComp = [] # Decomposition components
    self.decompMethod = 1 # Decomposition methods:
                          # 1. Single Channel Conventional AFD (default)
                          # 2. Single Channel Fast AFD
    self.dicGenMethod = 1 # Dictionary generation methods:
                          # 1. Square (default)
                          # 2. Circle (Fast AFD must be "circle")
    self.AFDMethod = 1 # AFD methods:
                       # 1. core (default)
    self.log = ''
    self.run_time = [] # Running time of decomposition
    self.time_genDic = 0 # Running time of generating searching dictionary
    self.time_genEva = 0 # Running time of generating evaluators

def setDecompMethod(self,
                    decompMethod : Union[int, str]):
    """
    Set decomposition method

    Parameters
    -------------
    decompMethod : Union[int, str]
        The order or the name of the decomposition method
        Current supported methods:
            1. Single Channel Conventional AFD (default)
            2. Single Channel Fast AFD
            3. Multi-channel Conventional AFD (NOT FINISH)
            4. Multi-channel Fast AFD (NOT FINISH)
            5. Single Channel POAFD
    """
    HelpStr = "\nCurrent supported methods:\n1. Single Channel Conventional AFD (default)\n2. Single Channel Fast AFD"
    if type(decompMethod) is int:
        if decompMethod < 3 or decompMethod == 5:
            self.decompMethod = decompMethod
        else:
            raise ValueError("Unknow decomposition method." + HelpStr)
    elif type(decompMethod) is str:
        if decompMethod.lower() == 'Single Channel Conventional AFD'.lower():
            self.decompMethod = 1
        elif decompMethod.lower() == 'Single Channel Fast AFD'.lower():
            self.decompMethod = 2
        elif decompMethod.lower() == 'Single Channel POAFD'.lower():
            self.decompMethod = 5
        else:
            raise ValueError("Unknow decomposition method." + HelpStr)
    else:
        raise ValueError("The decomposition method must be an integer number or a string")
    

def setDicGenMethod(self,
                    dicGenMethod : Union[int, str]):
    """
    Set dictionary generation method

    Parameters
    -------------
    dicGenMethod : Union[int, str]
        The order or the name of the dictionary generation method
        Current supported methods:
            1. Square (default)
            2. Circle (Fast AFD must be "circle")
    """
    HelpStr = "\nCurrent supported methods:\n1. Square (default)\n2. Circle (Fast AFD must be 'circle')"
    if type(dicGenMethod) is int:
        if dicGenMethod < 3:
            self.dicGenMethod = dicGenMethod
        else:
            raise ValueError("Unknow dictionary generation method." + HelpStr)
    elif type(dicGenMethod) is str:
        if dicGenMethod.lower() == 'Square'.lower():
            self.dicGenMethod = 1
        elif dicGenMethod.lower() == 'Circle'.lower():
            self.dicGenMethod = 2
        else:
            raise ValueError("Unknow dictionary generation method." + HelpStr)
    else:
        raise ValueError("The dictionary generation method must be an integer number or a string")

def setAFDMethod(self,
                 AFDMethod : Union[int, str]):
    """
    Set AFD method

    Parameters
    -------------
    AFDMethod : Union[int, str]
        The order or the name of the AFD method
        Current supported methods:
            1. core (default)
    """
    HelpStr = "\nCurrent supported methods:\n1. core (default)"
    if type(AFDMethod) is int:
        if AFDMethod < 2:
            self.AFDMethod = AFDMethod
        else:
            raise ValueError("Unknow AFD method." + HelpStr)
    elif type(AFDMethod) is str:
        if AFDMethod.lower() == 'core'.lower():
            self.AFDMethod = 1
        else:
            raise ValueError("Unknow AFD method." + HelpStr)
    else:
        raise ValueError("The AFD method must be an integer number or a string")


def loadInputSignal(self, 
                    input_signal : Union[ndarray, str]):
    """
    Load input signal

    Parameters
    ----------------------
    input_signal : Union[ndarray, str] 
        The input signal. Now, the input signal must be a single-channel signal. 
        The format can be 
            + numpy array: Input signal. The dimension must be 1 * N where N is the total sampling number.
            + String: File of storing the input signal. Current supporting file format:
                - ".mat": matlab file. Signal is stored in a matrix called "G". The dimension must be 1 * N where N is the total sampling number.
                - ".npy": numpy file. Signal is stored in a numpy array called "G". The dimension must be 1 * N where N is the total sampling number.
    """
    # Load signal
    if type(input_signal) is str:
        # Check whether file exists
        if not op.exists(input_signal):
            raise ValueError("The provided input file location does not exist!!")
        # Load signal from file
        file_name, file_extension = op.splitext(input_signal)
        if len(file_extension) == 0:
            raise ValueError("Cannot get the extension of the input file!!")
        if file_extension[1:].lower() == 'mat':
            data = loaddata(input_signal, save_type = 'mat')
            s = data['G']
        elif file_extension[1:].lower() == 'npy':
            data = loaddata(input_signal, save_type = 'np')
            s = data['G']
        else:
            raise ValueError("Unknown extension of the input file!!")
    elif type(input_signal) is ndarray:
        s = input_signal.copy()
    else:
        raise ValueError("The type of 'input_signal' must be a numpy array or a string")
    # Check dimension
    if len(s.shape) == 1:
        s = np.expand_dims(s, axis = 0)
    if len(s.shape) != 2:
        raise ValueError("The dimension of the input signal must be 1*N !!")
    N_ch, N_sample = s.shape
    if N_ch == 1:
        print("The dimension of the input signal is {:n}*{:n}.".format(N_ch, N_sample))
    elif N_sample == 1:
        s = s.T
    else:
        raise ValueError("The dimension of the input signal must be 1*N !!")
    # Store signal
    self.s = s.copy()
    # Hilbert transform
    if np.isreal(self.s).all():
        self.G = pysig.hilbert(self.s)
    else:
        self.G = self.s.copy()
    # set phase
    N_ch, N_sample = self.G.shape
    # t = np.arange(0, 2*pi, 2*pi/N_sample)
    t = np.arange(0,N_sample)/N_sample*2*pi
    self.t = np.expand_dims(t, axis = 0)
    # generate weights
    self.weight = genWeight(N_sample)

def setPhase(self, 
             t : ndarray):
    """
    Set signal phase.
    After loading the input signal, the default phase (0~2\pi) will be automatically generated. 
    If you want to use this default phase, this function is useless.

    Parameters
    ----------------
    t : nadarray
        Signal phase. The dimension is 1*N where N is the sampling number of the input signal.
    """
    if len(self.s) == 0 or len(self.G) == 0:
        raise ValueError("Please give the input signal first!!")
    if type(t) is not ndarray:
        raise ValueError("The given signal phase must be a python ndarray !!")
    if t.ndim != 2:
        raise ValueError("The dimension of the given signal phase must be 1*N where N is the sampling number of the input signal")
    if t.shape[0] != 1 or t.shape[1] != self.s.shape[1]:
        raise ValueError("The dimension of the given signal phase must be 1*N where N is the sampling number of the input signal")

    self.t = t.copy()

def setPhase_min_max(self,
                     min_phase: float,
                     max_phase: float):
    """
    Generate and set signal phase.
    The generated signal phase is from 'min_phase' to 'max_phase' including 'min_phase'.
    """
    N_ch, N_sample = self.G.shape
    sep = (max_phase-min_phase)/(N_sample)
    t = np.arange(min_phase, max_phase, sep)
    self.t = np.expand_dims(t, axis = 0)

