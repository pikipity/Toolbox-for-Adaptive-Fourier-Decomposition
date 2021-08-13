# Toolbox-for-Adaptive-Fourier-Decomposition

This toolbox is intended to help users use the adaptive Fourier decomposition (AFD) **easily**. 

This toolbox contains **different implementations** of the AFD for different types of processed signals and different decomposition process.

There is a [simple *online demo*](http://zewang.site/AFD). You can try the AFD quickly.

Please check the [**document**](https://toolbox-for-adaptive-fourier-decomposition.readthedocs.io/) for detailed information. 

**Advantages of AFD**:

+ Adaptive decomposition:
  + Adaptive basis;
  + Orthogonal decomposition components;
  + Decomposition components are  mono-components that only contain non-negative analytic phase derivatives;
  + Fast energy convergence;
  + Rigorous mathematical foundation.
+ Provide the transient time-frequency distribution:
  + Correct total energy;
  + Non-negative real-valuedness;
  + Weak and strong finite suports.

**AFD methods included in the toolbox**:

+ Core AFD:
  + Single channel core AFD without FFT (slow)
  + Single channel core AFD with FFT (fast)
+ Unwinding AFD:
  + Single channel unwinding AFD without FFT (slow)
  + Single channel unwinding AFD with FFT (fast)

