.. Toolbox for Adaptive Fourier Decomposition documentation master file, created by
   sphinx-quickstart on Sat Jul 24 09:46:01 2021.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Toolbox for Adaptive Fourier Decomposition
=====================================================================

This toolbox is intended to help users use the adaptive Fourier decomposition (AFD) **easily**. 

This toolbox contains **different implementations** of the AFD for different types of processed signals and different decomposition process.

There is a `simple online demo <http://zewang.site/AFD>`_ based on Python version v1.0. You can try the AFD quickly.

This toolbox includes

+ Core AFD:

  + Single channel: 
  
    + without FFT (slow)
    + with FFT (fast)
  
  + Multi-channel:

    + without FFT (slow)
    + with FFT (fast)

+ Unwinding AFD:

  + Single channel: 
  
    + without FFT (slow)
    + with FFT (fast)

  + Multi-channel:

    + without FFT (slow)
    + with FFT (fast)

A list of papers related to the AFD can be found in Section `"Introduction to Adaptive Fourier Decomposition" <https://toolbox-for-adaptive-fourier-decomposition.readthedocs.io/en/latest/IntroAFD.html#papers-related-to-mathematical-foundation-and-implementations>`_.

If you use the single-channel AFD method in this toolbox, please at least cite `“Algorithm of adaptive Fourier decomposition” <http://ieeexplore.ieee.org/document/6021385/>`_.

      T. Qian, L. Zhang, and Z. Li, “Algorithm of adaptive Fourier decomposition,” IEEE Trans. Signal Process., vol. 59, no. 12, pp. 5899–5906, 2011.

If you use the multi-channel AFD method in this toolbox, please at least cite `“Adaptive Fourier decomposition for multi-channel signal analysis” <https://doi.org/10.1109/TSP.2022.3143723>`_.

      Z. Wang, C. M. Wong, A. Rosa, T. Qian, and F. Wan, “Adaptive Fourier decomposition for multi-channel signal analysis,” IEEE Trans. Signal Process., vol. 70, pp. 903–918, 2022.

Content
--------

.. toctree::
   :maxdepth: 2

   IntroAFD
   BuildToolbox
   UserAPI
   CodeSample
   AskHelp
   FutureWork
   License








   
