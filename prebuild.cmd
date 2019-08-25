@ECHO OFF

SET ROOT_DIR=%~dp0
SET LOCAL_LIB_DIR=%TEMP%\_local_lib_cpp
SET LOCAL_BLD_DIR=%TEMP%\_local_bld_cpp

REM CALL %ROOT_DIR%_build_for_module.cmd zlib

REM CALL %ROOT_DIR%_build_for_module.cmd bzip2_cmake

REM CALL %ROOT_DIR%_build_for_module.cmd xtl

REM SET EXTRAARGS=-Dxtl_DIR=%LOCAL_LIB_DIR%\xtl\lib\cmake\xtl
REM CALL %ROOT_DIR%_build_for_module.cmd xtensor

REM CALL %ROOT_DIR%_build_for_module.cmd xsimd

REM REM build boost

REM REM CD %ROOT_DIR%tbb
REM REM CALL %ROOT_DIR%_build_for_module.cmd

REM REM Targeting win 10 64 bit
REM REM https://docs.microsoft.com/en-us/cpp/porting/modifying-winver-and-win32-winnt?view=vs-2019

REM REM -DICU_INCLUDE_DIR=%ICU_RP%\build\icu_pre-prefix\src\icu_pre\include^
REM REM -DICU_LIBRARY=%ICU_RP%\build\icu_pre-prefix\src\icu_pre\lib
REM SET EXTRAARGS=^
REM -DBZIP2_INCLUDE_DIR=%LOCAL_LIB_DIR%\bzip2_cmake\include ^
REM -DBZIP2_LIBRARIES=%LOCAL_LIB_DIR%\bzip2_cmake\lib ^
REM -DZLIB_INCLUDE_DIR=%LOCAL_LIB_DIR%\zlib\include ^
REM -DZLIB_LIBRARY=%LOCAL_LIB_DIR%\zlib\lib ^
REM -DBOOST_DISABLE_TESTS=ON ^
REM -D_WIN32_WINNT=0x0A00
REM CALL %ROOT_DIR%_build_for_module_no_install.cmd boost-cmake

REM REM Have to copy boost libs manually..

ROBOCOPY ^
%LOCAL_BLD_DIR%\boost-cmake\_deps\boost-src\boost ^
%LOCAL_LIB_DIR%\boost\boost ^
/E

ROBOCOPY ^
%LOCAL_BLD_DIR%\boost-cmake\Release ^
%LOCAL_LIB_DIR%\boost\lib ^
/E

CMD /k