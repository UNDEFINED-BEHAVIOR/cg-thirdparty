@ECHO OFF

SET ROOT_DIR=%~dp0

REM SET XT_TMP=%ROOT_DIR%_xtensor_tmp
REM MKDIR %XT_TMP%
REM -DCMAKE_PREFIX_PATH=%XT_TMP%

SET XTL_RP=%ROOT_DIR%xtl
CD %XTL_RP%
CALL %ROOT_DIR%_build_for_curdir.cmd

SET XTENSOR_RP=%ROOT_DIR%xtensor
CD %XTENSOR_RP%
CALL %ROOT_DIR%_build_for_curdir.cmd ^
-Dxtl_DIR=%ROOT_DIR%xtl/build

SET XTENSOR_BLAS_RP=%ROOT_DIR%xtensor-blas
CD %XTENSOR_BLAS_RP%
CALL %ROOT_DIR%_build_for_curdir.cmd ^
-Dxtl_DIR=%ROOT_DIR%xtl/build ^
-Dxtensor_DIR=%ROOT_DIR%xtensor/build

CD %ROOT_DIR%

CMD /k