.. _installation-label:

Installation Instructions
=====================================================================

Download
----------

+ You can clone this toolbox from `Toolbox-for-Adaptive-Fourier-Decomposition.git <https://github.com/pikipity/Toolbox-for-Adaptive-Fourier-Decomposition.git>`_ by 

.. code-block:: console

    $ git clone  https://github.com/pikipity/Toolbox-for-Adaptive-Fourier-Decomposition

+ You also can directly download this toolbox: :download:`Toolbox-for-Adaptive-Fourier-Decomposition.zip <https://github.com/pikipity/Toolbox-for-Adaptive-Fourier-Decomposition/archive/refs/heads/master.zip>`

Matlab
--------

From this toolbox, you can find the corresponding folder :file:`Matlab/`. Under this folder, you can find different folders that are corresponding to different versions. You can add the folder corresponding to the latest version to the searching path of Matlab. For example, 

.. code-block::

    >> addpath(genpath('Toolbox-for-Adaptive-Fourier-Decomposition/Matlab/v2.1'))

Python
-------

Versions except V1.0
^^^^^^^^^^^^^^^^^^^^^^^

1. Install the required packages. You can find all required packages in :file:`Python/vX/environment.yml` (X is the version number). If you use conda or Anaconda, you can create a new virtual environment using :file:`environment.yml`:

   .. code-block:: console
    
    $ conda env create -f environment.yml

2. Copy :file:`Python/vX/AFDCal` to the Python Searching path, like your own program root path. Then, following the given examples in :file:`Python/vX`, you can use this toolbox. 

V1.0 (NOT Recommanded)
^^^^^^^^^^^^^^^^^^^^^^^^

1. Install the required packages:
   
   + NumPy
   + SciPy
   + matplotlib
  
2. Copy :file:`Python/v1.0/AFD.py` to the Python searching path, like your own program root path.
3. In your own python program, you have to import functions in :file:`AFD.py`. For example, ``from AFD import *``


