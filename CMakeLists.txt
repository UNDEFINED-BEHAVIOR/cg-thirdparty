cmake_minimum_required(VERSION 3.14)

# project will be c++17!
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

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

# blaze
# add_subdirectory(blaze)


# xtensor series
set(
    XTENSOR_USE_XSIMD ON
    CACHE BOOL "" FORCE
)
set(
    USE_OPENBLAS ON
    CACHE BOOL "" FORCE
)
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

if(XTENSOR_USE_XSIMD)
    # todo fix this
    target_include_directories(
        xtensor
        INTERFACE
        ${LOCAL_LIB_DIR}/xtensor-blas/include
    )
    # target_link_libraries(
    #     xtensor
    #     INTERFACE
    #     BLASLib
    # )
    target_link_libraries(
        xtensor
        INTERFACE
        ${BLAS_LIBRARIES}
        ${LAPACK_LIBRARIES}
    )
    # add_custom_command(
    #     TARGET xtensor POST_BUILD 
    #     COMMAND 
    #     ${CMAKE_COMMAND} -E copy_if_different
    #     "${LOCAL_LIB_DIR}/OpenBlas/lib/libopenblas.dll"
    #     $<TARGET_FILE_DIR:${CMAKE_BINARY_DIR}>
    # )
endif()

option(PYTHON_MAYA "Use maya python" OFF)
if(PYTHON_MAYA)
    find_package(Maya REQUIRED)
    set(
        PYTHON_EXECUTABLE "${MAYA_INCLUDE_DIR}/../bin/mayapy.exe" 
        CACHE STRING "" FORCE
    )
endif()

add_subdirectory(MayaAPIUtils)

set(PYBIND11_TEST OFF CACHE BOOL "" FORCE)
add_subdirectory(pybind11)
