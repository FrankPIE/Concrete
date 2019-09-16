cmake_minimum_required(VERSION 3.0.2)

# file download function
function(concrete_file_download uri target_relative_path)
    set(_target ${CONCRETE_PROJECT_SOURCE_DIR}/${target_relative_path})

    if (ARGV2)
        file(${ARGV2} ${_target} _hash_value)

        if (NOT "${_hash_value}" STREQUAL "${ARGV3}")
            file(REMOVE ${_target})
            message(WARNING "File has been broken, removed")
        endif()
    endif()

    if (NOT EXISTS ${_target})
        message(STATUS "DOWNLOADING ${uri}...")

        file(DOWNLOAD ${uri} ${_target} SHOW_PROGRESS STATUS ERR)

        list(GET ERR 0 ERR_CODE)
        
        if (ERR_CODE)
            file(REMOVE ${_target})
            list(GET ERR 1 ERR_MESSAGE)
            message(FATAL_ERROR "Failed to download file ${uri}: ${ERR_MESSAGE}")
        endif ()

        if (ARGV2)
            file(${ARGV2} ${_target} _hash_value)

            if (NOT "${_hash_value}" STREQUAL "${ARGV3}")
                file(REMOVE ${_target})
                message(FATAL_ERROR "Failed to download file ${uri}: file has been broken")
            endif()
        endif()
    endif()
endfunction(concrete_file_download)
