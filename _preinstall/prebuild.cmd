@ECHO OFF

SET ROOT_DIR=%~dp0
SET LOCAL_LIB_DIR=%TEMP%\_local_lib_cpp
SET LOCAL_BLD_DIR=%TEMP%\_local_bld_cpp

CALL %ROOT_DIR%_build_for_module.cmd zlib

CALL %ROOT_DIR%_build_for_module.cmd bzip2_cmake

CALL %ROOT_DIR%_build_for_module.cmd xtl

rem todo reenable
REM SET EXTRAARGS=-Dxtl_DIR=%LOCAL_LIB_DIR%\xtl\lib\cmake\xtl
REM CALL %ROOT_DIR%_build_for_module.cmd xtensor

REM SET EXTRAARGS=-Dxtl_DIR=%LOCAL_LIB_DIR%\xtl\lib\cmake\xtl -Dxtensor_DIR=%LOCAL_LIB_DIR%\xtensor\lib\cmake\xtensor
REM CALL %ROOT_DIR%_build_for_module.cmd xtensor-blas

REM CALL %ROOT_DIR%_build_for_module.cmd xsimd

CALL %ROOT_DIR%_build_for_module.cmd zstd\build\cmake

REM build boost

REM SET EXTRAARGS=^
REM -DBZIP2_INCLUDE_DIR=%LOCAL_LIB_DIR%\bzip2_cmake\include ^
REM -DBZIP2_LIBRARIES=%LOCAL_LIB_DIR%\bzip2_cmake\lib ^
REM -DZLIB_INCLUDE_DIR=%LOCAL_LIB_DIR%\zlib\include ^
REM -DZLIB_LIBRARY=%LOCAL_LIB_DIR%\zlib\lib ^
REM -DBOOST_DISABLE_TESTS=ON ^
REM -D_WIN32_WINNT=0x0A00
REM CALL %ROOT_DIR%_build_for_module_no_install.cmd boost-cmake

REM REM REM Have to copy boost libs manually..

REM ROBOCOPY ^
REM %LOCAL_BLD_DIR%\boost-cmake\_deps\boost-src\boost ^
REM %LOCAL_LIB_DIR%\boost-cmake\boost ^
REM /E

REM ROBOCOPY ^
REM %LOCAL_BLD_DIR%\boost-cmake\Release ^
REM %LOCAL_LIB_DIR%\boost-cmake\lib ^
REM /E

BITSADMIN /transfer boostdl download ^
https://dl.bintray.com/boostorg/release/1.73.0/source/boost_1_73_0.7z ^
boost/boost_dl.7z

7z x boost\boost_dl.7z -aos -oboost

SET BZIP2_INCLUDE_DIR=%LOCAL_LIB_DIR%\bzip2_cmake\include
SET BZIP2_LIBRARIES=%LOCAL_LIB_DIR%\bzip2_cmake\lib
SET ZLIB_INCLUDE_DIR=%LOCAL_LIB_DIR%\zlib\include
SET ZLIB_LIBRARY=%LOCAL_LIB_DIR%\zlib\lib
SET BOOST_DISABLE_TESTS=ON

SET ZLIB_SOURCE=e:\sandbox\mayaProj\thirdparty\_preinstall\boost\zlib-1.2.11
SET BZIP2_SOURCE=e:\sandbox\mayaProj\thirdparty\_preinstall\bzip2_cmake

PUSHD boost\boost_1_73_0
bootstrap.bat

b2 ^
install ^
-j8 ^
--prefix=e:\sandbox\mayaProj\thirdparty\_preinstall\boost\tst ^
--build-type=complete ^
-sZLIB_SOURCE=e:\sandbox\mayaProj\thirdparty\_preinstall\boost\zlib-1.2.11 ^
-sBZIP2_SOURCE=e:\sandbox\mayaProj\thirdparty\_preinstall\bzip2_cmake ^
-sZSTD_SOURCE=e:\sandbox\mayaProj\thirdparty\_preinstall\zstd ^
variant=debug,release ^
address-model=64 ^
link=static ^
threading=multi ^
runtime-link=static ^
.


b2 ^
install ^
-j8 ^
--prefix=e:\sandbox\mayaProj\thirdparty\_preinstall\boost\tst ^
--build-type=complete ^
variant=debug,release ^
address-model=64 ^
link=static ^
threading=multi ^
runtime-link=shared ^
.

POPD

CddreMD /k