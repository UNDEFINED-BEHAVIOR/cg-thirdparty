CMAKE_MINIMUM_REQUIRED(VERSION 3.14)

# project will be c++17!
SET(CMAKE_CXX_STANDARD 17)
SET(CMAKE_CXX_STANDARD_REQUIRED ON)

IF(NOT LOCAL_LIB_DIR)
    MESSAGE(FATAL " LOCAL_LIB_DIR variable is required")
ENDIF()
# SET(_DETECT_BOST_ROOT $ENV{BOOST_ROOT})
IF(NOT DEFINED ENV{BOOST_ROOT})
    MESSAGE(FATAL " BOOST_ROOT system environment variable is not set")
ENDIF()

OPTION(CGTP_USE_BLAS "Use blas for all applicable libraries (WIP)" OFF)
OPTION(CGTP_USE_FMT_TARGET "Load fmt library as cmake target directly" OFF)
OPTION(CGTP_USE_VEXCL_TARGET "Load VexCL library as cmake target directly" OFF)
OPTION(CGTP_USE_GOOGLETEST_TARGET "Load googletest library as cmake target directly" OFF)
OPTION(CGTP_USE_GOOGLEBENCHMARK_TARGET "Load (google)benchmark library as cmake target directly" OFF)

OPTION(CGTP_LOAD_UNITS "Load units library" OFF)
OPTION(CGTP_LOAD_TRISYCL "Load trisycl(+openmp +opencl) library" OFF)
OPTION(CGTP_LOAD_CPPTASKFLOW "Load cpp-taskflow library" OFF)
OPTION(CGTP_LOAD_EIGEN "Use eigen3" OFF)
OPTION(CGTP_LOAD_PYBIND11 "Load pybind11" OFF)
OPTION(CGTP_LOAD_MAYAAPIUTILS "Load MayaAPIUtils library" OFF)
OPTION(CGTP_LOAD_XSIMD "Load XSIMD library" OFF)
OPTION(CGTP_LOAD_XTENSOR "Load XTENSOR library" OFF)

OPTION(CGTP_LOAD_ALL_TARGETS "Load all library targets" OFF)
OPTION(CGTP_USE_ALL_AS_TARGETS "Load all applicable library as targets directly" OFF)

IF (CGTP_USE_GOOGLEBENCHMARK_TARGET)
    SET(CGTP_USE_GOOGLETEST_TARGET ON CACHE BOOL "" FORCE)
ENDIF()

IF (CGTP_USE_ALL_AS_TARGETS)
    SET(CGTP_USE_FMT_TARGET ON CACHE BOOL "" FORCE)
    SET(CGTP_USE_VEXCL_TARGET ON CACHE BOOL "" FORCE)
    SET(CGTP_USE_GOOGLETEST_TARGET ON CACHE BOOL "" FORCE)
    SET(CGTP_USE_GOOGLEBENCHMARK_TARGET ON CACHE BOOL "" FORCE)

    SET(CGTP_USE_ALL_AS_TARGETS CACHE BOOL "" FORCE)
ENDIF()

# resolve option dependency
IF (CGTP_LOAD_ALL_TARGETS)
    SET(CGTP_LOAD_UNITS ON CACHE BOOL "" FORCE)
    SET(CGTP_LOAD_TRISYCL ON CACHE BOOL "" FORCE)
    SET(CGTP_LOAD_CPPTASKFLOW ON CACHE BOOL "" FORCE)
    SET(CGTP_LOAD_EIGEN ON CACHE BOOL "" FORCE)
    SET(CGTP_LOAD_PYBIND11 ON CACHE BOOL "" FORCE)
    SET(CGTP_LOAD_MAYAAPIUTILS ON CACHE BOOL "" FORCE)
    SET(CGTP_LOAD_XSIMD ON CACHE BOOL "" FORCE)
    SET(CGTP_LOAD_XTENSOR ON CACHE BOOL "" FORCE)

    # untoggle load all
    SET(CGTP_LOAD_ALL_AUTOLOAD OFF CACHE BOOL "" FORCE)
ENDIF()

IF (CGTP_LOAD_XTENSOR)
    SET(CGTP_LOAD_XSIMD ON CACHE BOOL "" FORCE)
ENDIF()

MESSAGE("---CG Thirdparty Options---")
MESSAGE("Use BLAS                         : ${CGTP_USE_BLAS}")
MESSAGE("Eigen                            : ${CGTP_LOAD_EIGEN}")
MESSAGE("units                            : ${CGTP_LOAD_UNITS}")
MESSAGE("TriSYCL                          : ${CGTP_LOAD_TRISYCL}")
MESSAGE("cpp-taskflow                     : ${CGTP_LOAD_CPPTASKFLOW}")
MESSAGE("pybind11                         : ${CGTP_LOAD_PYBIND11}")
MESSAGE("MayaApiUtils                     : ${CGTP_LOAD_MAYAAPIUTILS}")
MESSAGE("XSIMD                            : ${CGTP_LOAD_XSIMD}")
MESSAGE("XTensor                          : ${CGTP_LOAD_XTENSOR}")
MESSAGE("Load directly as target linkable target:")
MESSAGE("fmt                              : ${CGTP_USE_FMT_TARGET}")
MESSAGE("VexCL                            : ${CGTP_USE_VEXCL_TARGET}")
MESSAGE("googletest                       : ${CGTP_USE_GOOGLETEST_TARGET}")
MESSAGE("(google)benchmark                : ${CGTP_USE_GOOGLEBENCHMARK_TARGET}")

# --general envs
# for boost
SET(
    BUILD_TESTING OFF 
    CACHE BOOL "" FORCE
)
SET(
    CMAKE_TESTING_ENABLED OFF 
    CACHE BOOL "" FORCE
)

IF(
    CGTP_USE_VEXCL_TARGET OR
    CGTP_LOAD_TRISYCL
)
    find_package(OpenCL REQUIRED)
ENDIF()

# todo: reenable 
# for openblas
IF(CGTP_USE_BLAS)
    SET(
        CMAKE_INCLUDE_PATH
        OpenBLAS
        CACHE STRING "" FORCE
    )
    SET(
        BLAS_LIBDIR
        lib-blas/lib
        CACHE STRING "" FORCE
    )
    SET(
        LAPACK_LIBRARIES
        lib-blas/openblas.lib
        CACHE STRING "" FORCE
    )
    SET(
        BLAS_LIBRARIES
        lib-blas/openblas.lib
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
ENDIF()

# --

IF(CGTP_LOAD_FMT)
    ADD_SUBDIRECTORY(fmt)
ENDIF()
IF(CGTP_LOAD_UNITS)
    ADD_SUBDIRECTORY(units)
ENDIF()

# parallelizer series
IF(CGTP_LOAD_CPPTASKFLOW)
    SET(
        TF_BUILD_TESTS OFF 
        CACHE BOOL "" FORCE
    )
    SET(
        TF_BUILD_EXAMPLES OFF 
        CACHE BOOL "" FORCE
    )
    ADD_SUBDIRECTORY(cpp-taskflow)
ENDIF()

IF(CGTP_LOAD_TRISYCL)
    SET(
        TRISYCL_OPENCL OFF
        CACHE BOOL "" FORCE
    )
    SET(
        TRISYCL_OPENMP ON
        CACHE BOOL "" FORCE
    )
    ADD_SUBDIRECTORY(triSYCL)
ENDIF()

INCLUDE("CMake_XTensor_Stack.cmake")

IF(CGTP_LOAD_EIGEN)
    SET(
        EIGEN_TEST_CXX11 ON 
        CACHE BOOL "" FORCE
    )
    IF(CGTP_USE_BLAS)
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
    ENDIF()
    ADD_SUBDIRECTORY(eigen-git-mirror)
ENDIF()

IF(CGTP_LOAD_MAYAAPIUTILS)
    ADD_SUBDIRECTORY(MayaAPIUtils)
ENDIF()

IF(CGTP_LOAD_PYBIND11)
    SET(PYBIND11_TEST OFF CACHE BOOL "" FORCE)
    ADD_SUBDIRECTORY(pybind11)
ENDIF()

IF(CGTP_USE_VEXCL_TARGET)
    find_package(OpenCL)
    find_package(Boost)
    add_subdirectory(vexcl)
ENDIF()

IF(CGTP_USE_GOOGLETEST_TARGET)
    add_subdirectory(googletest)
ENDIF()

IF(CGTP_USE_GOOGLEBENCHMARK_TARGET)
    add_subdirectory(benchmark)
ENDIF()