# Toolbox for Adaptive Fourier Decomposition

The adaptive Fourier decomposition (AFD) is a generalization of the Fourier decomposition. It represents the given signal to a summation of mono-components that only possess non-negative analytic phase derivatives. In addition, with a matching pursuit strategy, the AFD offers fast energy decomposition via the basis adaptive to the intrinsic components of the given signal. Accordingly, the AFD has been successfully applied to the signal compression, separation, denoising and system identification.

This toolbox offers the MATLAB functions and Python functions for the core AFD and the inverse AFD. Users could input your own signals to functions directly to try the AFD method, observing the decomposition components of the AFD and developing your own applications.

For both MATLAB and Python versions, there are two kinds of implementations in this toolbox. One is the conventional AFD. The computation of the conventional AFD follows equations in ["Algorithm of Adaptive Fourier Decomposition"](http://ieeexplore.ieee.org/document/6021385/). Another one is the FFT based AFD. The objective function computation is optimized. The FFT based AFD is suggested due to its fast computation speed.

## Installation

### MATLAB Version

For MATLAB users, you only need to

1. Download this [toolbox](https://github.com/pikipity/Toolbox-for-Adaptive-Fourier-Decomposition/archive/master.zip)
2. Add the "Matlab" folder to your MATLAB searching path. For example, if your MATLAB folder path is `D:\Github\Toolbox-for-Adaptive-Fourier-Decomposition\Matlab`, you can use the following command in MATLAB: `addpath('D:\Github\Toolbox-for-Adaptive-Fourier-Decomposition\Matlab')`

### Python Version

For Python users, the following packages are required:

+ [NumPy](http://www.numpy.org/)
+ [SciPy](https://www.scipy.org/)
+ [matplotlib](http://matplotlib.org/)

After you have successfully downloaded and installed the above required packages, you only need to

1. Download this [toolbox](https://github.com/pikipity/Toolbox-for-Adaptive-Fourier-Decomposition/archive/master.zip)
2. Copy the `AFD.py` file in the Python folder to the Python searching path, like your own program root path.
3. In your own python program, you have to import functions in `AFD.py`. For example, you can use `from AFD import *`.

## Examples

For MATLAB users, in `Matlab/Example` folder, you can run `AFD_Example.m` to try the AFD.

For Python users, in `Python` folder, you can directly run `AFD.py` to try the AFD.

## Key Functions

+ Conventional AFD: `conv_AFD` (MATLAB and Python Versions)

  This function computes a_n and coefficients of decomposition components <e_{a_n},G_n> of the AFD following equations in ["Algorithm of Adaptive Fourier Decomposition"](http://ieeexplore.ieee.org/document/6021385/).
+ FFT based AFD: `FFT_AFD.m` (MATLAB and Python Versions)

  This function computes a_n and coefficients of decomposition components <e_{a_n},G_n> of the AFD using the FFT for the computation of objective function values.
+ Inverse AFD: `inverse_AFD` (MATLAB and Python Versions)

  This function computes the recovery signal using a_n and coefficients of decomposition components <e_{a_n},G_n> obtained from `conv_AFD.m` and `FFT_AFD.m`.
+ Components of the AFD: `comp_AFD` (MATLAB Version) and `component_AFD` (Python Version)

  This function computes evaluators e_{a_n}, basis B_n and decomposition components F_n

## Related Papers

### Mathematical Fundation

+ T. Qian, L. Zhang, and Z. Li, “[Algorithm of adaptive Fourier decomposition](http://ieeexplore.ieee.org/document/6021385/),” IEEE Trans. Signal Process., vol. 59, no. 12, pp. 5899–5906, 2011.
+ T. Qian and Y. Wang, “[Remarks on adaptive Fourier decomposition](http://www.worldscientific.com/doi/pdf/10.1142/S0219691313500070),” Int. J. Wavelets, Multiresolution Inf. Process., vol. 11, no. 1, p. 1350007, 2013.
+ T. Qian, “[Adaptive Fourier decompositions and rational approximations — part I: Theory](http://www.worldscientific.com/doi/pdf/10.1142/S0219691314610086),” Int. J. Wavelets, Multiresolution Inf. Process., vol. 12, no. 5, p. 1461008, 2014.
+ L. Zhang, W. Hong, W. Mai, and T. Qian, “[Adaptive Fourier decomposition and rational approximation — part II: Software system design and development](http://www.worldscientific.com/doi/pdf/10.1142/S0219691314610098),” Int. J. Wavelets, Multiresolution Inf. Process., vol. 12, no. 5, p. 1461009, 2014.
+ T. Qian, H. Li, and M. Stessin, “[Comparison of adaptive mono-component decompositions](http://www.sciencedirect.com/science/article/pii/S1468121812001770),” Nonlinear Anal. Real World Appl., vol. 14, no. 2, pp. 1055–1074, 2013.
+ Y. Gao, M. Ku, T. Qian, and J. Wang, “[FFT formulations of adaptive Fourier decomposition](http://www.sciencedirect.com/science/article/pii/S0377042717302005),” J. Comput. Appl. Math., Apr. 2017.

### Applications

+ Z. Wang, F. Wan, C. M. Wong, and L. Zhang, “[Adaptive Fourier decomposition based ECG denoising](http://www.sciencedirect.com/science/article/pii/S0010482516302104),” Comput. Biol. Med., vol. 77, pp. 195–205, 2016.
+ Z. Wang, C. M. Wong, J. N. da Cruz, F. Wan, P.-I. Mak, P. U. Mak, and M. I. Vai, “[Muscle and electrode motion artifacts reduction in ECG using adaptive Fourier decomposition](http://ieeexplore.ieee.org/document/6974120/),” in 2014 IEEE International Conference on Systems, Man, and Cybernetics (SMC), 2014, pp. 1456–1461.
+ Z. Wang, J. Nuno da Cruz, and F. Wan, “[Adaptive Fourier decomposition approach for lung-heart sound separation](http://ieeexplore.ieee.org/document/7158631/),” in 2015 IEEE International Conference on Computational Intelligence and Virtual Environments for Measurement Systems and Applications (CIVEMSA), 2015, pp. 1–5.
+ J. Ma, T. Zhang, and M. Dong, “[A novel ECG data compression method using adaptive Fourier decomposition with security guarantee in e-health applications](http://ieeexplore.ieee.org/document/6897915/),” IEEE J. Biomed. Heal. Informatics, vol. 19, no. 3, pp. 986–994, 2015.
+ W. Mi and T. Qian, “[Frequency-domain identification: An algorithm based on an adaptive rational orthogonal system](http://www.sciencedirect.com/science/article/pii/S0005109812000982),” Automatica, vol. 48, no. 6, pp. 1154–1162, 2012.
+ L. Zhang, “[Adaptive Fourier decomposition based signal instantaneous frequency computation approach](http://waset.org/publications/2536/adaptive-fourier-decomposition-based-signal-instantaneous-frequency-computation-approach),” Int. J. Math. Comput. Phys. Electr. Comput. Eng., vol. 6, no. 8, pp. 1117–1122, 2012.
