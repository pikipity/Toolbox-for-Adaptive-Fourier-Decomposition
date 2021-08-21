# -*- coding: utf-8 -*-

from scipy.io import loadmat
import h5py
import numpy as np

from AFDCal import AFDCal
            

            
if __name__=="__main__":
    # load data
    data = loadmat('bump_signal.mat')
    L = 1080
    s = np.zeros((4,L))
    s[0,:] = data['G'].copy()[0,0:L]
    data = loadmat('doppler_signal.mat')
    s[1,:] = data['G'].copy()[0,0:L]
    data = loadmat('heavysine_signal.mat')
    s[2,:] = data['G'].copy()[0,0:L]
    f = h5py.File('ECG.mat')
    for k,v in f.items():
        if k=='G':
            data = np.transpose(np.array(v))
    s[3,:] = data[0,0:L]
    del data
    # init AFD calculation
    afdcal = AFDCal(s)
    #afdcal.plot_ori_sig()
    afdcal.setAFDMethod(1) # 1:core; 2. unwinding
    # generate dictionary
    afdcal.setDicGenMethod(2) # 1. square; 2. circle
    afdcal.setDecompMethod(1) # 1. Single Channel Conventional AFD; 
                              # 2. Single Channel Fast AFD
    afdcal.genDic(0.1,0.9)
    #afdcal.plot_dic()
    # generate evaluator
    afdcal.genEva()
    #afdcal.plot_evaluator()
    afdcal.init_decomp()
    #afdcal.plot_decompComp(0)
    #afdcal.plot_reSig(0)
    
        