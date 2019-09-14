cmake_minimum_required(VERSION 3.14)

# project will be c++17!
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

option(USE_BLAS "Use blas for all applicable libraries" OFF)
option(USE_MAYAPY "Use maya python" OFF)
option(USE_EIGEN "Use eigen3" OFF)

message("CG Thirdparty:")
message("BLAS active: ${USE_BLAS}")
message("Using Mayapy as python: ${USE_MAYAPY}")
message("Eigen active: ${USE_EIGEN}")

if(NOT LOCAL_LIB_DIR)
    message(FATAL "LOCAL_LIB_DIR variable is required")
endif()

# add_subdirectory(boost-cmake)
# add_subdirectory(OpenBLAS)

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
if(USE_BLAS)
    set(
        CMAKE_INCLUDE_PATH
        OpenBLAS
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

    add_library(
        BLASLib
        INTERFACE
    )
    target_sources(
        BLASLib
        INTERFACE
        ${LOCAL_LIB_DIR}/OpenBLAS/lib/libopenblas.dll
    )
    target_link_libraries(
        BLASLib
        INTERFACE
        ${BLAS_LIBRARIES}
    )
    # set_target_properties(
    #     BLASLib
    #     PROPERTIES
    #     LINKER_LANGUAGE C
    # )
endif()

# --

add_subdirectory(fmt)
add_subdirectory(units)

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

# add_subdirectory(SyclParallelSTL)

if(USE_EIGEN)
    set(
        EIGEN_TEST_CXX11 ON 
        CACHE BOOL "" FORCE
    )
    set(
        EIGEN_USE_BLAS ON 
        CACHE BOOL "" FORCE
    )
    set(
        EIGEN_USE_LAPACKE ON 
        CACHE BOOL "" FORCE
    )
    set(
        EIGEN_TEST_EXTERNAL_BLAS ON
        CACHE BOOL "" FORCE
    )
    add_subdirectory(eigen-git-mirror)
endif()

# blaze
# add_subdirectory(blaze)


# xtensor series
set(
    XTENSOR_USE_XSIMD ON
    CACHE BOOL "" FORCE
)
set(
    XTENSOR_USE_OPENMP ON
    CACHE BOOL "" FORCE
)
set(
    BUILD_TESTS OFF
    CACHE BOOL "" FORCE
)
set(
    BUILD_BENCHMARK OFF
    CACHE BOOL "" FORCE
)
set(
    xtl_DIR
    ${LOCAL_LIB_DIR}/xtl/lib/cmake/xtl
    CACHE STRING "" FORCE
)
set(
    xsimd_DIR
    ${LOCAL_LIB_DIR}/xsimd/lib/cmake/xsimd
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

if(USE_BLAS)

    # xtensor
    set(
        USE_OPENBLAS ON
        CACHE BOOL "" FORCE
    )
    add_subdirectory(xtensor-blas)
    # todo fix this
    target_include_directories(
        xtensor
        INTERFACE
        ${LOCAL_LIB_DIR}/xtensor-blas/include
    )
    target_link_libraries(
        xtensor
        INTERFACE
        ${BLAS_LIBRARIES}
        ${LAPACK_LIBRARIES}
    )
endif()


if(USE_MAYAPY)
    find_package(Maya REQUIRED)
    set(
        PYTHON_EXECUTABLE "${MAYA_INCLUDE_DIR}/../bin/mayapy.exe" 
        CACHE STRING "" FORCE
    )
endif()

add_subdirectory(MayaAPIUtils)

set(PYBIND11_TEST OFF CACHE BOOL "" FORCE)
add_subdirectory(pybind11)
