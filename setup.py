import setuptools

with open("README.markdown", "r", encoding="utf8") as fh:
    long_description = fh.read()

setuptools.setup(
    name="Toolbox-for-Adaptive-Fourier-Decomposition",
    version="2.1.0",
    author="Ze Wang",
    author_email="pikipityw@gmail.com",
    description="Toolbox of adaptive Fourier decomposition (AFD) for Python.",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/pikipity/Toolbox-for-Adaptive-Fourier-Decomposition",
    packages=setuptools.find_packages(),
    # package_dir={"": "AFDCal"},
    # packages=setuptools.find_packages(where="AFDCal"),
    classifiers=[
        "Programming Language :: Python :: 3.9",
        "Operating System :: OS Independent",
    ],
    # Required packages
    install_requires=[
        'numpy<=1.23,>1.0',
        'scipy<=1.13,>1.0',
        'joblib<=1.4,>1.0',
        'matplotlib<=3.8,>3.0',
        'mat73<=1.0'
    ],
    python_requires='>=3.9',
)
