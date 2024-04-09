Code Samples
===================================

Matlab
----------------

Matlab -- V2.1
^^^^^^^^^^^^^^^

Demos of the single channel AFD are in :file:`Matlab/v2.1/Demo of Single Channel AFD`. They are same as demos in V2.0.

Demos of the multi-channel AFD are in :file:`Matlab/v2.1/Demo of Multi-channel AFD`. To run these codes, you need the sample data in this folder. 

Demos related to the paper "Adaptive Fourier decomposition for multi-channel signal analysis" are in :file:`Matlab/v2.1/Comparison of Single Channel AFD and Multi-channel AFD`. The file :file:`multi_AFD_TF_dist.m` shows how to generate time-frequency analysis based on the MAFD. 

Simple Demo of multi-channel AFD
""""""""""""""""""""""""""""""""""

This demo shows the most simple way to use the multi-channel AFD.

:file:`Matlab/v2.1/Demo of Multi-channel AFD/Simple_Demo.m`

.. literalinclude:: ../Matlab/v2.1/Demo of Multi-channel AFD/Simple_Demo.m
    :language: matlab

Demo 1 of the multi-channel core AFD
"""""""""""""""""""""""""""""""""""""""

This demo shows how to use the multi-channel core AFD and plot some useful figures.

Decomposition method used in this demo:

+ AFD method: Multi-channel core AFD
+ Method of generating searching dictionary: square
+ Fast AFD: No

:file:`Matlab/v2.1/Demo of Multi-channel AFD/Demo_coreAFD_1.m`

.. literalinclude:: ../Matlab/v2.1/Demo of Multi-channel AFD/Demo_coreAFD_1.m
    :language: matlab

Demo 2 of the multi-channel core AFD
"""""""""""""""""""""""""""""""""""""""

This demo shows how to change the method of generating searching dictionary.

Decomposition method used in this demo:

+ AFD method: Multi-channel core AFD
+ Method of generating searching dictionary: circle
+ Fast AFD: No

:file:`Matlab/v2.1/Demo of Multi-channel AFD/Demo_coreAFD_2.m`

.. literalinclude:: ../Matlab/v2.1/Demo of Multi-channel AFD/Demo_coreAFD_2.m
    :language: matlab

Demo 3 of the multi-channel core AFD
"""""""""""""""""""""""""""""""""""""""

This demo shows how to use the fast AFD to improve the computational efficiency.

Decomposition method used in this demo:

+ AFD method: Multi-channel core AFD
+ Method of generating searching dictionary: circle
+ Fast AFD: Yes

:file:`Matlab/v2.1/Demo of Multi-channel AFD/Demo_coreAFD_3.m`

.. literalinclude:: ../Matlab/v2.1/Demo of Multi-channel AFD/Demo_coreAFD_3.m
    :language: matlab

Comparison of different implementations of multi-channel core AFD
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Compare methods in Demos 1, 2 and 3 of the multi-channel core AFD.

:file:`Matlab/v2.1/Demo of Multi-channel AFD/Demo_coreAFD_compare.m`

.. literalinclude:: ../Matlab/v2.1/Demo of Multi-channel AFD/Demo_coreAFD_compare.m
    :language: matlab

Demo 1 of the multi-channel unwinding AFD
"""""""""""""""""""""""""""""""""""""""""""

This demo shows how to use the multi-channel core AFD and plot some useful figures.

Decomposition method used in this demo:

+ AFD method: Multi-channel unwinding AFD
+ Method of generating searching dictionary: square
+ Fast AFD: No

:file:`Matlab/v2.1/Demo of Multi-channel AFD/Demo_unwindingAFD_1.m`

.. literalinclude:: ../Matlab/v2.1/Demo of Multi-channel AFD/Demo_unwindingAFD_1.m
    :language: matlab

Demo 2 of the multi-channel unwinding AFD
""""""""""""""""""""""""""""""""""""""""""""

This demo shows how to change the method of generating searching dictionary.

Decomposition method used in this demo:

+ AFD method: Multi-channel unwinding AFD
+ Method of generating searching dictionary: circle
+ Fast AFD: No

:file:`Matlab/v2.1/Demo of Multi-channel AFD/Demo_unwindingAFD_2.m`

.. literalinclude:: ../Matlab/v2.1/Demo of Multi-channel AFD/Demo_unwindingAFD_2.m
    :language: matlab

Demo 3 of the multi-channel unwinding AFD
""""""""""""""""""""""""""""""""""""""""""""

This demo shows how to use the fast AFD to improve the computational efficiency.

Decomposition method used in this demo:

+ AFD method: Multi-channel unwinding AFD
+ Method of generating searching dictionary: circle
+ Fast AFD: Yes

:file:`Matlab/v2.1/Demo of Multi-channel AFD/Demo_unwindingAFD_3.m`

.. literalinclude:: ../Matlab/v2.1/Demo of Multi-channel AFD/Demo_unwindingAFD_3.m
    :language: matlab

Comparison of different implementations of multi-channel unwinding AFD
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Compare methods in Demos 1, 2 and 3 of the multi-channel unwinding AFD.

:file:`Matlab/v2.1/Demo of Multi-channel AFD/Demo_unwindingAFD_compare.m`

.. literalinclude:: ../Matlab/v2.1/Demo of Multi-channel AFD/Demo_unwindingAFD_compare.m
    :language: matlab

Different phases for different channels (multi-channel AFD)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

This demo shows how to set different phases for different signals.

:file:`Matlab/v2.1/Demo of Multi-channel AFD/Demo_set_diffPhases.m`

.. literalinclude:: ../Matlab/v2.1/Demo of Multi-channel AFD/Demo_set_diffPhases.m
    :language: matlab

Decomposition using user-defined parameters without searching parameters (multi-channel AFD)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

This demo shows how to use the pre-defined parameters to conduct the decomposition without searching parameters. It should be noticed that, when using user-defined parameters, the decomposition is not adaptive. 

:file:`Matlab/v2.1/Demo of Multi-channel AFD/Demo_set_existing_an.m`

.. literalinclude:: ../Matlab/v2.1/Demo of Multi-channel AFD/Demo_set_existing_an.m
    :language: matlab

Matlab -- V2.0
^^^^^^^^^^^^^^^^

You can find all demo codes in the toolbox :file:`Matlab/v2.0/Demo`. To run these codes, you need the sample data in this folder.

Simple Demo of single channel AFD
"""""""""""""""""""""""""""""""""""

This demo shows the most simple way to use this toolbox. The single channel core AFD without improving the computaitonal efficiency is used to decompose a ECG signal. 

:file:`Matlab/v2.0/Demo/Simple_Demo.m`

.. literalinclude:: ../Matlab/v2.0/Demo/Simple_Demo.m
    :language: matlab

Demo 1 of the single channel core AFD
"""""""""""""""""""""""""""""""""""""""

This demo shows how to use the single channel core AFD and plot some useful figures.

Decomposition method used in this demo:

+ AFD method: Single channel core AFD
+ Method of generating searching dictionary: square
+ Fast AFD: No

:file:`Matlab/v2.0/Demo/Demo_coreAFD_1.m`

.. literalinclude:: ../Matlab/v2.0/Demo/Demo_coreAFD_1.m
    :language: matlab

Demo 2 of the single channel core AFD
"""""""""""""""""""""""""""""""""""""""

This demo shows how to change the method of generating searching dictionary.

Decomposition method used in this demo:

+ AFD method: Single channel core AFD
+ Method of generating searching dictionary: circle
+ Fast AFD: No

:file:`Matlab/v2.0/Demo/Demo_coreAFD_2.m`

.. literalinclude:: ../Matlab/v2.0/Demo/Demo_coreAFD_2.m
    :language: matlab

Demo 3 of the single channel core AFD
"""""""""""""""""""""""""""""""""""""""

This demo shows how to use the fast AFD to improve the computational efficiency.

Decomposition method used in this demo:

+ AFD method: Single channel core AFD
+ Method of generating searching dictionary: circle
+ Fast AFD: Yes

:file:`Matlab/v2.0/Demo/Demo_coreAFD_3.m`

.. literalinclude:: ../Matlab/v2.0/Demo/Demo_coreAFD_3.m
    :language: matlab

Comparison of different implementations of single channel core AFD
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Compare methods in Demos 1, 2 and 3 of the single channel core AFD.

:file:`Matlab/v2.0/Demo/Demo_coreAFD_compare.m`

.. literalinclude:: ../Matlab/v2.0/Demo/Demo_coreAFD_compare.m
    :language: matlab

Demo 1 of the single channel unwinding AFD
"""""""""""""""""""""""""""""""""""""""""""

This demo shows how to use the single channel core AFD and plot some useful figures.

Decomposition method used in this demo:

+ AFD method: Single channel unwinding AFD
+ Method of generating searching dictionary: square
+ Fast AFD: No

:file:`Matlab/v2.0/Demo/Demo_unwindingAFD_1.m`

.. literalinclude:: ../Matlab/v2.0/Demo/Demo_unwindingAFD_1.m
    :language: matlab

Demo 2 of the single channel unwinding AFD
""""""""""""""""""""""""""""""""""""""""""""

This demo shows how to change the method of generating searching dictionary.

Decomposition method used in this demo:

+ AFD method: Single channel unwinding AFD
+ Method of generating searching dictionary: circle
+ Fast AFD: No

:file:`Matlab/v2.0/Demo/Demo_unwindingAFD_2.m`

.. literalinclude:: ../Matlab/v2.0/Demo/Demo_unwindingAFD_2.m
    :language: matlab

Demo 3 of the single channel unwinding AFD
""""""""""""""""""""""""""""""""""""""""""""

This demo shows how to use the fast AFD to improve the computational efficiency.

Decomposition method used in this demo:

+ AFD method: Single channel unwinding AFD
+ Method of generating searching dictionary: circle
+ Fast AFD: Yes

:file:`Matlab/v2.0/Demo/Demo_unwindingAFD_3.m`

.. literalinclude:: ../Matlab/v2.0/Demo/Demo_unwindingAFD_3.m
    :language: matlab

Comparison of different implementations of single channel unwinding AFD
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Compare methods in Demos 1, 2 and 3 of the single channel unwinding AFD.

:file:`Matlab/v2.0/Demo/Demo_unwindingAFD_compare.m`

.. literalinclude:: ../Matlab/v2.0/Demo/Demo_unwindingAFD_compare.m
    :language: matlab

Different phases for different channels (single channel AFD)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

This demo shows how to set different phases for different signals.

:file:`Matlab/v2.0/Demo/Demo_set_diffPhases.m`

.. literalinclude:: ../Matlab/v2.0/Demo/Demo_set_diffPhases.m
    :language: matlab

User-defined searching dictionary (single channel AFD)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""

This demo shows how to define the searching dictionary.

:file:`Matlab/v2.0/Demo/Demo_set_searchingDictionary.m`

.. literalinclude:: ../Matlab/v2.0/Demo/Demo_set_searchingDictionary.m
    :language: matlab

Decomposition using user-defined parameters without searching parameters (single channel AFD)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

This demo shows how to use the pre-defined parameters to conduct the decomposition without searching parameters. It should be noticed that, when using user-defined parameters, the decomposition is not adaptive. 

:file:`Matlab/v2.0/Demo/Demo_set_existing_an.m`

.. literalinclude:: ../Matlab/v2.0/Demo/Demo_set_existing_an.m
    :language: matlab


Matlab -- V1.0
^^^^^^^^^^^^^^^^

V1.0 toolbox is **NOT** recommended.

:file:`Matlab/v1.0/Example/AFD_Example.m`

.. literalinclude:: ../Matlab/v1.0/Example/AFD_Example.m
    :language: matlab


Python
----------------

Python -- V2.1
^^^^^^^^^^^^^^^^^

This version supports the multi-channel core AFD.

Demo 1: Multi-channel core AFD based on the conventional basis searching with the square searching dictionary
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Decomposition method used in this demo:

+ AFD method: Multi-channel core AFD
+ Method of generating searching dictionary: square
+ Fast AFD: No

:file:`Python/v2.1/example_multichannel_conv_AFD_square.py`

.. literalinclude:: ../Python/v2.1/example_multichannel_conv_AFD_square.py
    :language: python

Demo 2: Multi-channel core AFD based on the conventional basis searching with the circle searching dictionary
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Decomposition method used in this demo:

+ AFD method: Multi-channel core AFD
+ Method of generating searching dictionary: circle
+ Fast AFD: No

:file:`Python/v2.1/example_multichannel_conv_AFD_circle.py`

.. literalinclude:: ../Python/v2.1/example_multichannel_conv_AFD_circle.py
    :language: python

Demo 2: Multi-channel core AFD based on the fast basis searching
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Decomposition method used in this demo:

+ AFD method: Multi-channel core AFD
+ Method of generating searching dictionary: circle
+ Fast AFD: Yes

:file:`Python/v2.1/example_multichannel_fast_AFD.py`

.. literalinclude:: ../Python/v2.1/example_multichannel_fast_AFD.py
    :language: python

Python -- V2.0
^^^^^^^^^^^^^^^^^

This version supports multi-channel/multiple signals. But only single channel AFD methods can be used.

Demo 1: Conventional basis searching with the square searching dictionary
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Decomposition method used in this demo:

+ AFD method: Single Channel core AFD
+ Method of generating searching dictionary: square
+ Fast AFD: No

:file:`Python/v2.0/example_conv_AFD_square.py`

.. literalinclude:: ../Python/v2.0/example_conv_AFD_square.py
    :language: python

Demo 2: Conventional basis searching with the circle searching dictionary
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Decomposition method used in this demo:

+ AFD method: Single Channel core AFD
+ Method of generating searching dictionary: circle
+ Fast AFD: No

:file:`Python/v2.0/example_conv_AFD_circle.py`

.. literalinclude:: ../Python/v2.0/example_conv_AFD_circle.py
    :language: python

Related results are in :file:`Python/v2.0/example_res_conv_AFD_circle`.

Demo 3: Fast basis searching
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Decomposition method used in this demo:

+ AFD method: Single Channel core AFD
+ Method of generating searching dictionary: circle
+ Fast AFD: Yes

:file:`Python/v2.0/example_fast_AFD.py`

.. literalinclude:: ../Python/v2.0/example_fast_AFD.py
    :language: python

Related results are in :file:`Python/v2.0/example_res_fast_AFD`.

Demo 4: POAFD with the square searching dictionary
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Decomposition method used in this demo:

+ AFD method: Single Channel POAFD
+ Method of generating searching dictionary: square
+ Fast AFD: No

:file:`Python/v2.0/example_POAFD_square.py`

.. literalinclude:: ../Python/v2.0/example_POAFD_square.py
    :language: python

Related results are in :file:`Python/v2.0/example_POAFD_square`.

Demo 5: POAFD with the circle searching dictionary
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Decomposition method used in this demo:

+ AFD method: Single Channel POAFD
+ Method of generating searching dictionary: circle
+ Fast AFD: No

:file:`Python/v2.0/example_POAFD_circle.py`

.. literalinclude:: ../Python/v2.0/example_POAFD_circle.py
    :language: python

Related results are in :file:`Python/v2.0/example_POAFD_circle`.

Python -- V1.1
^^^^^^^^^^^^^^^^^

This version only supports the single channel core AFD with/without the fast basis searching.

Demo 1: Conventional basis searching with the square searching dictionary
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Decomposition method used in this demo:

+ AFD method: Single Channel core AFD
+ Method of generating searching dictionary: square
+ Fast AFD: No

:file:`Python/v1.1/example_conv_AFD_square.py`

.. literalinclude:: ../Python/v1.1/example_conv_AFD_square.py
    :language: python

Related results are in :file:`Python/v1.1/example_res_conv_AFD_square`.

Demo 2: Conventional basis searching with the circle searching dictionary
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Decomposition method used in this demo:

+ AFD method: Single Channel core AFD
+ Method of generating searching dictionary: circle
+ Fast AFD: No

:file:`Python/v1.1/example_conv_AFD_circle.py`

.. literalinclude:: ../Python/v1.1/example_conv_AFD_circle.py
    :language: python

Related results are in :file:`Python/v1.1/example_res_conv_AFD_circle`.

Demo 3: Fast basis searching
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Decomposition method used in this demo:

+ AFD method: Single Channel core AFD
+ Method of generating searching dictionary: circle
+ Fast AFD: Yes

:file:`Python/v1.1/example_fast_AFD.py`

.. literalinclude:: ../Python/v1.1/example_fast_AFD.py
    :language: python

Related results are in :file:`Python/v1.1/example_res_fast_AFD`.