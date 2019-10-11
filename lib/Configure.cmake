CMAKE_MINIMUM_REQUIRED(VERSION 3.0.2)

include(CMakeParseArguments)
# TODO https://www.cnblogs.com/navysummer/p/10251537.html
include(CheckCXXCompilerFlag)

# project name forward declaration
SET(CONCRETE_PROJECT_NAME ${PROJECT_NAME} CACHE INTERNAL "Project name")

SET(CONCRETE_INIT_COMPLETED FALSE CACHE BOOL "Init Completed status" FORCE)

# macro to get platform info
MACRO(_CONCRETE_GET_PLATFORM_INFO)
    # host os info
    IF(${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Windows")
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
ENDMACRO(_CONCRETE_GET_PLATFORM_INFO)

# macro to set project propertys
# ARGV0. project root directory, default. ${CMAKE_SOURCE_DIR}
# ARGV1. concrete relative path
MACRO(CONCRETE_INIT PROJECT_ROOT_PATH CONCRETE_RELATIVE_PATH)
    _CONCRETE_GET_PLATFORM_INFO()

    SET(CONCRETE_PROJECT_SOURCE_DIR ${ARGV0} CACHE PATH "Project root directory" FORCE)

    SET(CONCRETE_PATH ${CONCRETE_PROJECT_SOURCE_DIR}/${CONCRETE_RELATIVE_PATH} CACHE PATH "Concrete path" FORCE)

    SET(CONCRETE_BINARY_DIR ${CONCRETE_PROJECT_SOURCE_DIR}/bin/${CONCRETE_PLATFORM_COMPILER_TARGET} CACHE PATH "Binary files generate directory" FORCE)
    SET(CONCRETE_LIBRARY_DIR ${CONCRETE_PROJECT_SOURCE_DIR}/lib/${CONCRETE_PLATFORM_COMPILER_TARGET} CACHE PATH "Library files generate directory" FORCE)

    SET(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CONCRETE_LIBRARY_DIR})
    SET(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CONCRETE_LIBRARY_DIR})
    SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CONCRETE_BINARY_DIR})    

    SET(CONCRETE_INIT_COMPLETED TRUE)

    SET(CONCRETE_BUILD_PATH ${PROJECT_BINARY_DIR})
ENDMACRO()

MACRO(CONCRETE_SET_VERSION MAJOR MINOR PATCH)
    SET(CONCRETE_MAJOR_VERSION ${MAJOR} CACHE INTERNAL "Software version major")
    SET(CONCRETE_MINOR_VERSION ${MINOR} CACHE INTERNAL "Software version minor")
    SET(CONCRETE_PATCH_VERSION ${PATCH} CACHE INTERNAL "Software version patch")

    SET(CONCRETE_VERSION "${CONCRETE_MAJOR_VERSION}.${CONCRETE_MINOR_VERSION}.${CONCRETE_PATCH_VERSION}" CACHE INTERNAL "Software version")
ENDMACRO(CONCRETE_SET_VERSION)

MACRO(CONCRETE_SET_MODULE_PATH)
    IF (NOT ${CONCRETE_INIT_COMPLETED})
        MESSAGE(FATAL_ERROR "Library has not been initialized! please call concrete_init first!")
    ENDIF()

    FOREACH(ARG IN LISTS ARGN)
        SET(_TARGET ${CONCRETE_PROJECT_SOURCE_DIR}/${ARG})
        LIST(APPEND CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH}/${_TARGET})
    ENDFOREACH()
ENDMACRO(CONCRETE_SET_MODULE_PATH)

MACRO(CONCRETE_USE_FOLDERS)
    IF (NOT ${CONCRETE_INIT_COMPLETED})
        MESSAGE(FATAL_ERROR "Library has not been initialized! please call concrete_init first!")
    ENDIF()

    SET_PROPERTY(GLOBAL PROPERTY USE_FOLDERS ON)

    SET(CONCRETE_USE_FOLDERS TRUE CACHE BOOL "Use folders enable" FORCE)
ENDMACRO(CONCRETE_USE_FOLDERS)

MACRO(CONCRETE_SET_CONFIG_FILE_PROPERTIES  )
    CMAKE_PARSE_ARGUMENTS(
        CONCRETE
        ""
        "MACRO_PREFIX;MAIN_NAME_SPACE"
        ""
        ${ARGN}
    )

    IF(NOT ${CONCRETE_MAIN_NAME_SPACE} STREQUAL "")
        LIST(APPEND CONCRETE_BASE_DEFINITIONS -DCONCRETE_USE_NAME_SPACE)        
    ENDIF()
ENDMACRO(CONCRETE_SET_CONFIG_FILE_PROPERTIES)

