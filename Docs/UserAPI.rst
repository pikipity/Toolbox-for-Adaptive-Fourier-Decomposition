.. _userapi-label:

User API
=====================================

Matlab API Reference
----------------------

V2.0
^^^^^^

.. function:: AFDCal()

    Create the instance of the AFD computation module. All computations of the AFD is based on this AFD computation module. In addition, all computational results and parameters are stored in follow parameters, which can be directly read from the created instance. 

    :param s: Input signal. It can be a single channel or multi-channel signal. The size is :math:`C \times L` where :math:`C` is the number of channels and :math:`L` is the sample number.
    :param G: Analytic form of the input signal ``s``.
    :param t: Phase of input signal. The size is same as the size of ``s``. If user want to define ``t`` by yourself, please check :ref:`decomposition-basis`.
    :param S1: Objective function values of searching :math:`a_n`. It is a :math:`C \times (N+1)` cell where :math:`N` is current decomposition level ``level``.
    :param max_loc: Location of maximum function value. It is a :math:`C \times (N+1)` cell.
    :param Weight: Weights for computing integration.
    :param an: Parameters :math:`a_n` of basis. It is a :math:`C \times 1` cell.
    :param coef: Decomposition coefficients :math:`A_n`. It is a :math:`C \times 1` cell.
    :param level: Current decomposition level.
    :param dic_an: Searching dictionary of :math:`a_n` and :math:`r_{n,h}`. It is a :math:`C \times 1` cell. If user want to define ``dic_an`` by yourself, please check :ref:`introductionAFD-label`.
    :param Base: Evaluators of :math:`a_n`. It is a :math:`C \times 1` cell.
    :param remainder: Reduced remainder at the current decomposition level. The size is same as the size of ``s``.
    :param tem_B: Generated decomposition basis. It is a :math:`C \times 1` cell.
    :param deComp: Decomposition components. It is a :math:`C \times 1` cell.
    :param decompMethod: Decomposition method. "Single Channel Conventional AFD" means the single channel AFD without improving the computaitonal efficiency. "Single Channel Fast AFD" means the single channel AFD with improving the computaitonal efficiency. For the single channel methods, the multi-channel signals will be analyzed channel by channel. To know whether needs the fast AFD to improve the computational efficiency, please check :ref:`fast-afd`.
    :param dicGenMethod: Method of generating the searching dictionary ``dic_an``. "square" means that points are generated based on their real and imaginary parts. "circle" means that points are generated based on their amplitudes and phases. The fast AFD only supports "circle". "circle" can provide the searching dictionary with high density but will increase the memory usage and the computational time. Normally, the fast AFD is required for "circle".
    :param AFDMethod: Extension method of the AFD. "core" means the core AFD. "unwinding" means the unwinding AFD. To know differences of these extensions and how to choose them, please check :ref:`introductionAFD-label`.
    :param log: log that stores warning and error outputs.
    :param run_time: computational time of each decomposition level. It is a :math:`C\times (N+1)` matrix.
    :param time_genDic: computational time of generating searching dictionary. It is a :math:`C\times 1` matrix.
    :param time_genEva: computational time of generating evaluators. It is a :math:`C\times 1` matrix.
    :param r_store: Parameters :math:`r_{n,h}` of inner functions. It is a :math:`C \times (N+1)` cell when using the unwinding AFD.
    :param InProd: Inner functions. It is a :math:`C \times 1` cell when using the unwinding AFD.
    :param OutProd: outer functions. It is a :math:`C \times 1` cell when using the unwinding AFD.
    :param Base_r: evaluators of :math:`r_{n,h}`. It is a :math:`C \times 1` cell when using the unwinding AFD.
    :param N_r: Largest interation number of searching zeros. Normally, it is a large number. Default is 1e3.
    :param tol_r: :math:`\epsilon` of searching zeros. Normally, it is a small number. Default is 1e-3.


.. function:: AFDCal.setInputSignal(s)

    Set input signal. Change ``AFDCal.s``. All settings will be Initialized.

    :param s: Input signal. It can be a single channel or multi-channel signal. The size is :math:`C \times L`.

.. function:: AFDCal.setPhase(channel,phase)

    Set phase of input signal. Change ``AFDCal.t``.

    :param channel: Change which channel.
    :param phase: new phase. It is a :math:`L\times 1` matrix. 

.. function:: AFDCal.setDicGenMethod(method_no)

    Set method of generating the searching dictionary. Change ``AFDCal.dicGenMethod``.

    :param method_no: 1 means "square"; 2 means "circle".

.. function:: AFDCal.setDecompMethod(method_no)

    Set decomposition method. Change ``AFDCal.decompMethod``.

    :param method_no: 1 means "Single Channel Conventional AFD"; 2 means "Single Channel Fast AFD".

.. function:: AFDCal.setAFDMethod(method_no)

    Set extension method of the AFD. Change ``AFDCal.AFDMethod``.

    :param method_no: 1 means "core"; 2 means "unwinding".

.. function:: AFDCal.set_r(r_store)

    Set zeros. Change ``AFDCal.r_store``.

    :param r_store: Parameters :math:`r_{n,h}` of inner functions. It is a :math:`C \times (N+1)` cell.

.. function:: AFDCal.set_parameters_searchingZeros(N_r,tol_r)

    Set parameters of searching :math:`r_{n,h}`. Change ``AFDCal.N_r`` and ``AFDCal.tol_r``. If user does not know how to set these values, please do not use this function and use the default values. 

    :param N_r: Largest interation number of searching zeros. Normally, it is a large number.
    :param tol_r: :math:`\epsilon` of searching zeros. Normally, it is a small number.

.. function:: AFDCal.set_dic_an(dic_an)

    Set searching dictionary. Change ``AFDCal.dic_an``.

    :param dic_an: Searching dictionary of :math:`a_n` and :math:`r_{n,h}`. It is a :math:`C \times 1` cell.

.. function:: AFDCal.set_coef(coef)

    Set decomposition coefficients. Change ``AFDCal.coef``.

    :param coef: Decomposition coefficients :math:`A_n`. It is a :math:`C \times 1` cell.

.. function:: AFDCal.set_an(an)

    Set parameters of basis. Change ``AFDCal.an``.

    :param an: Parameters :math:`a_n` of basis. It is a :math:`C \times 1` cell.

.. function:: AFDCal.search_r(ch_i)

    Search zeros of `ch_i` channel.

    :param ch_i: channel order.

.. function:: AFDCal.plot_S1(level)

    Plot objective function values at decomposition level `level`.

    :param level: level order.

.. function:: AFDCal.plot_reSig(level)

    Plot reconstructed signals at decomposition level `level`.

    :param level: level order.

.. function:: AFDCal.plot_ori_sig()

    Plot original signals.

.. function:: AFDCal.plot_evaluator()

    Plot evaluators of :math:`a_n`

.. function:: AFDCal.plot_energyRate(level)

    Plot energy rate of remainders from 0 to ``level``.

    :param level: level order.

.. function:: AFDCal.plot_dic()

    Plot the searching dictionary.

.. function:: AFDCal.plot_decompComp(level)

    Plot decomposition components at decomposition level ``level``.

    :param level: level order.

.. function:: AFDCal.plot_basis(level)

    Plot generated basis at decomposition level ``level``.

    :param level: level order.

.. function:: AFDCal.initSetting()

    Initialize settings. 

.. function:: AFDCal.init_decomp() or AFDCal.init_decomp(searching_an_flag)

    Initialize the decomposition.

    :param searching_an_flag: Default is 1. If 1, :math:`a_n` and :math:`\left\{r_{n,h}\right\}_{h=1}^{H_n}` are searched. If 0, these values will use the pre-defined values.

.. function:: AFDCal.genDic(dist,max_an_mag)

    Generate searching dictionary.

    :param dist: Separation of points. If ``AFDCal.dicGenMethod`` is "square", it is the separation of real and imaginary parts. If ``AFDCal.dicGenMethod`` is "circle", it is the separation of magnitude. 
    :param max_an_mag: Maximum of magnitude.


.. function:: AFDCal.genEva()

    Generate evaluators.

.. function:: AFDCal.nextDecomp() or AFDCal.nextDecomp(searching_an_flag)

    Conduct the next decomposition loop.

    :param searching_an_flag: Default is 1. If 1, :math:`a_n` and :math:`\left\{r_{n,h}\right\}_{h=1}^{H_n}` are searched. If 0, these values will use the pre-defined values. 

.. function:: AFDCal.dispLog()

    Display log.

.. function:: AFDCal.dispInfo()

    Add information of current computation module to log and display log.

.. function:: AFDCal.clearLog()

    clear log.

.. function:: reSig = AFDCal.cal_reSig(level)

    Calculate the reconstructed signal at decomposition level `level`.

    :param level: level order.


V1.0
^^^^^^

V1.0 toolbox is **NOT** recommended.

.. function:: [an,coef,t]=conv_AFD(s,max_level,M [,L])

    Core AFD without improving the computaitonal efficiency.

    :param s: 1*K processed signal. K is the sample number
    :param max_level: Maximum decomposition level
    :param M: If it is a integer number, it is the maximum number of the magnitude values of a_n in the searching dictionary, and the dictionary of the magnitude values is unique distributed in [0,1). If it is an array, it is the dictionary of the magnitude values.
    :param L: If it is a integer number, it is the maximum number of the phase values of a_n in the searching dictionary, and the dictionary of the phase values is unique distributed in [0,2*pi). If it is an array, it is the dictionary of the phase values.

    :return: an, coef, t

.. function:: [an,coef,t]=FFT_AFD(s,max_level,M)

    Core AFD with improving the computaitonal efficiency.

    :param s: 1*K processed signal. K is the sample number
    :param max_level: Maximum decomposition level
    :param M: If it is a integer number, it is the maximum number of the magnitude values of a_n in the searching dictionary, and the dictionary of the magnitude values is unique distributed in [0,1). If it is an array, it is the dictionary of the magnitude values.

    :return: state, an, coef, t

.. function:: [reconstructed_signal, total_decomposition_level]=inverse_AFD(an,coef,t)

    Inverse core AFD

    :param an: Parameters of decomposition parameters :math:`a_n`
    :param coef: Decomposition coefficients 
    :param t: Phase of the processed signal
    :param standard: state the reconstruction according to 'level' or 'energy'
    :param standard_value: If ``standard='level'``, the reconstruction is based on the decomposition level from 0 to ``min((size(an),standard_value))``. If ``standard='energy'``, the reconstruction is based on the energy. The energy of the reconstructed signal is smaller or equal to ``standard_value``.

    :return: reconstructed_signal, total_decomposition_level


Python API Reference
---------------------

V2.0
^^^^^^

*Under development*

V1.0
^^^^^

V1.0 toolbox is **NOT** recommended.

.. py:function:: conv_AFD(s[,max_level=50,M=20,L=2000])

    Core AFD without improving the computaitonal efficiency.

    :param s: 1*K processed signal. K is the sample number
    :param max_level: Maximum decomposition level
    :param M: If it is a integer number, it is the maximum number of the magnitude values of a_n in the searching dictionary, and the dictionary of the magnitude values is unique distributed in [0,1). If it is an array, it is the dictionary of the magnitude values.
    :param L: If it is a integer number, it is the maximum number of the phase values of a_n in the searching dictionary, and the dictionary of the phase values is unique distributed in [0,2*pi). If it is an array, it is the dictionary of the phase values.

    :return: state, an, coef, t

.. py:function:: FFT_AFD(s[,max_level=50,M=20])

    Core AFD with improving the computaitonal efficiency.

    :param s: 1*K processed signal. K is the sample number
    :param max_level: Maximum decomposition level
    :param M: If it is a integer number, it is the maximum number of the magnitude values of a_n in the searching dictionary, and the dictionary of the magnitude values is unique distributed in [0,1). If it is an array, it is the dictionary of the magnitude values.

    :return: state, an, coef, t

.. py:function:: inverse_AFD(an,coef,t[,standard='level',standard_value=float("inf")])

    Inverse core AFD

    :param an: Parameters of decomposition parameters :math:`a_n`
    :param coef: Decomposition coefficients 
    :param t: Phase of the processed signal
    :param standard: state the reconstruction according to 'level' or 'energy'
    :param standard_value: If ``standard='level'``, the reconstruction is based on the decomposition level from 0 to ``min((size(an),standard_value))``. If ``standard='energy'``, the reconstruction is based on the energy. The energy of the reconstructed signal is smaller or equal to ``standard_value``.

    :return: reconstructed_signal, total_decomposition_level