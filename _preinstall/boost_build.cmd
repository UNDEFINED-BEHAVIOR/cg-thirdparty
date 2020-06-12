@ECHO OFF

SET ROOT_DIR=%~dp0

SET LOCAL_LIB_DIR=%TEMP%\_local_lib_cpp
SET LOCAL_BLD_DIR=%TEMP%\_local_bld_cpp


IF [%BOOST_INSTALL_PATH%] NEQ [] GOTO CONTINUE1

:USE_DEFAULT_INSTALL
ECHO Warning: BOOST_INSTALL_PATH has not been specified, using default install path
SET BOOST_INSTALL_PATH=%ROOT_DIR%boost-lib

:CONTINUE1

ECHO Boost Install Path:
ECHO %BOOST_INSTALL_PATH%

MKDIR %BOOST_INSTALL_PATH%

PUSHD boost\boost_1_73_0

b2 ^
install ^
-j8 ^
--prefix=%BOOST_INSTALL_PATH% ^
--build-type=complete ^
-sZLIB_SOURCE=%ROOT_DIR%zlib ^
-sBZIP2_SOURCE=%ROOT_DIR%bzip2_cmake ^
variant=debug,release ^
address-model=64 ^
link=static ^
threading=multi ^
runtime-link=static ^
. > build.log

POPD

CMD /k