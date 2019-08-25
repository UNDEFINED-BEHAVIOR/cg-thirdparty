@ECHO OFF

SET ROOT_DIR=%~dp0
SET LOCAL_LIB_DIR=%TEMP%\_local_lib_cpp
SET LOCAL_BLD_DIR=%TEMP%\_local_bld_cpp

CALL %ROOT_DIR%_build_for_module.cmd zlib

CALL %ROOT_DIR%_build_for_module.cmd bzip2_cmake

CALL %ROOT_DIR%_build_for_module.cmd xtl

SET EXTRAARGS=-Dxtl_DIR=%LOCAL_LIB_DIR%\xtl\lib\cmake\xtl
CALL %ROOT_DIR%_build_for_module.cmd xtensor

CALL %ROOT_DIR%_build_for_module.cmd xsimd

REM build boost

REM CD %ROOT_DIR%tbb
REM CALL %ROOT_DIR%_build_for_module.cmd

REM Targeting win 10 64 bit
REM https://docs.microsoft.com/en-us/cpp/porting/modifying-winver-and-win32-winnt?view=vs-2019

REM -DICU_INCLUDE_DIR=%ICU_RP%\build\icu_pre-prefix\src\icu_pre\include^
REM -DICU_LIBRARY=%ICU_RP%\build\icu_pre-prefix\src\icu_pre\lib
SET EXTRAARGS=^
-DBZIP2_INCLUDE_DIR=%LOCAL_LIB_DIR%\bzip2_cmake\include ^
-DBZIP2_LIBRARIES=%LOCAL_LIB_DIR%\bzip2_cmake\lib ^
-DZLIB_INCLUDE_DIR=%LOCAL_LIB_DIR%\zlib\include ^
-DZLIB_LIBRARY=%LOCAL_LIB_DIR%\zlib\lib ^
-DBOOST_DISABLE_TESTS=ON ^
-D_WIN32_WINNT=0x0A00
CALL %ROOT_DIR%_build_for_module_no_install.cmd boost-cmake

REM REM Have to copy boost libs manually..

ROBOCOPY ^
%LOCAL_BLD_DIR%\boost-cmake\_deps\boost-src\boost ^
%LOCAL_LIB_DIR%\boost-cmake\boost ^
/E

ROBOCOPY ^
%LOCAL_BLD_DIR%\boost-cmake\Release ^
%LOCAL_LIB_DIR%\boost-cmake\lib ^
/E

CMD /k