cmake_minimum_required(VERSION 3.14)

# project will be c++17!
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# add_subdirectory(boost-cmake)
# add_subdirectory(OpenBLAS)

# --envs
#boost
set(BUILD_TESTING OFF CACHE BOOL "" FORCE)
set(CMAKE_TESTING_ENABLED OFF CACHE BOOL "" FORCE)

set(
    BOOST_ROOT
    ${CMAKE_CURRENT_SOURCE_DIR}/boost-cmake/build/_deps/boost-src
)
set(
    BOOST_LIBRARYDIR
    ${CMAKE_CURRENT_SOURCE_DIR}/boost-cmake/build/Release
)

# for openblas
set(
    CMAKE_INCLUDE_PATH
    ${CMAKE_CURRENT_SOURCE_DIR}/OpenBLAS
)
set(
    BLAS_LIBDIR
    ${CMAKE_CURRENT_SOURCE_DIR}/OpenBLAS/build/lib/RELEASE
)
set(
    LAPACK_LIBRARIES
    ${BLAS_LIBDIR}/openblas.lib
)


# --

#parallelizer series
# disable because project isn't private
# set(TBB_BUILD_TESTS OFF CACHE BOOL "" FORCE)
# add_subdirectory(tbb)

set(TF_BUILD_TESTS OFF CACHE BOOL "" FORCE)
set(TF_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
add_subdirectory(cpp-taskflow)

add_subdirectory(triSYCL)

# not ready for msvc https://github.com/KhronosGroup/SyclParallelSTL/pull/41
# todo: resolve
# add_subdirectory(SyclParallelSTL)

add_subdirectory(eigen-git-mirror)

#blaze
# todo: resolve LAPACK not found
# add_subdirectory(blaze)


#xtensor series
# todo: resolve installing xtl
# add_subdirectory(xsimd)
# add_subdirectory(xtl)
# add_subdirectory(xtensor)

option(PYTHON_MAYA "Use maya python" OFF)
if(PYTHON_MAYA)
    find_package(Maya REQUIRED)
    set(PYTHON_EXECUTABLE "${MAYA_INCLUDE_DIR}/../bin/mayapy.exe" CACHE STRING "" FORCE)
endif()

set(PYBIND11_TEST OFF CACHE BOOL "" FORCE)
add_subdirectory(pybind11)