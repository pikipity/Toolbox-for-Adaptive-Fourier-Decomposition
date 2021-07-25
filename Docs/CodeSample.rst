Code Samples
===================================

Matlab
----------------

V2.0
^^^^^^

You can find all demo codes in the toolbox :file:`Matlab/v2.0/Demo`. To run these codes, you need the sample data in this folder.

Simple Demo
""""""""""""

This demo shows the most simple way to use this toolbox. The core AFD without improving the computaitonal efficiency is used to decompose a ECG signal. 

.. literalinclude:: ../Matlab/v2.0/Demo/Simple_Demo.m
    :language: matlab

Demo 1 of the single channel core AFD
"""""""""""""""""""""""""""""""""""""""

This demo shows how to use the single channel core AFD and plot some useful figures.

Decomposition method used in this demo:

+ AFD method: Single channel core AFD
+ Method of generating searching dictionary: square
+ Fast AFD: No

.. literalinclude:: ../Matlab/v2.0/Demo/Demo_coreAFD_1.m
    :language: matlab

Demo 2 of the single channel core AFD
"""""""""""""""""""""""""""""""""""""""

This demo shows how to change the method of generating searching dictionary.

Decomposition method used in this demo:

+ AFD method: Single channel core AFD
+ Method of generating searching dictionary: circle
+ Fast AFD: No

.. literalinclude:: ../Matlab/v2.0/Demo/Demo_coreAFD_2.m
    :language: matlab

Demo 3 of the single channel core AFD
"""""""""""""""""""""""""""""""""""""""

This demo shows how to use the fast AFD to improve the computational efficiency.

Decomposition method used in this demo:

+ AFD method: Single channel core AFD
+ Method of generating searching dictionary: circle
+ Fast AFD: Yes

.. literalinclude:: ../Matlab/v2.0/Demo/Demo_coreAFD_3.m
    :language: matlab

Comparison of different implementations of single channel core AFD
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Compare methods in Demos 1, 2 and 3 of the single channel core AFD.

.. literalinclude:: ../Matlab/v2.0/Demo/Demo_coreAFD_compare.m
    :language: matlab

Demo 1 of the single channel unwinding AFD
"""""""""""""""""""""""""""""""""""""""""""

This demo shows how to use the single channel core AFD and plot some useful figures.

Decomposition method used in this demo:

+ AFD method: Single channel unwinding AFD
+ Method of generating searching dictionary: square
+ Fast AFD: No

.. literalinclude:: ../Matlab/v2.0/Demo/Demo_unwindingAFD_1.m
    :language: matlab

Demo 2 of the single channel unwinding AFD
""""""""""""""""""""""""""""""""""""""""""""

This demo shows how to change the method of generating searching dictionary.

Decomposition method used in this demo:

+ AFD method: Single channel unwinding AFD
+ Method of generating searching dictionary: circle
+ Fast AFD: No

.. literalinclude:: ../Matlab/v2.0/Demo/Demo_unwindingAFD_2.m
    :language: matlab

Demo 3 of the single channel unwinding AFD
""""""""""""""""""""""""""""""""""""""""""""

This demo shows how to use the fast AFD to improve the computational efficiency.

Decomposition method used in this demo:

+ AFD method: Single channel unwinding AFD
+ Method of generating searching dictionary: circle
+ Fast AFD: Yes

.. literalinclude:: ../Matlab/v2.0/Demo/Demo_unwindingAFD_3.m
    :language: matlab

Comparison of different implementations of single channel unwinding AFD
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Compare methods in Demos 1, 2 and 3 of the single channel unwinding AFD.

.. literalinclude:: ../Matlab/v2.0/Demo/Demo_unwindingAFD_compare.m
    :language: matlab

Different phases for different channels
""""""""""""""""""""""""""""""""""""""""""

This demo shows how to set different phases for different signals.

.. literalinclude:: ../Matlab/v2.0/Demo/Demo_set_diffPhases.m
    :language: matlab

User-defined searching dictionary
"""""""""""""""""""""""""""""""""""

This demo shows how to define the searching dictionary.

.. literalinclude:: ../Matlab/v2.0/Demo/Demo_set_searchingDictionary.m
    :language: matlab

Decomposition using user-defined parameters without searching parameters
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

This demo shows how to use the pre-defined parameters to conduct the decomposition without searching parameters. It should be noticed that such decomposition is not adaptive. 

.. literalinclude:: ../Matlab/v2.0/Demo/Demo_set_existing_an.m
    :language: matlab


V1.0
^^^^^

V1.0 toolbox is **NOT** recommended.

.. literalinclude:: ../Matlab/v1.0/Example/AFD_Example.m
    :language: matlab


Python
----------------

*Under development*