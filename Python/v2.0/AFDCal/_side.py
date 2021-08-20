# -*- coding: utf-8 -*-

import numpy as np
from numpy.matlib import repmat

def isempty(self,s):
    if np.shape(s)[0]==0:
        return True
    else:
        return False
    
def checkInput(self):
    errorFlag=[]
    if self.isempty(self.s):
        errorFlag.append(1)
    else:
        if np.shape(self.s)[1]<=np.shape(self.s)[0]:
            errorFlag.append(2)
        if len(np.shape(self.s))>2:
            errorFlag.append(3)
    return errorFlag

def Unit_Disk(self,dist,cont):
    t = np.array([np.arange(-1,1+0.1,0.1)])
    n = np.shape(t)[1]
    real = repmat(t,n,1)
    image = repmat(np.transpose(t),1,n)
    ret1 = real + 1j*image
    ret1[np.abs(ret1)>=cont] = None
    ret = ret1.copy()
    del ret1
    #
    remove_row=[]
    for i in range(np.shape(ret)[0]):
        if np.sum(np.isnan(ret[i,:]))==np.shape(ret)[1]:
            remove_row.append(i)
    ret = np.delete(ret, remove_row, 0)
    remove_col=[]
    for j in range(np.shape(ret)[1]):
        if np.sum(np.isnan(ret[:,i]))==np.shape(ret)[0]:
            remove_col.append(j)
    ret = np.delete(ret, remove_col, 1)

