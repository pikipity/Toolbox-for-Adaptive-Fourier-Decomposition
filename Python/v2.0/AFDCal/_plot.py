from typing import Union, Optional, Dict, List, Tuple, Callable
from numpy import ndarray

import numpy as np
import matplotlib.pyplot as plt
from math import pi

from ._utils import intg, Circle_Disk

def plot_dict(self,
              i_ch : int = 0,
              figsize: List[float] = [6.4, 4.8]):
    """
    Plot searching dictionary
    """
    fig = plt.figure(figsize=figsize)
    ax = fig.add_axes([0,0,1,1])

    if self.decompMethod == 1 or self.decompMethod == 5:
        dic_an = self.dic_an[i_ch]
    elif self.decompMethod == 2:
        dic_an = self.dic_an_search[i_ch]
    
    ax.plot(np.real(dic_an), np.imag(dic_an), 'x')

    ax.grid(True)
    ax.set_xlabel('Real')
    ax.set_ylabel('Imag')
    ax.set_xlim([-1,1])
    ax.set_ylim([-1,1])
    ax.set_title('Searching Dictionary')

    return fig, ax

def plot_base_random(self,
                     i_ch: int = 0,
                     figsize: List[float] = [6.4, 4.8]):
    """
    Randomly select one evaluator and plot it
    """
    row_dic, col_dic = self.dic_an[i_ch].shape
    fig, ax = self.plot_base(np.random.randint(0,row_dic), np.random.randint(0,col_dic), i_ch, figsize)
    return fig, ax

def plot_base(self,
              i,j,
              i_ch: int = 0,
              figsize: List[float] = [6.4, 4.8]):
    """
    Plot evaluators
    """
    row_dic, col_dic = self.dic_an[i_ch].shape
    if i > row_dic-1:
        raise ValueError("The row number cannot be larger than {:n}".format(row_dic-1))
    if j > col_dic-1:
        raise ValueError("The column number cannot be larger than {:n}".format(col_dic-1))

    dic_val = self.dic_an[i_ch][i,j]
    base_val = self.Base[i_ch][i,j,:]
    t = self.t[i_ch,:]/(2*pi)

    fig = plt.figure(figsize=figsize)

    ax = fig.add_axes([0,0.4,1,0.3])
    ax.plot(t, np.abs(base_val))
    ax.grid(True)
    ax.set_ylabel('Magnitude of Evaluator')
    ax.set_xlabel(r'Phase ($2\pi$)')
    a_angle = np.angle(dic_val)/(2*pi)
    while a_angle < 0:
        a_angle += 1
    while a_angle > 1:
        a_angle -= 1
    ax.set_title(r'Evaluator at $a = {:n} \cdot e^{{2\pi j \cdot ({:n}) }}$'.format(np.abs(dic_val), a_angle))

    ax = fig.add_axes([0,0,1,0.3])
    ax.plot(t, np.angle(base_val))
    ax.grid(True)
    ax.set_ylabel('Phase of Evaluator')
    ax.set_xlabel(r'Phase ($2\pi$)')

    return fig, ax

def plot_decomp(self,
                level,
                i_ch: int = 0,
                figsize: List[float] = [6.4, 4.8]):
    """
    Plot decomposition component
    """
    if level > self.level:
        raise ValueError("Level cannot be larger than {:n}".format(self.level))

    ori_sig = self.s[i_ch,:]
    base_val = self.deComp[i_ch][level][0,:]
    t = self.t[i_ch,:]/(2*pi)

    fig = plt.figure(figsize=figsize)

    ax = fig.add_axes([0,0,1,1])
    ax.plot(t, np.real(ori_sig), 'b-')
    ax.plot(t, np.real(base_val), 'r-')
    
    ax.grid(True)
    # ax.set_ylabel('Real part')
    ax.set_xlabel(r'Phase ($2\pi$)')
    ax.set_title('Decomposition Component at level={:n}'.format(level))

    ax.legend(labels=['Original signal',
                      'Decomposition component'])

    return fig, ax

def plot_basis_comp(self,
                    level,
                    i_ch: int = 0,
                    figsize: List[float] = [6.4, 4.8]):
    """
    Plot basis component
    """
    if level > self.level:
        raise ValueError("Level cannot be larger than {:n}".format(self.level))

    base_val = self.tem_B[i_ch][level][0,:]
    t = self.t[i_ch,:]/(2*pi)

    fig = plt.figure(figsize=figsize)

    ax = fig.add_axes([0,0.4,1,0.3])
    ax.plot(t, np.real(base_val))
    ax.grid(True)
    ax.set_ylabel('Real part')
    ax.set_xlabel(r'Phase ($2\pi$)')
    ax.set_title('Basis Component at level={:n}'.format(level))

    ax = fig.add_axes([0,0,1,0.3])
    ax.plot(t, np.imag(base_val))
    ax.grid(True)
    ax.set_ylabel('Imaginary part')
    ax.set_xlabel(r'Phase ($2\pi$)')

    return fig, ax

def plot_ori_sig(self,
                 i_ch: int = 0,
                figsize: List[float] = [6.4, 4.8]):
    """
    Plot original signal
    """

    ori_sig = self.s[i_ch,:]
    t = self.t[i_ch,:]/(2*pi)

    fig = plt.figure(figsize=figsize)

    ax = fig.add_axes([0,0,1,1])
    ax.plot(t, np.real(ori_sig), 'b-')
    ax.grid(True)
    ax.set_xlabel(r'Phase ($2\pi$)')
    ax.set_title('Input Signal')

    return fig, ax

def plot_re_sig(self,
                level,
                i_ch: int = 0,
                figsize: List[float] = [6.4, 4.8]):
    """
    Plot reconstructed signal
    """
    if level > self.level:
        raise ValueError("Level cannot be larger than {:n}".format(self.level))

    ori_sig = self.s[i_ch,:]
    base_val = self.reconstrct(level)[i_ch,:]
    t = self.t[i_ch,:]/(2*pi)

    fig = plt.figure(figsize=figsize)

    ax = fig.add_axes([0,0,1,1])
    ax.plot(t, np.real(ori_sig), 'b-')
    ax.plot(t, np.real(base_val), 'r-')
    ax.grid(True)
    ax.set_xlabel(r'Phase ($2\pi$)')
    ax.set_title('Reconstructed signal at level={:n}'.format(level))

    ax.legend(labels=['Original signal',
                      'Reconstructed signal'])

    return fig, ax

def plot_remainder(self,
                   level,
                   i_ch: int = 0,
                   figsize: List[float] = [6.4, 4.8]):
    """
    Plot Remainder
    """
    if level > self.level:
        raise ValueError("Level cannot be larger than {:n}".format(self.level))

    ori_sig = self.s[i_ch,:]
    base_val = self.reconstrct(level)[i_ch,:]
    t = self.t[i_ch,:]/(2*pi)

    fig = plt.figure(figsize=figsize)

    ax = fig.add_axes([0,0,1,1])
    ax.plot(t, np.real(ori_sig), 'b-')
    ax.plot(t, np.real(ori_sig - base_val), 'r-')
    ax.grid(True)
    ax.set_xlabel(r'Phase ($2\pi$)')
    ax.set_title('Remainder at level={:n}'.format(level))

    ax.legend(labels=['Original signal',
                      'Remainder'])

    return fig, ax

def plot_energy_rate(self,
                     level,
                     i_ch: int = 0,
                     figsize: List[float] = [6.4, 4.8]):
    """
    Plot energy ratio
    """
    if level > self.level:
        raise ValueError("Level cannot be larger than {:n}".format(self.level))

    energyrate = np.zeros((level+2))
    x_level = np.zeros((level+2))
    for k in range(level+2):
        if k==0:
            energyrate[k] = np.abs(intg(np.real(self.s[[i_ch],:]),np.real(self.s[[i_ch],:]),self.weight))[0,0]
            x_level[k] = k
        else:
            energyrate[k] = np.abs(intg(np.real(self.s[[i_ch],:]-self.reconstrct(k-1)[[i_ch],:]),np.real(self.s[[i_ch],:]-self.reconstrct(k-1)[[i_ch],:]),self.weight))[0,0]
            x_level[k] = k
    energyrate = energyrate/energyrate[0]
    x_labels=[]
    for x_tick in x_level:
        if x_tick==0:
            x_labels.append('Ori')
        else:
            x_labels.append(str(x_tick-1))

    fig = plt.figure(figsize=figsize)

    ax = fig.add_axes([0,0,1,1])
    ax.plot(x_level, energyrate, 'x-')
    ax.set_xticks(x_level)
    ax.set_xticklabels(x_labels)
    ax.grid(True)
    ax.set_ylabel('Energy Rate')
    ax.set_xlabel('Decomposition Level')
    ax.set_title('Energy Convergence Rate at level={:n}'.format(level))

    return fig, ax

def plot_searchRes(self,
                   level,
                   i_ch: int = 0,
                   figsize: List[float] = [6.4, 4.8]):
    """
    Plot searching result
    """
    if level > self.level:
        raise ValueError("Level cannot be larger than {:n}".format(self.level))
    if self.decompMethod == 1 or self.decompMethod == 5:
        dic_an = self.dic_an[i_ch]
    elif self.decompMethod == 2:
        dic_an = self.dic_an_search[i_ch]

    S1 = self.S1[i_ch][level]
    S1[np.isnan(dic_an)]=None
    if self.dicGenMethod == 1:
        x = np.real(dic_an)
        for i in range(x.shape[0]):
            if not np.isnan(x[i,:]).any():
                break
        x = x[i,:]
        x = np.expand_dims(x, axis = 0)
        x = np.repeat(x,S1.shape[1],0)

        y = np.imag(dic_an)
        for i in range(y.shape[1]):
            if not np.isnan(y[:,i]).any():
                break
        y = y[:,i]
        y = np.expand_dims(y, axis = 1)
        y = np.repeat(y,S1.shape[0],1)
    elif self.dicGenMethod == 2:
        x = np.abs(dic_an)
        y = np.angle(dic_an)/(2*pi)
        y[y<0] += 1

    fig = plt.figure(figsize=figsize)

    ax = fig.add_axes([0,0,1,1])
    ax.contour(x,y,S1,levels=14,linewidths=0.5,colors='k')
    cntr=ax.contourf(x,y,S1,levels=14,cmap='RdBu_r')
    max_x = self.max_loc[i_ch][level][0,0]
    max_y = self.max_loc[i_ch][level][0,1]
    ax.plot(x[max_x,max_y],y[max_x,max_y],'rx',ms=20,mew=10)
    if self.dicGenMethod == 1:
        ax.set_xlabel('Real part')
        ax.set_ylabel('Imaginary part')
    elif self.dicGenMethod == 2:
        ax.set_xlabel(r'$\|a_n\|$')
        ax.set_ylabel(r'$\angle a_n\;\;(2\pi)$')
    ax.set_title('Searching Result at level={:n}'.format(level))
    fig.colorbar(cntr,ax=ax)

    return fig, ax

def plot_an(self,
            level,
            i_ch: int = 0,
            figsize: List[float] = [6.4, 4.8]):
    """
    Plot basis parameters a_n
    """
    if level > self.level:
        raise ValueError("Level cannot be larger than {:n}".format(self.level))

    fig = plt.figure(figsize=figsize)

    ax = fig.add_axes([0,0,1,1],
                      projection = 'polar')
    theta = [np.angle(an) for an in self.an[i_ch][:level+1]]
    r = [np.abs(an) for an in self.an[i_ch][:level+1]]
    ax.plot(theta, r, 'x')
    ax.grid(True)
    ax.set_rmax(1)
    ax.set_title(r'Basis Parameters $a_n$ at level={:n}'.format(level))

    return fig, ax