# for xtensor series
SET(
    BUILD_TESTS OFF
    CACHE BOOL "" FORCE
)
SET(
    BUILD_BENCHMARK OFF
    CACHE BOOL "" FORCE
)
# We have to doe this because cmake does not locate package
# on it's on on windows
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
    ${LOCAL_LIB_DIR}/xtensor/lib/cmake/xtensor
    CACHE STRING "" FORCE
)

IF(
    CGTP_LOAD_XSIMD OR
    CGTP_LOAD_XTENSOR
)
    ADD_SUBDIRECTORY(xtl)
ENDIF()

IF(CGTP_LOAD_XSIMD)
    ADD_SUBDIRECTORY(xsimd)
ENDIF()

IF(CGTP_LOAD_XTENSOR)
    SET(
        XTENSOR_LOAD_XSIMD ON
        CACHE BOOL "" FORCE
    )
    SET(
        XTENSOR_LOAD_OPENMP ON
        CACHE BOOL "" FORCE
    )
    ADD_SUBDIRECTORY(xtensor)
    IF(CGTP_LOAD_BLAS)
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
ENDIF()