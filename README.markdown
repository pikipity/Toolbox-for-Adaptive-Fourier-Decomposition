# Toolbox-for-Adaptive-Fourier-Decomposition

This toolbox is intended to help users use the adaptive Fourier decomposition (AFD) **easily**. 

This toolbox contains **multiple implementations** of the AFD for different types of processed signals and different decomposition process.

There is a [simple *online demo*](http://zewang.site/AFD) based on Python version v1.0. You can try the AFD quickly.

Please check the [**document**](https://toolbox-for-adaptive-fourier-decomposition.readthedocs.io/) for detailed information. 

## Advantages of AFD

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

## AFD methods included in the toolbox

+ Core AFD:
  + Single channel
    + without FFT (slow)
    + with FFT (fast)
  + Multi-channel
    + without FFT (slow)
    + with FFT (fast)
+ Unwinding AFD:
  + Single channel 
    + without FFT (slow)
    + with FFT (fast)
  + Multi-channel
    + without FFT (slow)
    + with FFT (fast)

## Related Papers

A list of papers related to the mathematical Foundation, implementations, and applications of the AFD can be found in the [document](https://toolbox-for-adaptive-fourier-decomposition.readthedocs.io/en/latest/IntroAFD.html).

If you use the single-channel AFD method in this toolbox, please at least cite these papers.

> T. Qian, L. Zhang, and Z. Li, “Algorithm of adaptive Fourier decomposition,” IEEE Trans. Signal Process., vol. 59, no. 12, pp. 5899–5906, 2011.

> T. Qian, Y. B. Wang, “Adaptive Fourier series -- a variation of greedy algorithm," Advances in Computational Mathematics, vol. 34, no. 3, pp. 279–293, 2011.

If you use the multi-channel AFD method in this toolbox, please at least cite [“Adaptive Fourier decomposition for multi-channel signal analysis”](https://doi.org/10.1109/TSP.2022.3143723).

> Z. Wang, C. M. Wong, A. Rosa, T. Qian, and F. Wan, “Adaptive Fourier decomposition for multi-channel signal analysis,” IEEE Trans. Signal Process., vol. 70, pp. 903–918, 2022.


## License

This toolbox follows ["Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)"](https://creativecommons.org/licenses/by-nc-nd/4.0/deed.en).

