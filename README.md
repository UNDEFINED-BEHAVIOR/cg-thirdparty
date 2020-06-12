# cg-thirdparty

A collection of frequently used thirdparty library for c++ DCC tool development.

WIP

Prerequisite:

Visual studio 2019+
7z
cmake

boost:

Download https://dl.bintray.com/boostorg/release/1.73.0/source/boost_1_73_0.7z, rename to boost_dl.7z and place it on ./boost
Set BOOST_INSTALL_PATH environment variable to root of desired boost installation path
(Defaults to ./boost-lib)
Run boost_extract.cmd
run boost's bootstrap.bat

blas:
unfortunately openblas does not provide prebuild binary anymore..
blas binaries https://sourceforge.net/projects/openblas/files/v0.3.9/

Just follow one of the build instructions or use your blas library of choice
https://github.com/xianyi/OpenBLAS/wiki/How-to-use-OpenBLAS-in-Microsoft-Visual-Studio

