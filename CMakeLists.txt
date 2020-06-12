CMAKE_MINIMUM_REQUIRED(VERSION 3.14)

# project will be c++17!
SET(CMAKE_CXX_STANDARD 17)
SET(CMAKE_CXX_STANDARD_REQUIRED ON)

OPTION(USE_BLAS "Use blas for all applicable libraries" OFF)
OPTION(USE_MAYAPY "Use maya python" OFF)
OPTION(USE_EIGEN "Use eigen3" OFF)

MESSAGE("CG Thirdparty:")
MESSAGE("BLAS active: ${USE_BLAS}")
MESSAGE("Using Mayapy as python: ${USE_MAYAPY}")
MESSAGE("Eigen active: ${USE_EIGEN}")

IF(NOT LOCAL_LIB_DIR)
    MESSAGE(FATAL "LOCAL_LIB_DIR variable is required")
ENDIF()

# ADD_SUBDIRECTORY(boost-cmake)
# ADD_SUBDIRECTORY(OpenBLAS)

# --general envs
#boost
SET(
    BUILD_TESTING OFF 
    CACHE BOOL "" FORCE
)
SET(
    CMAKE_TESTING_ENABLED OFF 
    CACHE BOOL "" FORCE
)

# SET(
#     BOOST_ROOT
#     ${LOCAL_LIB_DIR}/boost-cmake
#     CACHE STRING "" FORCE
# )
SET(
    BOOST_LIBRARYDIR
    ${LOCAL_LIB_DIR}/boost-cmake/lib
    CACHE STRING "" FORCE
)

# for openblas
# IF(USE_BLAS)
#     SET(
#         CMAKE_INCLUDE_PATH
#         OpenBLAS
#         CACHE STRING "" FORCE
#     )
#     SET(
#         BLAS_LIBDIR
#         ${LOCAL_LIB_DIR}/OpenBLAS/lib
#         CACHE STRING "" FORCE
#     )
#     SET(
#         LAPACK_LIBRARIES
#         ${BLAS_LIBDIR}/openblas.lib
#         CACHE STRING "" FORCE
#     )
#     SET(
#         BLAS_LIBRARIES
#         ${BLAS_LIBDIR}/openblas.lib
#         CACHE STRING "" FORCE
#     )

#     add_library(
#         BLASLib
#         INTERFACE
#     )
#     target_sources(
#         BLASLib
#         INTERFACE
#         ${LOCAL_LIB_DIR}/OpenBLAS/lib/libopenblas.dll
#     )
#     target_link_libraries(
#         BLASLib
#         INTERFACE
#         ${BLAS_LIBRARIES}
#     )
#     # set_target_properties(
#     #     BLASLib
#     #     PROPERTIES
#     #     LINKER_LANGUAGE C
#     # )
# ENDIF()

# --

ADD_SUBDIRECTORY(fmt)
ADD_SUBDIRECTORY(units)

# parallelizer series

SET(
    TF_BUILD_TESTS OFF 
    CACHE BOOL "" FORCE
)
SET(
    TF_BUILD_EXAMPLES OFF 
    CACHE BOOL "" FORCE
)
ADD_SUBDIRECTORY(cpp-taskflow)

SET(
    TRISYCL_OPENCL ON
    CACHE BOOL "" FORCE
)
SET(
    TRISYCL_OPENMP ON
    CACHE BOOL "" FORCE
)
ADD_SUBDIRECTORY(triSYCL)

IF(USE_EIGEN)
    SET(
        EIGEN_TEST_CXX11 ON 
        CACHE BOOL "" FORCE
    )
    SET(
        EIGEN_USE_BLAS ON 
        CACHE BOOL "" FORCE
    )
    SET(
        EIGEN_USE_LAPACKE ON 
        CACHE BOOL "" FORCE
    )
    SET(
        EIGEN_TEST_EXTERNAL_BLAS ON
        CACHE BOOL "" FORCE
    )
    ADD_SUBDIRECTORY(eigen-git-mirror)
ENDIF()

# xtensor series
SET(
    XTENSOR_USE_XSIMD ON
    CACHE BOOL "" FORCE
)
SET(
    XTENSOR_USE_OPENMP ON
    CACHE BOOL "" FORCE
)
SET(
    BUILD_TESTS OFF
    CACHE BOOL "" FORCE
)
SET(
    BUILD_BENCHMARK OFF
    CACHE BOOL "" FORCE
)
SET(
    xtl_DIR
    ${LOCAL_LIB_DIR}/xtl/lib/cmake/xtl
    CACHE STRING "" FORCE
)
SET(
    xsimd_DIR
    ${LOCAL_LIB_DIR}/xsimd/lib/cmake/xsimd
    CACHE STRING "" FORCE
)
SET(
    xtensor_DIR
    ${LOCAL_LIB_DIR}/xtensor/lib/pkgconfig
    CACHE STRING "" FORCE
)
ADD_SUBDIRECTORY(xsimd)
ADD_SUBDIRECTORY(xtl)
ADD_SUBDIRECTORY(xtensor)

IF(USE_BLAS)

    # xtensor
    SET(
        USE_OPENBLAS ON
        CACHE BOOL "" FORCE
    )
    ADD_SUBDIRECTORY(xtensor-blas)
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
ENDIF()


IF(USE_MAYAPY)
    find_package(Maya REQUIRED)
    SET(
        PYTHON_EXECUTABLE "${MAYA_INCLUDE_DIR}/../bin/mayapy.exe" 
        CACHE STRING "" FORCE
    )
ENDIF()

ADD_SUBDIRECTORY(MayaAPIUtils)

SET(PYBIND11_TEST OFF CACHE BOOL "" FORCE)
ADD_SUBDIRECTORY(pybind11)
