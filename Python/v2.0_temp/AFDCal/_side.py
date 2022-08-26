# -*- coding: utf-8 -*-

import numpy as np
from numpy.matlib import repmat
import math

def blaschke1(self,r,t):
    x = math.e ** (1j*t)
    B = np.ones(np.shape(t))
    if r!=[]:
        a1 = []
        for a1_i in np.where(np.abs(r)!=0)[0]:
            a1.append(r[a1_i])
        for k in range(len(a1)):
            B=B*(x-a1[k])/(1-np.conj(a1[k])*x)*(-1*np.conj(a1[k])/np.abs(a1[k]))
            # B = B.*(x-a1(k))./(1-conj(a1(k))*x).*(-conj(a1(k))/abs(a1(k)));
        n=len(r)-len(a1)
        B=B*(x**n)
    return B

def e_a_r(self,a,z):
    num1=1
    num2=(1-np.conj(a)*z)
    ret =np.zeros((1,len(num2)),dtype=np.complex_)
    for k in range(len(num2)):
        if (num2[k]==0).all() or np.isnan(num2[k]).all():
            ret[0,k]=None
        else:
            ret[0,k]=num1/num2[k]
    return ret

def e_a(self,a,z):
    num1 = ((1-np.abs(a)**2)**0.5)
    num2 = (1-np.conj(a)*z)
    ret =np.zeros((1,len(num2)),dtype=np.complex_)
    for k in range(len(num2)):
        if (num2[k]==0).all() or np.isnan(num2[k]).all():
            ret[0,k]=None
        else:
            ret[0,k]=num1/num2[k]
    return ret

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
    t = np.array([np.arange(-1,1+dist,dist)])
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
        if np.sum(np.isnan(ret[:,j]))==np.shape(ret)[0]:
            remove_col.append(j)
    ret = np.delete(ret, remove_col, 1)
    #
    return ret

def Circle_Disk(self,dist,cont,phase):
    # generate magnitude and phase
    abs_a=np.array([np.arange(0,1,dist)])
    phase_a=phase.copy()
    #
    tmp=np.zeros((np.shape(abs_a)[1],np.shape(phase_a)[1]),dtype=np.complex_)
    for m in range(np.shape(abs_a)[1]):
        for l in range(np.shape(phase_a)[1]):
            tmp[m,l]=abs_a[0,m] * math.e ** ( 1j*phase_a[0,l] )
    ret1=tmp.copy()
    del tmp
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
        if np.sum(np.isnan(ret[:,j]))==np.shape(ret)[0]:
            remove_col.append(j)
    ret = np.delete(ret, remove_col, 1)
    #
    return ret