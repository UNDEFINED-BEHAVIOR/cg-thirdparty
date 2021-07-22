@ECHO OFF

SET ROOT_DIR=%~dp0

SET LOCAL_LIB_DIR=%TEMP%\_local_lib_cpp
SET LOCAL_BLD_DIR=%TEMP%\_local_bld_cpp


IF [%BOOST_ROOT%] NEQ [] GOTO CONTINUE1

:USE_DEFAULT_INSTALL
ECHO Warning: BOOST_ROOT has not been specified, using default install path
SET BOOST_ROOT=%ROOT_DIR%lib-boost

:CONTINUE1

ECHO Boost Install Path:
ECHO %BOOST_ROOT%

MKDIR %BOOST_ROOT%

PUSHD boost\boost_1_73_0

b2 ^
install ^
-j8 ^
--prefix=%BOOST_ROOT% ^
--build-type=complete ^
-sZLIB_SOURCE=%ROOT_DIR%zlib ^
-sBZIP2_SOURCE=%ROOT_DIR%bzip2_cmake ^
variant=debug,release ^
address-model=64 ^
link=static ^
threading=multi ^
runtime-link=static,shared ^
.

POPD

CMD /k