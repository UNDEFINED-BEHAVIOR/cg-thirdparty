REM @ECHO OFF

SET ROOT_DIR=%~dp0
SET LOCAL_LIB_DIR=%TEMP%\_local_lib_cpp
SET LOCAL_BLD_DIR=%TEMP%\_local_bld_cpp

IF [%BOOST_ROOT%] NEQ [] GOTO CONTINUE1

:USE_DEFAULT_INSTALL
ECHO Warning: BOOST_INSTALL_PATH has not been specified, using default install path
SET BOOST_ROOT=%ROOT_DIR%boost-lib

:CONTINUE1

REM SET Boost_ROOT=%BOOST_ROOT%
REM SET BOOST_INCLUDE_DIR=%BOOST_ROOT%/include/boost-1_73
REM SET Boost_INCLUDE_DIR=%BOOST_INCLUDE_DIR%
REM SET BOOST_LIBRARYDIR=%BOOST_ROOT%/lib


SET BUILD_TESTS=0
SET BUILD_BENCHMARK=0
SET CMAKE_TESTING_ENABLED=0

CALL %ROOT_DIR%_build_for_module.cmd zlib
CALL %ROOT_DIR%_build_for_module.cmd bzip2_cmake

CALL %ROOT_DIR%_build_for_module.cmd zstd\build\cmake
SET _ZSTD_LIB_DIR=%LOCAL_LIB_DIR%\zstd\build\cmake
XCOPY ^
%_ZSTD_LIB_DIR%\* ^
%LOCAL_LIB_DIR%\zstd ^
/E /I /M /Y
REM Get rid of empty folder
RMDIR /Q /S ^
%LOCAL_LIB_DIR%\zstd\build

REM ===========XTENSOR

SET XTENSOR_USE_XSIMD=1
SET XTENSOR_USE_OPENMP=1
REM todo: resolve blas

CALL %ROOT_DIR%_build_for_module.cmd xtl
CALL %ROOT_DIR%_build_for_module.cmd xsimd

SET EXTRAARGS=-Dxtl_DIR=%LOCAL_LIB_DIR%\xtl\lib\cmake\xtl
CALL %ROOT_DIR%_build_for_module.cmd xtensor

REM todo: resolve
SET EXTRAARGS=-Dxtl_DIR=%LOCAL_LIB_DIR%\xtl\lib\cmake\xtl -Dxtensor_DIR=%LOCAL_LIB_DIR%\xtensor\lib\cmake\xtensor
CALL %ROOT_DIR%_build_for_module.cmd xtensor-blas

REM todo: resolve blas
REM REM ===========EIGEN
REM SET EIGEN_TEST_CXX11=1
REM SET EIGEN_USE_BLAS=1
REM SET EIGEN_USE_LAPACK=1
REM SET EIGEN_TEST_EXTERNAL_BLAS=1
REM CALL %ROOT_DIR%_build_for_module.cmd eigen-git-mirror
REM REM ===========

REM CALL %ROOT_DIR%_build_for_module.cmd OpenBLAS

REM SET TF_BUILD_TESTS=0
REM SET TF_BUILD_SAMPLES=0
REM CALL %ROOT_DIR%_build_for_module.cmd cpp-taskflow

REM SET Boost_ROOT=%BOOST_ROOT%
REM SET TRISYCL_OPENCL=1
REM SET TRISYCL_OPENMP=1
REM REM SET Boost_ROOT=%BOOST_ROOT%
REM CALL %ROOT_DIR%_build_for_module.cmd triSYCL

CALL %ROOT_DIR%_build_for_module.cmd fmt
REM SET EXTRAARGS=-DBoost_ROOT=%BOOST_ROOT%
CALL %ROOT_DIR%_build_for_module.cmd vexcl

REM todo: reenable?
REM CALL %ROOT_DIR%_build_for_module.cmd tbb

REM Targeting win 10 64 bit
REM https://docs.microsoft.com/en-us/cpp/porting/modifying-winver-and-win32-winnt?view=vs-2019

CMD /k