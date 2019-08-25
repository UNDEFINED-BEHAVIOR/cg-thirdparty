@ECHO OFF

SET ROOT_DIR=%~dp0
SET LOCAL_LIB_DIR=%TEMP%\_local_lib_cpp
SET LOCAL_BLD_DIR=%TEMP%\_local_bld_cpp

CALL %ROOT_DIR%_build_for_curdir.cmd zlib

CALL %ROOT_DIR%_build_for_curdir.cmd bzip2_cmake

CALL %ROOT_DIR%_build_for_curdir.cmd xtl

SET xtl_DIR ${CMAKE_CURRENT_SOURCE_DIR}/xtl/build
    CACHE STRING "" FORCE
)

SET EXTRAARGS=-Dxtl_DIR=%LOCAL_LIB_DIR%\xtl\lib\cmake\xtl
CALL %ROOT_DIR%_build_for_curdir.cmd xtensor

CALL %ROOT_DIR%_build_for_curdir.cmd xsimd

CMD /k

REM CD %ROOT_DIR%tbb
REM CALL %ROOT_DIR%_build_for_curdir.cmd

ECHO Building boost

REM Targeting win 10 64 bit
REM https://docs.microsoft.com/en-us/cpp/porting/modifying-winver-and-win32-winnt?view=vs-2019

REM -DICU_INCLUDE_DIR=%ICU_RP%\build\icu_pre-prefix\src\icu_pre\include^
REM -DICU_LIBRARY=%ICU_RP%\build\icu_pre-prefix\src\icu_pre\lib
SET EXTRAARGS=^
-DCMAKE_INSTALL_PREFIX="%LOCAL_DEP_DIR%" ^
-DCMAKE_PREFIX_PATH="%LOCAL_DEP_DIR%" ^
-DBOOST_DISABLE_TESTS=ON ^
-D_WIN32_WINNT=0x0A00
CALL %ROOT_DIR%_build_for_curdir.cmd boost-cmake ^

CMD /k