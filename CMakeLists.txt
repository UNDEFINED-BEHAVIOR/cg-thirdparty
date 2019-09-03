cmake_minimum_required(VERSION 3.14)

# project will be c++17!
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# add_subdirectory(boost-cmake)
# add_subdirectory(OpenBLAS)

set(
    LOCAL_LIB_DIR
    $ENV{TEMP}/_local_lib_cpp
)

# --general envs
#boost
set(
    BUILD_TESTING OFF 
    CACHE BOOL "" FORCE
)
set(
    CMAKE_TESTING_ENABLED OFF 
    CACHE BOOL "" FORCE
)

set(
    BOOST_ROOT
    ${LOCAL_LIB_DIR}/boost-cmake
    CACHE STRING "" FORCE
)
set(
    BOOST_LIBRARYDIR
    ${LOCAL_LIB_DIR}/boost-cmake/lib
    CACHE STRING "" FORCE
)

# for openblas
set(
    CMAKE_INCLUDE_PATH
    ${LOCAL_LIB_DIR}/OpenBLAS/include
    CACHE STRING "" FORCE
)
set(
    BLAS_LIBDIR
    ${LOCAL_LIB_DIR}/OpenBLAS/lib
    CACHE STRING "" FORCE
)
set(
    LAPACK_LIBRARIES
    ${BLAS_LIBDIR}/openblas.lib
    CACHE STRING "" FORCE
)
set(
    BLAS_LIBRARIES
    ${BLAS_LIBDIR}/openblas.lib
    CACHE STRING "" FORCE
)

# --

# parallelizer series
# disable because project isn't private
# set(TBB_BUILD_TESTS OFF CACHE BOOL "" FORCE)
# add_subdirectory(tbb)

set(
    TF_BUILD_TESTS OFF 
    CACHE BOOL "" FORCE
)
set(
    TF_BUILD_EXAMPLES OFF 
    CACHE BOOL "" FORCE
)
add_subdirectory(cpp-taskflow)

set(
    TRISYCL_OPENCL ON
    CACHE BOOL "" FORCE
)
set(
    TRISYCL_OPENMP ON
    CACHE BOOL "" FORCE
)
add_subdirectory(triSYCL)

# # todo: resolve
# set(
#     ComputeCpp_DIR
#     ${CMAKE_CURRENT_SOURCE_DIR}/computecpp-sdk
#     CACHE STRING "" FORCE
# )
# set(
#     COMPUTECPP_SDK_BUILD_TESTS OFF
#     CACHE BOOL "" FORCE
# )
# set(
#     COMPUTECPP_SDK_USE_OPENMP ON
#     CACHE BOOL "" FORCE
# )
# add_subdirectory(computecpp-sdk)
# add_subdirectory(SyclParallelSTL)

set(
    EIGEN_TEST_CXX11 ON 
    CACHE BOOL "" FORCE
)
add_subdirectory(eigen-git-mirror)

# blaze
add_subdirectory(blaze)


# xtensor series
set(
    xtl_DIR
    ${LOCAL_LIB_DIR}/xtl/lib/pkgconfig
    CACHE STRING "" FORCE
)
set(
    xtensor_DIR
    ${LOCAL_LIB_DIR}/xtensor/lib/pkgconfig
    CACHE STRING "" FORCE
)
add_subdirectory(xsimd)
add_subdirectory(xtl)
add_subdirectory(xtensor)
add_subdirectory(xtensor-blas)

option(PYTHON_MAYA "Use maya python" OFF)
if(PYTHON_MAYA)
    find_package(Maya REQUIRED)
    set(PYTHON_EXECUTABLE "${MAYA_INCLUDE_DIR}/../bin/mayapy.exe" CACHE STRING "" FORCE)
endif()

add_subdirectory(MayaAPIUtils)

set(PYBIND11_TEST OFF CACHE BOOL "" FORCE)
add_subdirectory(pybind11)