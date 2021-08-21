# -*- coding: utf-8 -*-

from matplotlib import pyplot as pt
import math
import numpy as np

def plot_sig(self,t,s,xlab,ylab):
    for k in range(len(t)):
        pt.plot(t[k],s[k],linewidth=2)
    pt.grid(True)
    min_t=math.inf
    max_t=-math.inf
    for k in range(len(t)):
        if min_t>min(t[k]):
            min_t=min(t[k])
        if max_t<max(t[k]):
            max_t=max(t[k])
    if min_t==max_t:
        max_t=max_t+0.001
    min_s=math.inf
    max_s=-math.inf
    for k in range(len(t)):
        if min_s>min(s[k]):
            min_s=min(s[k])
        if max_s<max(s[k]):
            max_s=max(s[k])
    if min_s==max_s:
        max_s=max_s+0.001
    pt.axis((min_t, max_t, min_s, max_s))
    pt.xlabel(xlab)
    pt.ylabel(ylab)
    
def plot_point(self,t,s,xlab,ylab):
    pt.plot(t,s,'x')
    pt.grid(True)
    min_t=math.inf
    max_t=-math.inf
    for k in range(len(t)):
        if min_t>min(t[k]):
            min_t=min(t[k])
        if max_t<max(t[k]):
            max_t=max(t[k])
    if min_t==max_t:
        max_t=max_t+0.001
    min_s=math.inf
    max_s=-math.inf
    for k in range(len(t)):
        if min_s>min(s[k]):
            min_s=min(s[k])
        if max_s<max(s[k]):
            max_s=max(s[k])
    if min_s==max_s:
        max_s=max_s+0.001
    pt.axis((min_t, max_t, min_s, max_s))
    pt.xlabel(xlab)
    pt.ylabel(ylab)
    
    
def plot_ori_sig(self):
    pt.figure('Original Signal')
    K=np.shape(self.G)[0]
    for ch_i in range(K):
        pt.subplot(K,1,ch_i+1)
        self.plot_sig([self.t[ch_i,:]],[np.real(self.G[ch_i,:])],'phase','channel '+str(ch_i+1))
        
def plot_dic(self):
    pt.figure('Searching Dictionary')
    K=np.shape(self.G)[0]
    for ch_i in range(K):
        if K<=5:
            pt.subplot(1,K,ch_i+1)
        else:
            pt.subplot(np.ceil(K/5),5,ch_i+1)
        self.plot_point(np.real(self.dic_an[ch_i]),np.imag(self.dic_an[ch_i]),'Real','Imag')
        pt.axis((-1, 1, -1, 1))
        pt.title('Channel '+str(ch_i+1))
        
def plot_evaluator(self):
    K=np.shape(self.G)[0]
    for ch_i in range(K):
        pt.figure('Magnitude of Evaluators, Ch '+str(ch_i))
        Base=self.Base[ch_i]
        a=self.dic_an[ch_i]
        N=np.shape(Base)[0]
        M=np.shape(Base)[1]
        if N>1:
            m=int(np.floor(M/2))
            pt.subplot(1,2,1)
            legend_label=[]
            ind=np.unique(np.floor(np.linspace(1,N-1,5)))
            plot_t=[]
            plot_s=[]
            for k in range(len(ind)):
                plot_t.append(self.t[ch_i,:])
                x_ind=int(ind[k])
                y_ind=int(m)
                plot_s.append(np.abs(Base[x_ind,y_ind,:]))
                legend_label.append('a='+str(a[x_ind,y_ind]))
            self.plot_sig(plot_t,plot_s,'phase',' ')
            pt.legend(legend_label)
        if N>1:
            k=np.floor(N/2)
        else:
            k=0
        pt.subplot(1,2,2)
        legend_label=[]
        ind=np.unique(np.floor(np.linspace(1,M-1,5)))
        plot_t=[]
        plot_s=[]
        for m in range(len(ind)):
            plot_t.append(self.t[ch_i,:])
            x_ind=int(k)
            y_ind=int(ind[m])
            plot_s.append(np.abs(Base[x_ind,y_ind,:]))
            legend_label.append('a='+str(a[x_ind,y_ind]))
        self.plot_sig(plot_t,plot_s,'phase',' ')
        pt.legend(legend_label)
    K=np.shape(self.G)[0]
    for ch_i in range(K):
        pt.figure('Phase of Evaluators, Ch '+str(ch_i))
        Base=self.Base[ch_i]
        a=self.dic_an[ch_i]
        N=np.shape(Base)[0]
        M=np.shape(Base)[1]
        if N>1:
            m=np.floor(M/2)
            pt.subplot(1,2,1)
            legend_label=[]
            ind=np.unique(np.floor(np.linspace(1,N-1,5)))
            plot_t=[]
            plot_s=[]
            for k in range(len(ind)):
                plot_t.append(self.t[ch_i,:])
                x_ind=int(ind[k])
                y_ind=int(m)
                plot_s.append(np.angle(Base[x_ind,y_ind,:]))
                legend_label.append('a='+str(a[x_ind,y_ind]))
            self.plot_sig(plot_t,plot_s,'phase',' ')
            pt.legend(legend_label)
        if N>1:
            k=np.floor(N/2)
        else:
            k=0
        pt.subplot(1,2,2)
        legend_label=[]
        ind=np.unique(np.floor(np.linspace(1,M-1,5)))
        plot_t=[]
        plot_s=[]
        for m in range(len(ind)):
            plot_t.append(self.t[ch_i,:])
            x_ind=int(k)
            y_ind=int(ind[m])
            plot_s.append(np.angle(Base[x_ind,y_ind,:]))
            legend_label.append('a='+str(a[x_ind,y_ind]))
        self.plot_sig(plot_t,plot_s,'phase',' ')
        pt.legend(legend_label)
            
def plot_decompComp(self,level):
    if level>self.level:
        raise ValueError('Level is too large')
    if level<0:
        raise ValueError('Level is too small')
    pt.figure('Decomposition Component at level '+str(level))
    K=np.shape(self.G)[0]
    for ch_i in range(K):
        pt.subplot(K,1,ch_i+1)
        self.plot_sig([self.t[ch_i,:],self.t[ch_i,:]],
                    [np.real(self.G[ch_i,:]),np.real(self.deComp[ch_i][level][0,:])],
                    'phase',' ')
        pt.legend(['Original Signal','Decomposition Component'])
        
def plot_reSig(self,level):
    if level>self.level:
        raise ValueError('Level is too large')
    if level<0:
        raise ValueError('Level is too small')
    pt.figure('Reconstructed Signal of first '+str(level)+' levels')
    K=np.shape(self.G)[0]
    for ch_i in range(K):
        pt.subplot(K,1,ch_i+1)
        for n in range(level+1):
            if n==0:
                reSig=self.deComp[ch_i][n][0,:]
            else:
                reSig += self.deComp[ch_i][n][0,:]
        self.plot_sig([self.t[ch_i,:],self.t[ch_i,:]],
                    [np.real(self.G[ch_i,:]),np.real(reSig)],
                    'phase',' ')
        pt.legend(['Original Signal','Reconstructed Signal'])