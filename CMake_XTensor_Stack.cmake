# for xtensor series
SET(
    BUILD_TESTS OFF
    CACHE BOOL "" FORCE
)
SET(
    BUILD_BENCHMARK OFF
    CACHE BOOL "" FORCE
)

IF(
    CGTP_LOAD_XSIMD OR
    CGTP_LOAD_XTENSOR
)
    FIND_PACKAGE(xtl REQUIRED)
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
    IF(CGTP_USE_BLAS)
        SET(
            USE_OPENBLAS ON
            CACHE BOOL "" FORCE
        )
        # todo confirm this works
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