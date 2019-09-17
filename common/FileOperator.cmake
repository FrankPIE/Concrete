cmake_minimum_required(VERSION 3.0.2)

# file download function
# ARGV0 uri
# ARGV1 relative_path
# ARGV2 hash algorithm
# ARGV3 hash hex string 
function(concrete_file_download)
    # params check
    if (NOT ARGV0 OR NOT ARGV1)
        message(FATAL_ERROR "bad call: few params, shoud pass url and relative_path")
    endif()

    set(_target ${CONCRETE_PROJECT_SOURCE_DIR}/${ARGV1})

    # check file
    if (EXISTS ${_target})
        if (ARGV2)
            file(${ARGV2} ${_target} _hash_value)

            if (NOT "${_hash_value}" STREQUAL "${ARGV3}")
                file(REMOVE ${_target})
                message(STATUS "${_target} has been broken, removed and redownload")
            endif()
        endif()
    endif()

    # download file
    if (NOT EXISTS ${_target})
        message(STATUS "DOWNLOADING ${ARGV0}...")

        file(DOWNLOAD ${ARGV0} ${_target} SHOW_PROGRESS STATUS ERR)

        list(GET ERR 0 ERR_CODE)
        
        if (ERR_CODE)
            file(REMOVE ${_target})
            list(GET ERR 1 ERR_MESSAGE)
            message(FATAL_ERROR "Failed to download file ${ARGV0}: ${ERR_MESSAGE}")
        endif ()

        # check
        if (ARGV2)
            file(${ARGV2} ${_target} _hash_value)

            if (NOT "${_hash_value}" STREQUAL "${ARGV3}")
                file(REMOVE ${_target})
                message(FATAL_ERROR "Failed to download file ${ARGV0}: file has been broken")
            endif()
        endif()
    endif()
endfunction(concrete_file_download)
