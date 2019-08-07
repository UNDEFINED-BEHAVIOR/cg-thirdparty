ECHO -----------------Building for %CD%

MKDIR build
PUSHD build

cmake ^
.. ^
-A x64 %*

cmake ^
--build . ^
--parallel 8 ^
--config Release

POPD