.. _introductionAFD-label:

Introduction to Adaptive Fourier Decomposition
=====================================================================

The adaptive Fourier decomposition is an **adaptive** signal decomposition:

+ Compared with the conventional signal decomposition methods, e.g. Fourier decomposition and wavelet decomposition, the AFD uses **adaptive orthogonal basis**. These adaptive basis can make the decomposition components match the processed signals best and thus can provide good time-frequency resolution without pre-defined basis. 
+ Compared with other adaptive decomposition methods, e.g. empirical mode decomposition (EMD), the AFD has the **rigorous mathematical foundation**, which allowed users further analyze detailed decomposition coefficients and decomposition components.

Chinese introduction blogs related to the basic principles of the AFD and the implementation of the fast AFD can be found in `zewang.site <http://zewang.site/bloglist>`_.

Basic Idea
-------------

The AFD decomposes the processed signal :math:`g(t)` to a series of **orthogonal** signals, which can be expressed as

.. math::

   g(t) = \sum_{n=1}^\infty A_n B_n(t),

where :math:`A_n` is the decomposition coefficient, :math:`B_n(t)` is the decomposition basis component, and :math:`n` denotes the decomposition level. The decomposition is from :math:`n=1` to :math:`n=\infty`. In each decomposition level, a suitable basis component is generated **adaptively** to make sure that the corresponding decomposition component **matches the processed signal best**. Such decomposition process can provide a fast energy convergence. In other words, the AFD applies `matching pursuit <https://en.wikipedia.org/wiki/Matching_pursuit>`_ process to provide a **sparse** approximation of the processed signal. 

It should be noticed that, before using the AFD, the recorded signals should be transferred to their analytic form. This transform can be achieved by the Hilbert transform, which is 

.. math::

   g(t)=s(t)+\mathcal{H}\left\{s(t)\right\},

where :math:`s(t)` is the recorded signal. 

.. _decomposition-basis:

Decomposition Basis
----------------------

The AFD uses the Blaschke product, or say the rational orthogonal system, :math:`\left\{B_n\right\}_{n=1}^\infty` as its basis where

.. math::

   B_n(t)=\frac{\sqrt{1-\left| a_n \right|^2}}{1-\overline{a}_ne^{jt}}\prod_{k=1}^{n-1}\frac{e^{jt}-a_k}{1-\overline{a}_ke^{jt}}.

It should be noticed that, in the decomposition level :math:`n`, the basis component :math:`B_n` is only determined by :math:`\left\{a_k\right\}_{k=1}^n`. Suppose parameters :math:`a_k` from :math:`k=1` to :math:`k=n-1` have been obtained in previous decomposition levels, only :math:`a_n` needs to be found in the decomposition level :math:`n`. 

It should be noticed that :math:`t` in :math:`B_n(t)` does not denote the time sample but denotes the **phase**. :math:`t` in :math:`B_n(t)` is like :math:`\theta` in :math:`\sin(\theta)`. Normally, :math:`t` is defined from :math:`0` to :math:`2\pi`. According to requirements of specific applications, :math:`t` also can be defined in other ranges.

The basis parameter :math:`a_n` is defined in the unit circle :math:`\mathbb{D}` of the complex plane :math:`\mathbb{C}` where :math:`\mathbb{D}=\left\{ z\in\mathbb{C}: \left| z \right|<1 \right\}`. The effects of :math:`a_n` for :math:`B_n(t)` are similar as the effects of shift and scaling factors for the wavelet decomposition as shown in the following figure. Moreover, when :math:`a_1= \cdots =a_n=0`, the basis component of the AFD becomes the basis component of the conventional Fourier decomposition. 

.. image:: ./_static/AFD_Bn_diff_a.png
   :width: 600px

Decomposition Process
----------------------

As mentioned in `Basic Idea`_, the AFD adopts the idea of the matching pursuit to achieve the fast energy convergence. There are different extensions (or say versions) of the AFD. Although these extensions of the AFD all uses the rational orthogonal system and have the same target that is to achieve the fast energy convergence, they apply different decomposition process. 

In this toolbox, the following extensions of the AFD have been included. 

Core AFD
^^^^^^^^^^^

The core AFD is the fundamental implementation of the AFD. It is an **iterative decomposition process**. In each decomposition level :math:`n`, the basis parameter :math:`a_n` is searched by

.. math::

   a_n = \arg\max_{a\in\mathbb{A}}\left\{ \left| \left< G_n(t),\text{e}_{\left\{ a \right\}}(t) \right> \right| \right\},

where :math:`G_n(t)`, called reduced remainder, is computed from the remainder in the last decomposition level and :math:`\text{e}_{\left\{ a \right\}}(t)` is the evaluator of the basis parameter :math:`a`. :math:`\left| \left< G_n(t),\text{e}_{\left\{ a \right\}}(t) \right> \right|` is the extracted energy when using :math:`a` as :math:`a_n`. The detailed evaluation process can be found in `"Algorithm of adaptive Fourier decomposition" <http://ieeexplore.ieee.org/document/6021385/>`_.

The reduced remainder :math:`G_n(t)` can be computed by

.. math::
   :nowrap:

   \begin{eqnarray}
      G_n(t) & = & R_{n-1}(t)\prod_{k=1}^{n-1}\frac{1-\overline{a}_d e^{jt}}{e^{jt}-a_d}\\
             & = & \left( G_{n-1}(t)-A_{n-1}\text{e}_{\left\{a_{n-1}\right\}}(t) \right)\frac{1-\overline{a}_{n-1}e^{jt}}{e^{jt}-a_{n-1}}.
   \end{eqnarray}

The evaluator :math:`\text{e}_{\left\{ a \right\}}(t)` is defined as 

.. math::

   \text{e}_{\left\{ a \right\}}(t) = \frac{\sqrt{1-\left|a\right|^2}}{1-\overline{a}e^{jt}}.

The set :math:`\mathbb{A}` is the searching range of :math:`a_n`. Normally, it is set as :math:`\mathbb{A}=\mathbb{D}`. According to requirements of specific applications, :math:`\mathbb{A}` also can be set as a subset of :math:`\mathbb{D}`. It should be noticed that, in real implementation, it is impossible to scan all possible values in :math:`\mathbb{A}`. Therefore, :math:`\mathbb{A}` needs to be discretized. In this toolbox, there are several different ways to discretize :math:`\mathbb{A}`. Of course, the higher density of points in the discretized :math:`\mathbb{A}`, the higher accurate optimization results of :math:`a_n`. The discretized :math:`\mathbb{A}` is called search dictionary of :math:`a_n`.

The basic decomposition process of the core AFD is shown below.

.. graphviz::

   digraph core_AFD {
      splines = ortho;
      size="10,5";

      a -> b[weight=100];
      b -> c[weight=100];
      c -> i[weight=100];
      i -> d[weight=100];
      a[label="Start" shape=parallelogram];
      b[label="Generate searching dictionary" shape=box];
      c[label="Generate evaluators" shape=box];
      i[label="Initialize decomposition" shape=box];


      subgraph cluster_decomposition_loop{
         label=<Decomposition Loop>;
         labeljust=l;
         style=dotted;
         subgraph cluster_searching_an {
            d -> e[weight=100];
            d[label=<Calculate objective function values of a<SUB>n</SUB>> shape=box];
            e[label=<Obtain a<SUB>n</SUB> by searching the maximum objective function value> shape=box];
            label = <Searching a<SUB>n</SUB>>;
            labeljust=l;
            style=dotted;
         }         
         e -> f[weight=100];
         f -> g[weight=100];
         g -> d[weight=1];
         f[label="Construct the decomposition component" shape=box];
         g[label="Compute reduced remainder" shape=box];
      }


      
   }
   

|

Unwinding AFD
^^^^^^^^^^^^^^

The unwinding AFD is similar as the core AFD but considers the **inner function**. The inner function is identical with the Blaschke product defined by zeros of the reduced remainder. The inner functions can be considered as a stable oscillations. If the processed signals contain **stable oscillations**, you may would like to use the unwinding AFD to achieve faster energy convergence. 

By considering the inner functions, the decomposition basis components can be described as

.. math::

   B_{n,\text{unwinding}}(t)=B_n(t)\prod_{i=1}^nI_i(t),

where the inner function :math:`I_i(t)` is

.. math::

   I_i(t)=\prod_{h=1}^{H_i}\frac{e^{jt}-r_{i,h}}{1-\overline{r}_{i,h}e^{jt}}.

The basis parameter :math:`a_n` can be searched by

.. math::

   a_n = \arg\max_{a\in\mathbb{A}}\left\{ \left| \left<  \frac{G_n(t)}{I_n(t)},\text{e}_{\left\{ a \right\}}(t) \right> \right| \right\}.

The parameters :math:`\left\{r_{n,h}\right\}_{h=1}^{H_n}` are zeros of the reduced remainder. They are defined in :math:`\mathbb{D}` and need to satisfy :math:`G_n(r_{n,1})=G_n(r_{n,2})= \cdots =G_n(r_{n,H_n})=0`. According to the Cauchy formula, this requirement can be represented as :math:`\left< G_n(t),\frac{1}{1-\overline{r}_{n,h}e^{jt}} \right>=0 \forall h=1,\cdots,H_n`.

In real implementation, :math:`r_{n,h}` can be searched iteratively, whcih is similar as the searching process of :math:`a_n`. The searching process is from :math:`h=1` to :math:`h=H_n`. :math:`r_{n,h}` can be searched by solving

.. math::
   :nowrap:

   \begin{eqnarray}
      \text{minimize} & \; & \left| \left< G_n(t)\prod_{i=1}^{h-1}\frac{1-\overline{r}_{n,i}e^{jt}}{e^{jt}-r_{n,i}},\frac{1}{1-\overline{r}e^{jt}} \right> \right|\\
      \text{subject to} & \; & r\in\mathbb{R} \text{ and } \left| \left< G_n(t),\frac{1}{1-\overline{r}e^{jt}} \right> \right|<\epsilon.
   \end{eqnarray}

:math:`\mathbb{R}` is the searching range of zeros. To simplify the computation, the searching dictionary of zeros is set as the same as the searching dictionary of :math:`a_n`. Moreover, :math:`\epsilon` is threshold to check whether the objective function value is close to 0 and thus should be set as a very small value. 

The basic decomposition process of the unwinding AFD is shown below.

.. graphviz::

   digraph unwinding_AFD {
      splines = ortho;
      size="10,8";

      a -> b[weight=100];
      b -> c[weight=100];
      c -> i[weight=100];
      i -> d_r[weight=100];

      a[label="Start" shape=parallelogram];
      b[label="Generate searching dictionary" shape=box];
      c[label="Generate evaluators" shape=box];
      i[label="Initialize decomposition" shape=box];

      subgraph cluster_decomposition_loop{
         label = <Decomposition Loop>;
         labeljust=l;
         style=dotted;

         subgraph cluster_searching_an {
            d -> e[weight=100];
            d[label=<Calculate objective function values of a<SUB>n</SUB>> shape=box];
            e[label=<Obtain a<SUB>n</SUB> by searching the maximum objective function value> shape=box];
            label = <Searching a<SUB>n</SUB>>;
            labeljust=l;
            style=dotted;
         }

         subgraph cluster_searching_r {
            d_r -> e_r[weight=100];
            e_r -> f_r[weight=100];
            f_r -> d[weight=100 label=No];

            f_r -> g_r[weight=1 label=Yes];
            g_r -> d_r[weight=1];

            d_r[label=<Calculate objective function values of r<SUB>n,h</SUB>> shape=box];
            {
               rank=same;
               e_r[label=<Obtain r<SUB>n,h</SUB> by searching the minimum objective function value> shape=box];
               g_r[label=<Add obtained r<SUB>n,h</SUB> into zeros> shape=box];
            }
            f_r[label=<Is the objective function value small enough?> shape=diamond];
            
            label = <Searching zeros>;
            labeljust=l;
            style=dotted;
         }
         
         e -> f[weight=100];
         f -> g[weight=100];

         g -> d_r[weight=1];
         
         f[label="Construct the decomposition component" shape=box];
         g[label="Compute reduced remainder" shape=box];
      }

      
   }
   

|

.. _fast-afd:

Improving Computational Efficiency
------------------------------------

As mentioned above, the searching processes of parameters :math:`a_n` and :math:`r_{n,h}` are the key decomposition steps in the core AFD and the unwinding AFD. They are all based on exhaustive searching, which means that the objective function values are evaluated one by one. As the number of points in the searching dictionary increases, the computational time will increase. To improve the computational efficiency, the fast AFD is proposed. Based on the convolution theory, the computations of objective function values can be **simplified by the FFT**. 

In the fast AFD, the points in the searching dictionaries of :math:`a_n` and :math:`r_{n,h}` are represented by their amplitudes and phases, which are

.. math::
   :nowrap:

   \begin{eqnarray}
      a_n&=&\rho_ne^{j\theta_n}\text{ and }\\
      r_{n,h}&=&\alpha_{n,h}e^{j\gamma_{n,h}}.
   \end{eqnarray}

In the core AFD, suppose :math:`t` in the objective function is same as the phase :math:`theta` in the searching dictionary, then the searching process of the basis parameter :math:`a_n` can be represented as

.. math::

   \rho_n,\; \theta_n=\arg\max_{\rho e^{j\theta}\in\mathbb{A}}\left\{ \left| \mathcal{F}^{-1}\left\{ \mathcal{F}\left\{ G_n(\theta) \right\} \cdot \mathcal{F}\left\{ \text{e}_{\left\{\rho\right\}}(\theta) \right\} \right\} \right| \right\},

where :math:`\mathcal{F}` and :math:`\mathcal{F}^{-1}` denote the FFT and the inverse FFT. 

In the unwnding AFD, suppose :math:`t` in the objective function is same as the phase :math:`theta` in the searching dictionary, then the searching process of the basis parameter :math:`a_n` can be represented as

.. math::

   \rho_n,\; \theta_n=\arg\max_{\rho e^{j\theta}\in\mathbb{A}}\left\{ \left| \mathcal{F}^{-1}\left\{ \mathcal{F}\left\{ \frac{G_n(\theta)}{I_n(\theta)} \right\} \cdot \mathcal{F}\left\{ \text{e}_{\left\{\rho\right\}}(\theta) \right\} \right\} \right| \right\}.

And the zeros can be searched by

.. math::
   :nowrap:

   \begin{eqnarray}
      \text{minimize} & \; & \left| \mathcal{F}^{-1}\left\{ \mathcal{F}\left\{  G_n(\gamma) \right\}\cdot\mathcal{F}\left\{  \frac{1}{1-\alpha e^{j\gamma}} \right\} \right\} \right|\\
      \text{subject to} & \; & \alpha e^{j\gamma}\in\mathbb{R} \text{ and } \left| \left< G_n(t),\frac{1}{1-\alpha e^{j(t-\gamma)}} \right> \right|<\epsilon.
   \end{eqnarray}



Although such implementation can significantly improve the computational efficiency, the fast AFD has some **limitations**:

+ Points in the searching dictionaries must be distributed based on their amplitudes and phases. Users cannot define their own searching dictionaries.
+ The phases of points in the searching dictionaries must be same as the phase of signal, which means that, when users change the phase of signal, the phase of points in the searching dictionary will also be changed. 

.. _intro-MAFD:

Multi-channel AFD
------------------------------------

The AFD generates its decomposition basis components based on the processed signals. When the single channel AFD decomposes signals channel by channel, different parameters, i.e. :math:`\left\{a_n\right\}_{n=1}^N` and :math:`\left\{\left\{r_{n,h}\right\}_{h=1}^{H_n}\right\}_{n=1}^N`, will be searched for different channels, which leads different sets of basis components for different channels. However, if the processed multi-channel signals are recorded **from the same system or contain same components**, we would like to use **same set of basis components** to conduct the decomposition. 

Suppose that the processed signal contain total :math:`C` channels, then, in the core AFD, the parameters of decomposition components can be searched by 

.. math::

   a_n = \arg\max_{a\in\mathbb{A}}\left\{ \sum_{c=1}^C\left| \left< G_{n,c}(t),\text{e}_{\left\{ a \right\}}(t) \right> \right| \right\}.

In the unwinding AFD, zeros can be searched by 

.. math::
   :nowrap:

   \begin{eqnarray}
      \text{minimize} & \; & \sum_{c=1}^C\left| \left< G_{n,c}(t)\prod_{i=1}^{h-1}\frac{1-\overline{r}_{n,i}e^{jt}}{e^{jt}-r_{n,i}},\frac{1}{1-\overline{r}e^{jt}} \right> \right|\\
      \text{subject to} & \; & r\in\mathbb{R} \text{ and } \sum_{c=1}^C\left| \left< G_{n,c}(t),\frac{1}{1-\overline{r}e^{jt}} \right> \right|<\epsilon.
   \end{eqnarray}

And the parameters of decomposition components in the unwinding AFD can be searched by

.. math::

   a_n = \arg\max_{a\in\mathbb{A}}\left\{ \sum_{c=1}^C\left| \left<  \frac{G_{n,c}(t)}{I_{n,c}(t)},\text{e}_{\left\{ a \right\}}(t) \right> \right| \right\}.

It should be **noticed** that, 

+ If the processed multi-channel signals do not contain same components or are not suitable to be analyzed by same basis components, the multi-channel AFD cannnot provide good performance. 
+ Suppose values of :math:`t` are not same for different channels, the values of basis components are different. However, the parameters :math:`a_n` and :math:`r_{n,h}` are same for all channels. 

Papers Related to Mathematical Foundation and Implementations
-----------------

   + T. Qian, "`Intrinsic mono-component decomposition of functions: an advance of Fourier theory <https://doi.org/10.1002/mma.1214>`_," *Math. Methods Appl. Sci.*, vol. 33, no. 7, pp. 880–891, 2010.
   + T. Qian, L. Zhang, and Z. Li, "`Algorithm of adaptive Fourier decomposition <http://ieeexplore.ieee.org/document/6021385/>`_," *IEEE Trans. Signal Process.*, vol. 59, no. 12, pp. 5899–5906, 2011.
   + T. Qian and Y. Wang, "`Remarks on adaptive Fourier decomposition <http://www.worldscientific.com/doi/pdf/10.1142/S0219691313500070>`_," *Int. J. Wavelets, Multiresolution Inf. Process.*, vol. 11, no. 1, p. 1350007, 2013.
   + T. Qian, "`Cyclic AFD algorithm for the best rational approximation <https://doi.org/10.1002/mma.2843>`_," *Math. Methods Appl. Sci.*, vol. 37, no. 6, pp. 846–859, 2014.
   + T. Qian, "`Adaptive Fourier decompositions and rational approximations — part I: Theory <http://www.worldscientific.com/doi/pdf/10.1142/S0219691314610086>`_," *Int. J. Wavelets, Multiresolution Inf. Process.*, vol. 12, no. 5, p. 1461008, 2014.
   + L. Zhang, W. Hong, W. Mai, and T. Qian, "`Adaptive Fourier decomposition and rational approximation — part II: Software system design and development <http://www.worldscientific.com/doi/pdf/10.1142/S0219691314610098>`_," *Int. J. Wavelets, Multiresolution Inf. Process.*, vol. 12, no. 5, p. 1461009, 2014.
   + T. Qian, H. Li, and M. Stessin, "`Comparison of adaptive mono-component decompositions <http://www.sciencedirect.com/science/article/pii/S1468121812001770>`_," *Nonlinear Anal. Real World Appl.*, vol. 14, no. 2, pp. 1055–1074, 2013.
   + Y. Gao, M. Ku, T. Qian, and J. Wang, "`FFT formulations of adaptive Fourier decomposition <http://www.sciencedirect.com/science/article/pii/S0377042717302005>`_," *J. Comput. Appl. Math.*, Apr. 2017.
   + Z. Wang, F. Wan, C. M. Wong, and T. Qian, "`Fast basis search for adaptive Fourier decomposition <https://link.springer.com/article/10.1186/s13634-018-0593-1>`_," *EURASIP J. Adv. Sig. Pr.*, vol. 74, no. 1, 2018.
   + T. Qian, "`Sparse representations of random signals <https://doi.org/10.1002/mma.8033>`_," *Math Meth Appl Sci.*, 2021.
   + Z. Wang, C. M. Wong, A. Rosa, T. Qian, and F. Wan, "Adaptive Fourier decomposition for multi-channel signal analysis," accepted by *IEEE Trans. Signal Process.*, 2022. 

Papers Related to Applications
-----------------

According to above characteristics, the AFD can applied to many different areas:

+ Adaptive feature extraction (for further signal classification or recognition)

   + Z. Ye, T. Qian, L. Zhang, L. Dai, H. Li, J.A. Benediktsson,"`Functional Feature Extraction for Hyperspectral Image Classification With Adaptive Rational Function Approximation <https://ieeexplore.ieee.org/document/9340564>`_," *IEEE Trans. Geosci. Remote Sens.*, pp. 1–15, 2021.
   + C. Ke, Q. Huang, L. Zhang, and Y. Fang, "`Modeling head-related impulse response based on adaptive Fourier decomposition <https://ieeexplore.ieee.org/document/8228391>`_," in *TENCON 2017 - 2017 IEEE Region 10 Conference*, Penang, Nov. 2017, pp. 3084–3088.

+ Signal compression: 
  
  + C. Tan, L. Zhang, H. Wu,"`A Novel Blaschke Unwinding Adaptive Fourier Decomposition based Signal Compression Algorithm with Application on ECG Signals <https://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=8322131>`_," *IEEE J. Biomed. Heal. Informatics*, Mar. 2018.
  + J. Ma, T. Zhang, and M. Dong, "`A novel ECG data compression method using adaptive Fourier decomposition with security guarantee in e-health applications <http://ieeexplore.ieee.org/document/6897915/>`_," *IEEE J. Biomed. Heal. Informatics*, vol. 19, no. 3, pp. 986–994, 2015.

+ Signal denoising:

   + Z. Wang, F. Wan, C. M. Wong, and L. Zhang, "`Adaptive Fourier decomposition based ECG denoising <http://www.sciencedirect.com/science/article/pii/S0010482516302104>`_," *Comput. Biol. Med.*, vol. 77, pp. 195–205, 2016.
   + Z. Wang, C. M. Wong, F. Wan, "`Adaptive Fourier decomposition based R-peak detection for noisy ECG Signals <https://ieeexplore.ieee.org/abstract/document/8037611/>`_," in *39th Annual International Conference of the IEEE Engineering in Medicine and Biology Society (EMBC)*, 2017, pp. 3501-3504.
   + Z. Wang, C. M. Wong, J. N. da Cruz, F. Wan, P.-I. Mak, P. U. Mak, and M. I. Vai, "`Muscle and electrode motion artifacts reduction in ECG using adaptive Fourier decomposition <http://ieeexplore.ieee.org/document/6974120/>`_," in *2014 IEEE International Conference on Systems, Man, and Cybernetics (SMC)*, 2014, pp. 1456–1461.
   + Z. Wang, J. Nuno da Cruz, and F. Wan, "`Adaptive Fourier decomposition approach for lung-heart sound separation <http://ieeexplore.ieee.org/document/7158631/>`_," in *2015 IEEE International Conference on Computational Intelligence and Virtual Environments for Measurement Systems and Applications (CIVEMSA)*, 2015, pp. 1–5.

+ Model estimation:

   + Q. Chen, T. Qian, Y. Li, W. Mai, X. Zhang, "`Adaptive Fourier tester for statistical estimation <https://doi.org/10.1002/mma.3795>`_," *Math. Method. Appl. Sci.*, vol. 39, no. 12, pp. 3478–3495, 2016.
   + W. Mi and T. Qian, "`Frequency-domain identification: An algorithm based on an adaptive rational orthogonal system <http://www.sciencedirect.com/science/article/pii/S0005109812000982>`_," *Automatica*, vol. 48, no. 6, pp. 1154–1162, 2012.

+ Time-frequency analysis:

   + L. Zhang, "`Adaptive Fourier decomposition based signal instantaneous frequency computation approach <http://waset.org/publications/2536/adaptive-fourier-decomposition-based-signal-instantaneous-frequency-computation-approach>`_," *Int. J. Math. Comput. Phys. Electr. Comput. Eng.*, vol. 6, no. 8, pp. 1117–1122, 2012.


