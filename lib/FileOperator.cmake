CMAKE_MINIMUM_REQUIRED(VERSION 3.0.2)

# file download function
# ARGV0 uri
# ARGV1 relative_path
# ARGV2 hash algorithm
# ARGV3 hash hex string 
FUNCTION(CONCRETE_FILE_DOWNLOAD URL RELATIVE_PATH)
    IF (NOT ${CONCRETE_INIT_COMPLETED})
        MESSAGE(FATAL_ERROR "Libaray has not been initialized! please call concrete_init first!")
    ENDIF()

    SET(_TARGET ${CONCRETE_PROJECT_SOURCE_DIR}/${ARGV1})

    # check file
    IF (EXISTS ${_TARGET})
        IF (ARGV2)
            FILE(${ARGV2} ${_TARGET} _HASH_VALUE)

            IF (NOT "${_HASH_VALUE}" STREQUAL "${ARGV3}")
                FILE(REMOVE ${_TARGET})
                MESSAGE(STATUS "${_TARGET} has been broken, removed and redownload")
            ENDIF()
        ENDIF()
    ENDIF()

    # download file
    IF (NOT EXISTS ${_TARGET})
        MESSAGE(STATUS "DOWNLOADING ${ARGV0}...")

        FILE(DOWNLOAD ${ARGV0} ${_TARGET} SHOW_PROGRESS STATUS ERR)

        LIST(GET ERR 0 ERR_CODE)
        
        IF (ERR_CODE)
            FILE(REMOVE ${_TARGET})
            LIST(GET ERR 1 ERR_MESSAGE)
            MESSAGE(FATAL_ERROR "Failed to download file ${ARGV0}: ${ERR_MESSAGE}")
        ENDIF ()

        # check
        IF (ARGV2)
            FILE(${ARGV2} ${_TARGET} _HASH_VALUE)

            IF (NOT "${_HASH_VALUE}" STREQUAL "${ARGV3}")
                FILE(REMOVE ${_TARGET})
                MESSAGE(FATAL_ERROR "Failed to download file ${ARGV0}: file has been broken")
            ENDIF()
        ENDIF()
    ENDIF()
ENDFUNCTION(CONCRETE_FILE_DOWNLOAD)

# make dir function
# ARGV0 relative_path
FUNCTION(CONCRETE_MAKE_DIR RELATIVE_PATH)
    IF (NOT ${CONCRETE_INIT_COMPLETED})
        MESSAGE(FATAL_ERROR "Libaray has not been initialized! please call concrete_init first!")
    ENDIF()

    SET(_TARGET ${CONCRETE_PROJECT_SOURCE_DIR}/${ARGV0})

    IF (EXISTS ${_TARGET})
        MESSAGE(STATUS "${_TARGET} has created")
    ELSE()
        FILE(MAKE_DIRECTORY ${_TARGET})

        IF (NOT EXISTS ${_TARGET})
            MESSAGE(FATAL_ERROR "Create ${_TARGET} failed!")
        ELSE()
            MESSAGE(STATUS "Create ${_TARGET} OK!")
        ENDIF()
    ENDIF()
ENDFUNCTION(CONCRETE_MAKE_DIR)
