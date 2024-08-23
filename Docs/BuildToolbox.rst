.. _installation-label:

Installation Instructions
=====================================================================

Matlab
--------

1. Download this toolbox from `Github <https://github.com/pikipity/Toolbox-for-Adaptive-Fourier-Decomposition-MATLAB>`_ or `MathWork file exchange <https://www.mathworks.com/matlabcentral/fileexchange/62783-toolbox-for-adaptive-fourier-decomposition>`_.

2. Add the folder and subfolder to the searching path of Matlab. For example, 

.. code-block:: matlab

    addpath(genpath('Toolbox-for-Adaptive-Fourier-Decomposition-MATLAB'))

Python
-------

This toolbox require ``Python>=3.9``.

Install from pip
^^^^^^^^^^^^^^^^^^^^^^

If you have not installed this toolbox, you can install it by

``pip install Toolbox-for-Adaptive-Fourier-Decomposition``

If you already installed this toolbox from pip, you can update it by 

``pip install --upgrade --force-reinstall Toolbox-for-Adaptive-Fourier-Decomposition``


Directly download from Github
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. Donwload or clone `this repository <https://github.com/pikipity/Toolbox-for-Adaptive-Fourier-Decomposition.git>`_.
   
   ``git clone https://github.com/pikipity/Toolbox-for-Adaptive-Fourier-Decomposition.git``

2. Install required packages. You can find all required packages in :file:`environment.yml`. If you use `conda <https://docs.conda.io/projects/conda/en/latest/user-guide/install/index.html>`_ or `Anaconda <https://www.anaconda.com/>`_, you can create a new virtual environment using :file:`environment.yml`.
   
   ``conda env create -f environment.yml``

3. Now, you can use this toolbox. If you use ``conda`` or ``anaconda``, do not forget to enter your virtual environment. In addition, when you use this toolbox, remember add the toolbox's path in your python searching path. You can add the follow code in your python file.

    .. code:: ipython3

        import sys
        sys.path.append(<toolbox_path>)