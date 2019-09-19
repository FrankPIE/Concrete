cmake_minimum_required(VERSION 3.0.2)

# project name forward declaration
set(CONCRETE_PROJECT_NAME ${PROJECT_NAME} CACHE INTERNAL "Project name")

set(CONCRETE_INIT_COMPLETED FALSE CACHE BOOL "Init Completed status" FORCE)

# macro to get platform info
macro(_concrete_get_platform_info)
    # host os info
    if(${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Windows")
        SET(CONCRETE_HOST_PLATFORM_NAME "windows" CACHE INTERNAL "Platform OS name")
        SET(CONCRETE_HOST_PLATFORM_WINDOWS TRUE CACHE BOOL "Platform flag" FORCE)
    ELSEIF(${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Linux")
        SET(CONCRETE_HOST_PLATFORM_NAME "linux" CACHE INTERNAL "Platform OS name")
        SET(CONCRETE_HOST_PLATFORM_LINUX TRUE CACHE BOOL "Platform flag" FORCE)
    ELSEIF(${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Darwin")
        SET(CONCRETE_HOST_PLATFORM_NAME "darwin" CACHE INTERNAL "Platform OS name")
        SET(CONCRETE_HOST_PLATFORM_DARWIN TRUE CACHE BOOL "Platform flag" FORCE)
    ENDIF()

    # set platform compiler target x86 or x64 or arm(not supported yet)
    if (CMAKE_CL_64)
        set(CONCRETE_PLATFORM_COMPILER_TARGET x64 CACHE INTERNAL "Platform compiler target")
    else()
        set(CONCRETE_PLATFORM_COMPILER_TARGET x86 CACHE INTERNAL "Platform compiler target")
    endif(CMAKE_CL_64)
endmacro(_concrete_get_platform_info)

# macro to set project propertys
# ARGV0. project root directory, default. ${CMAKE_SOURCE_DIR}
macro(concrete_init)
    _concrete_get_platform_info()

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

    set(CONCRETE_INIT_COMPLETED TRUE)
endmacro()

macro(concrete_set_module_path)
    if (NOT ${CONCRETE_INIT_COMPLETED})
        message(FATAL_ERROR "Libaray has not been initialized! please call concrete_init first!")
    endif()

    foreach(arg IN LISTS ARGN)
        set(_target ${CONCRETE_PROJECT_SOURCE_DIR}/${arg})
        list(APPEND CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH}/${_target})
    endforeach()
endmacro(concrete_set_module_path)

macro(concrete_set_version major minor patch)
    set(CONCRETE_MAJOR_VERSION major CACHE INTERNAL "Software version major")
    set(CONCRETE_MINOR_VERSION minor CACHE INTERNAL "Software version minor")
    set(CONCRETE_PATCH_VERSION patch CACHE INTERNAL "Software version patch")

    set(CONCRETE_VERSION CACHE INTERNAL "Software version")
endmacro(concrete_set_version)
