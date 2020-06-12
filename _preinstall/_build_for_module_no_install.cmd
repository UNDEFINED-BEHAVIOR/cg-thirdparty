SET FOLP=%1

ECHO.
ECHO ####################################################
ECHO ##### Building %FOLP%
ECHO ####################################################
ECHO.

REM https://stackoverflow.com/a/935681
SET RESTVAR=
SHIFT
:loop1
    IF "%1"=="" GOTO after_loop
    SET RESTVAR=%RESTVAR% %1
    SHIFT
GOTO loop1
:after_loop

SET SRC_FOL=%ROOT_DIR%%FOLP%
SET BLD_FOL=%LOCAL_BLD_DIR%\%FOLP%
SET INST_FOL=%LOCAL_LIB_DIR%\%FOLP%

ECHO %FOLP%
ECHO %SRC_FOL%

MKDIR %BLD_FOL%
PUSHD %BLD_FOL%

REM @ECHO ON
cmake ^
%SRC_FOL% ^
-A x64 ^
-DCMAKE_INSTALL_PREFIX=%INST_FOL% ^
-DCMAKE_PREFIX_PATH=%INST_FOL% %EXTRAARGS%

cmake ^
--build . ^
--parallel %NUMBER_OF_PROCESSORS% ^
--config Release

SET EXTRAARGS=

POPD