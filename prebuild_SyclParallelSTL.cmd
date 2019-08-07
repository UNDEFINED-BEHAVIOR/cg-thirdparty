@ECHO OFF

SET ROOT_DIR=%~dp0

SET RP=%ROOT_DIR%computecpp-sdk
CD %RP%
CALL %ROOT_DIR%_build_for_curdir.cmd ^
-DComputeCpp_DIR=%RP%

CD %ROOT_DIR%

CMD /k