cmake_minimum_required(VERSION 3.0.2)

# project name forward declaration
set(CONCRETE_PROJECT_NAME ${PROJECT_NAME} CACHE INTERNAL "Project name")

# macro to set project propertys
# ARGV0. project root directory, default. ${CMAKE_SOURCE_DIR}
macro(concrete_init)
    # set platform compiler target x86 or x64 or arm(not supported yet)
    if (CMAKE_CL_64)
        set(CONCRETE_PLATFORM_COMPILER_TARGET x64 CACHE INTERNAL "Platform compiler target")
    else()
        set(CONCRETE_PLATFORM_COMPILER_TARGET x86 CACHE INTERNAL "Platform compiler target")
    endif(CMAKE_CL_64)

    if (NOT "" STREQUAL "${ARGV0}")
        set(CONCRETE_PROJECT_SOURCE_DIR ${ARGV0} CACHE PATH "Project root directory" FORCE)
    else()
        message(STATUS "Project root directory will be set as default")
        set(CONCRETE_PROJECT_SOURCE_DIR ${CMAKE_SOURCE_DIR} CACHE PATH "Project root directory" FORCE)
    endif()

    set(CONCRETE_BINARY_DIR ${CONCRETE_PROJECT_SOURCE_DIR}/${CONCRETE_PLATFORM_COMPILER_TARGET}/bin CACHE PATH "Binary files generate directory" FORCE)
    set(CONCRETE_LIBRARY_DIR ${CONCRETE_PROJECT_SOURCE_DIR}/${CONCRETE_PLATFORM_COMPILER_TARGET}/lib CACHE PATH "Library files generate directory" FORCE)

    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CONCRETE_LIBRARY_DIR})
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CONCRETE_LIBRARY_DIR})
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CONCRETE_BINARY_DIR})    
endmacro()
