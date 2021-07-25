.. _installation-label:

Installation Instructions
=====================================================================

Download
----------

+ You can clone this toolbox from `Toolbox-for-Adaptive-Fourier-Decomposition.git <https://github.com/pikipity/Toolbox-for-Adaptive-Fourier-Decomposition.git>`_ by 

.. code-block:: console

    $ git clone  https://github.com/pikipity/Toolbox-for-Adaptive-Fourier-Decomposition

+ You also can directly download this toolbox from `Toolbox-for-Adaptive-Fourier-Decomposition.zip <https://github.com/pikipity/Toolbox-for-Adaptive-Fourier-Decomposition/archive/refs/heads/master.zip>`_

Matlab
--------

From this toolbox, you can find the corresponding folder :file:`Matlab/`. Under this folder, you can find different folders that are corresponding to different versions. You can add the folder corresponding to the latest version to the searching path of Matlab. For example, 

.. code-block::

    >> addpath(genpath('Toolbox-for-Adaptive-Fourier-Decomposition/Matlab/v2.0'))

Python
-------

1. Install the required packages:
   
   + NumPy
   + SciPy
   + matplotlib
  
2. Copy :file:`Python/AFD.py` to the Python searching path, like your own program root path.
3. In your own python program, you have to import functions in :file:`AFD.py`. For example, ``from AFD import *``


