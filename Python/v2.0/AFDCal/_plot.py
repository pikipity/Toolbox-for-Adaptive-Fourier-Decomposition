from typing import Union, Optional, Dict, List, Tuple, Callable
from numpy import ndarray

import numpy as np
import matplotlib.pyplot as plt
from math import pi

def plot_dict(self,
              figsize: List[float] = [6.4, 4.8]):
    """
    Plot searching dictionary
    """
    fig = plt.figure(figsize=figsize)
    ax = fig.add_axes([0,0,1,1])

    ax.plot(np.real(self.dic_an), np.imag(self.dic_an), 'x')

    ax.grid(True)
    ax.set_xlabel('Real')
    ax.set_ylabel('Imag')
    ax.set_xlim([-1,1])
    ax.set_ylim([-1,1])
    ax.set_title('Searching Dictionary')

    return fig, ax

def plot_base(self,
              i,j,
              figsize: List[float] = [6.4, 4.8]):
    """
    Plot evaluators
    """
    dic_val = self.dic_an[i,j]
    base_val = self.Base[i,j,:]
    t = self.t[0,:]/(2*pi)

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
                figsize: List[float] = [6.4, 4.8]):
    """
    Plot decomposition component
    """
    ori_sig = self.s[0,:]
    base_val = self.deComp[level][0,:]
    t = self.t[0,:]/(2*pi)

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
                    figsize: List[float] = [6.4, 4.8]):
    """
    Plot basis component
    """
    base_val = self.tem_B[level][0,:]
    t = self.t[0,:]/(2*pi)

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