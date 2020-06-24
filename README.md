# cg-thirdparty

A collection of (almost) ready-to-use thirdparty libraries for c++ DCC tool development.

WIP

* BLAS and LAPACK backends for Xtensor-stack, eigen and blaze

## Libraries directly loadable as cmake targets


* cpp-taskflow
* eigen
* fmt
* MayaAPIUtils
* triSYCL
* units
* XTensor
* XSIMD
* XTensor-blas

## Libraries loadable with find_package()

* fmt
* VexCL
* zstd
* zlib
* bzip2

# Installation
## Prerequisite:

* Visual studio 2019+
* 7z
* cmake
* boost
* system python2/3

## Pre-installations:
### boost:

Download https://dl.bintray.com/boostorg/release/1.73.0/source/boost_1_73_0.7z, rename to boost_dl.7z and place it on ./boost

Set BOOST_ROOT environment variable to root of desired boost installation path
(Defaults to ./boost-lib on pre-build step if not set)

Run boost_extract.cmd
run boost's bootstrap.bat

### blas: (WIP)

#### In case of building from the included OpenBLAS library
Just follow one of the build instructions or use your blas library of choice
https://github.com/xianyi/OpenBLAS/wiki/How-to-use-OpenBLAS-in-Microsoft-Visual-Studio
Place your resulting openblas.lib at lib-blas/openblas.lib
And openblas.dll (rename it) at lib-blas/openblas.dll
Include path should point at 

# Usage

Close this project into your top project repo as a submodule,
perform add_directory to add this project to your cmake system.

WIP