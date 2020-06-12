@ECHO OFF

SET ROOT_DIR=%~dp0
SET LOCAL_LIB_DIR=%TEMP%\_local_lib_cpp
SET LOCAL_BLD_DIR=%TEMP%\_local_bld_cpp

IF [%BOOST_ROOT%] NEQ [] GOTO CONTINUE1

:USE_DEFAULT_INSTALL
ECHO Warning: BOOST_INSTALL_PATH has not been specified, using default install path
SET BOOST_ROOT=%ROOT_DIR%boost-lib

:CONTINUE1

SET BOOST_LIBRARYDIR=%BOOST_ROOT%/lib


CALL %ROOT_DIR%_build_for_module.cmd zlib
CALL %ROOT_DIR%_build_for_module.cmd bzip2_cmake
CALL %ROOT_DIR%_build_for_module.cmd zstd

REM XTENSOR

SET XTENSOR_USE_XSIMD=1
SET XTENSOR_USE_OPENMP=1
SET BUILD_TESTS=0
SET BUILD_BENCHMARK=0

CALL %ROOT_DIR%_build_for_module.cmd xtl
CALL %ROOT_DIR%_build_for_module.cmd xsimd

REM SET EXTRAARGS=-Dxtl_DIR=%LOCAL_LIB_DIR%\xtl\lib\cmake\xtl
CALL %ROOT_DIR%_build_for_module.cmd xtensor

REM SET EXTRAARGS=-Dxtl_DIR=%LOCAL_LIB_DIR%\xtl\lib\cmake\xtl -Dxtensor_DIR=%LOCAL_LIB_DIR%\xtensor\lib\cmake\xtensor
CALL %ROOT_DIR%_build_for_module.cmd xtensor-blas


REM build boost

REM CD %ROOT_DIR%tbb
REM CALL %ROOT_DIR%_build_for_module.cmd

REM Targeting win 10 64 bit
REM https://docs.microsoft.com/en-us/cpp/porting/modifying-winver-and-win32-winnt?view=vs-2019

REM -DICU_INCLUDE_DIR=%ICU_RP%\build\icu_pre-prefix\src\icu_pre\include^
REM -DICU_LIBRARY=%ICU_RP%\build\icu_pre-prefix\src\icu_pre\lib
REM SET EXTRAARGS=^
REM -DBZIP2_INCLUDE_DIR=%LOCAL_LIB_DIR%\bzip2_cmake\include ^
REM -DBZIP2_LIBRARIES=%LOCAL_LIB_DIR%\bzip2_cmake\lib ^
REM -DZLIB_INCLUDE_DIR=%LOCAL_LIB_DIR%\zlib\include ^
REM -DZLIB_LIBRARY=%LOCAL_LIB_DIR%\zlib\lib ^
REM -DBOOST_DISABLE_TESTS=ON ^
REM -D_WIN32_WINNT=0x0A00
REM CALL %ROOT_DIR%_build_for_module_no_install.cmd boost-cmake

REM REM Have to copy boost libs manually..

REM ROBOCOPY ^
REM %LOCAL_BLD_DIR%\boost-cmake\_deps\boost-src\boost ^
REM %LOCAL_LIB_DIR%\boost-cmake\boost ^
REM /E

REM ROBOCOPY ^
REM %LOCAL_BLD_DIR%\boost-cmake\Release ^
REM %LOCAL_LIB_DIR%\boost-cmake\lib ^
REM /E

CMD /k