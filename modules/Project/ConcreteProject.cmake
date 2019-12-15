# MIT License
# 
# Copyright (c) 2019 MadStrawberry
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

INCLUDE_GUARD(GLOBAL)

INCLUDE( CMakeParseArguments )

INCLUDE( Project/Internal/ConcreteProcessProperty )
INCLUDE( Project/Internal/ConcreteCheckLanguage )

FUNCTION(CONCRETE_INTERNAL_METHOD_CLEAR_CACHE)
        # workaround for fix cache value
        LIST(GET CONCRETE_PROJECT_DEFAULT_PARAMETER 0 tempName)
        UNSET(${tempName}_BINARY_DIR CACHE)
        UNSET(${tempName}_SOURCE_DIR CACHE)
        
        IF (CMAKE_CONFIGURATION_TYPES)
            SET(buildTypes ${CMAKE_CONFIGURATION_TYPES})
        ELSE()
            SET(buildTypes ${CMAKE_BUILD_TYPE})
        ENDIF(CMAKE_CONFIGURATION_TYPES)

        FOREACH(var ${buildTypes})
            STRING(TOUPPER "${var}" upperValue)

            UNSET(CMAKE_NONE_FLAGS_${upperValue} CACHE)            
        ENDFOREACH(var ${buildTypes})

        STRING(REPLACE "${tempName}" ${CONCRETE_PROJECT_NAME} value "${CMAKE_INSTALL_PREFIX}")
        SET_PROPERTY(CACHE CMAKE_INSTALL_PREFIX PROPERTY VALUE ${value})    
ENDFUNCTION(CONCRETE_INTERNAL_METHOD_CLEAR_CACHE)

FUNCTION(CONCRETE_INTERNAL_METHOD_CHECK_COMPILER_TARGET)
    # begin set compiler target
    # set platform compiler target x86 or x64 or arm(not supported yet)    
    IF (CMAKE_CL_64)
        SET_PROPERTY(CACHE CONCRETE_PROJECT_COMPILER_TARGET PROPERTY VALUE x64)
    ELSE()
        SET_PROPERTY(CACHE CONCRETE_PROJECT_COMPILER_TARGET PROPERTY VALUE x86)
    ENDIF(CMAKE_CL_64)
    # end set compiler target
ENDFUNCTION(CONCRETE_INTERNAL_METHOD_CHECK_COMPILER_TARGET)

MACRO(CONCRETE_INTERNAL_METHOD_EXPORT_SCOPE_VARIABLES)
    IF (MSVC)
        SET(MSVC ${MSVC} PARENT_SCOPE)
    ENDIF(MSVC)

    SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CONCRETE_PROJECT_BINARY_OUTPUT_DIRECTORY}  PARENT_SCOPE)        
    SET(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CONCRETE_PROJECT_LIBRARY_OUTPUT_DIRECTORY} PARENT_SCOPE)
    SET(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CONCRETE_PROJECT_LIBRARY_OUTPUT_DIRECTORY} PARENT_SCOPE)
ENDMACRO(CONCRETE_INTERNAL_METHOD_EXPORT_SCOPE_VARIABLES)

FUNCTION(CONCRETE_METHOD_PROJECT_CONFIGURE)     
    SET(options 
        PROJECT_COMPILER_TARGET_SUBDIRECTORY 
        PROJECT_LANGUAGE_C PROJECT_LANGUAGE_CXX PROJECT_LANGUAGE_CUDA PROJECT_LANGUAGE_OBJC
        PROJECT_LANGUAGE_OBJCXX PROJECT_LANGUAGE_FORTRAN PROJECT_LANGUAGE_ASM
    )

    SET(singleValueKey 
        PROJECT_NAME PROJECT_DESCRIPTION PROJECT_HOMEPAGE_URL 
        PROJECT_ROOT_DIR PROJECT_BINARY_OUTPUT_DIR PROJECT_LIBRARY_OUTPUT_DIR
    )
    
    SET(mulitValueKey 
        PROJECT_VERSION PROJECT_CONFIGURATION_TYPES
    )

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    # begin set project
    IF(_CONCRETE_PROJECT_NAME)
        SET_PROPERTY(CACHE CONCRETE_PROJECT_NAME PROPERTY VALUE ${_CONCRETE_PROJECT_NAME})
    ELSE()
        MESSAGE(FATAL_ERROR "Project name must be set")
    ENDIF(_CONCRETE_PROJECT_NAME)

    # C
    LIST(APPEND projectParameterList LANGUAGES)
    IF(${_CONCRETE_PROJECT_LANGUAGE_C})
        LIST(APPEND projectParameterList C)
    ENDIF(${_CONCRETE_PROJECT_LANGUAGE_C})

    # CXX
    IF(${_CONCRETE_PROJECT_LANGUAGE_CXX})
        LIST(APPEND projectParameterList CXX)
    ENDIF(${_CONCRETE_PROJECT_LANGUAGE_CXX})

    # CUDA
    IF(${_CONCRETE_PROJECT_LANGUAGE_CUDA})
        LIST(APPEND projectParameterList CUDA)
    ENDIF(${_CONCRETE_PROJECT_LANGUAGE_CUDA})

    # OBJC
    IF(${_CONCRETE_PROJECT_LANGUAGE_OBJC})
        LIST(APPEND projectParameterList OBJC)
    ENDIF(${_CONCRETE_PROJECT_LANGUAGE_OBJC})

    # OBJCXX
    IF(${_CONCRETE_PROJECT_LANGUAGE_OBJCXX})
        LIST(APPEND projectParameterList OBJCXX)
    ENDIF(${_CONCRETE_PROJECT_LANGUAGE_OBJCXX})

    # Fortran
    IF(${_CONCRETE_PROJECT_LANGUAGE_FORTRAN})
        LIST(APPEND projectParameterList Fortran)
    ENDIF(${_CONCRETE_PROJECT_LANGUAGE_FORTRAN})

    # ASM
    IF(${_CONCRETE_PROJECT_LANGUAGE_ASM})
        LIST(APPEND projectParameterList ASM)
    ENDIF(${_CONCRETE_PROJECT_LANGUAGE_ASM})

    ####################################################################
    IF(_CONCRETE_PROJECT_VERSION)
        SET(versionListLength)

        LIST(LENGTH _CONCRETE_PROJECT_VERSION versionListLength)

        IF (${versionListLength} GREATER 0)
            SET(major)
            LIST(GET _CONCRETE_PROJECT_VERSION 0 major)

            SET_PROPERTY(CACHE CONCRETE_PROJECT_SOFTWARE_VERSION_MAJOR PROPERTY VALUE ${major})
            SET_PROPERTY(CACHE CONCRETE_PROJECT_SOFTWARE_VERSION PROPERTY VALUE "${CONCRETE_PROJECT_SOFTWARE_VERSION_MAJOR}")
        ENDIF(${versionListLength} GREATER 0)

        IF (${versionListLength} GREATER 1)
            SET(minor)
            LIST(GET _CONCRETE_PROJECT_VERSION 1 minor)
            SET_PROPERTY(CACHE CONCRETE_PROJECT_SOFTWARE_VERSION_MINOR PROPERTY VALUE ${minor})
            SET_PROPERTY(CACHE CONCRETE_PROJECT_SOFTWARE_VERSION PROPERTY VALUE "${CONCRETE_PROJECT_SOFTWARE_VERSION_MAJOR}.${CONCRETE_PROJECT_SOFTWARE_VERSION_MINOR}")
        ENDIF(${versionListLength} GREATER 1)

        IF (${versionListLength} GREATER 2)
            SET(patch)
            LIST(GET _CONCRETE_PROJECT_VERSION 2 patch)
            SET_PROPERTY(CACHE CONCRETE_PROJECT_SOFTWARE_VERSION_PATCH PROPERTY VALUE ${patch})
            SET_PROPERTY(CACHE CONCRETE_PROJECT_SOFTWARE_VERSION PROPERTY VALUE "${CONCRETE_PROJECT_SOFTWARE_VERSION_MAJOR}.${CONCRETE_PROJECT_SOFTWARE_VERSION_MINOR}.${CONCRETE_PROJECT_SOFTWARE_VERSION_PATCH}")
        ENDIF(${versionListLength} GREATER 2)

        IF (${versionListLength} GREATER 3)
            SET(tweak)
            LIST(GET _CONCRETE_PROJECT_VERSION 3 tweak)
            SET_PROPERTY(CACHE CONCRETE_PROJECT_SOFTWARE_VERSION_TWEAK PROPERTY VALUE ${tweak})
            SET_PROPERTY(CACHE CONCRETE_PROJECT_SOFTWARE_VERSION PROPERTY VALUE "${CONCRETE_PROJECT_SOFTWARE_VERSION_MAJOR}.${CONCRETE_PROJECT_SOFTWARE_VERSION_MINOR}.${CONCRETE_PROJECT_SOFTWARE_VERSION_PATCH}.${CONCRETE_PROJECT_SOFTWARE_VERSION_TWEAK}")
        ENDIF(${versionListLength} GREATER 3)

        IF(NOT ${CONCRETE_PROJECT_SOFTWARE_VERSION} STREQUAL "")
            LIST(APPEND projectParameterList VERSION ${CONCRETE_PROJECT_SOFTWARE_VERSION})
        ENDIF(NOT ${CONCRETE_PROJECT_SOFTWARE_VERSION} STREQUAL "")
    ENDIF(_CONCRETE_PROJECT_VERSION)

    IF (_CONCRETE_PROJECT_DESCRIPTION)
        SET_PROPERTY(CACHE CONCRETE_PROJECT_DESCRIPTION PROPERTY VALUE ${_CONCRETE_PROJECT_DESCRIPTION})
        LIST(APPEND projectParameterList DESCRIPTION ${CONCRETE_PROJECT_DESCRIPTION})
    ENDIF(_CONCRETE_PROJECT_DESCRIPTION)

    IF (_CONCRETE_PROJECT_HOMEPAGE_URL)
        SET_PROPERTY(CACHE CONCRETE_PROJECT_HOMEPAGE_URL PROPERTY VALUE ${_CONCRETE_PROJECT_HOMEPAGE_URL})

        SET(cmakeVersion "$CACHE{CMAKE_CACHE_MAJOR_VERSION}.$CACHE{CMAKE_CACHE_MINOR_VERSION}.$CACHE{CMAKE_CACHE_PATCH_VERSION}")

        IF (${cmakeVersion} VERSION_GREATER_EQUAL "3.12.4")
            LIST(APPEND projectParameterList HOMEPAGE_URL ${CONCRETE_PROJECT_HOMEPAGE_URL})
        ENDIF(${cmakeVersion} VERSION_GREATER_EQUAL "3.12.4")        
    ENDIF(_CONCRETE_PROJECT_HOMEPAGE_URL)

    # project command for languages, version, description, homeurl
    PROJECT(${CONCRETE_PROJECT_NAME} ${projectParameterList})
    # end set project 

    # collect system information
    CONCRETE_METHOD_COLLECT_SYSTEM_INFORMATION()

    # check compiler target
    CONCRETE_INTERNAL_METHOD_CHECK_COMPILER_TARGET()

    IF(_CONCRETE_PROJECT_ROOT_DIR)
        SET_PROPERTY(CACHE CONCRETE_PROJECT_ROOT_DIRECTORY PROPERTY VALUE ${_CONCRETE_PROJECT_ROOT_DIR})
    ELSE(_CONCRETE_PROJECT_ROOT_DIR)
        SET_PROPERTY(CACHE CONCRETE_PROJECT_ROOT_DIRECTORY PROPERTY VALUE ${CMAKE_HOME_DIRECTORY})
    ENDIF(_CONCRETE_PROJECT_ROOT_DIR)

    #[[ begin set output dir ]] ########################################
    SET(runtimeOutputDir)

    IF(_CONCRETE_PROJECT_BINARY_OUTPUT_DIR)
        SET(runtimeOutputDir ${_CONCRETE_PROJECT_BINARY_OUTPUT_DIR})
    ELSE(_CONCRETE_PROJECT_BINARY_OUTPUT_DIR)
        SET(runtimeOutputDir ${CONCRETE_PROJECT_ROOT_DIRECTORY}/bin)
    ENDIF(_CONCRETE_PROJECT_BINARY_OUTPUT_DIR)

    IF (${_CONCRETE_PROJECT_COMPILER_TARGET_SUBDIRECTORY})
        SET(runtimeOutputDir ${runtimeOutputDir}/${CONCRETE_PROJECT_COMPILER_TARGET})
    ENDIF(${_CONCRETE_PROJECT_COMPILER_TARGET_SUBDIRECTORY})

    SET_PROPERTY(CACHE CONCRETE_PROJECT_BINARY_OUTPUT_DIRECTORY PROPERTY VALUE ${runtimeOutputDir})

    SET(libraryOutputDir)

    IF(_CONCRETE_PROJECT_LIBRARY_OUTPUT_DIR)
        SET(libraryOutputDir ${_CONCRETE_PROJECT_LIBRARY_OUTPUT_DIR})
    ELSE(_CONCRETE_PROJECT_LIBRARY_OUTPUT_DIR)
        SET(libraryOutputDir ${CONCRETE_PROJECT_ROOT_DIRECTORY}/lib)
    ENDIF(_CONCRETE_PROJECT_LIBRARY_OUTPUT_DIR)

    IF (${_CONCRETE_PROJECT_COMPILER_TARGET_SUBDIRECTORY})
        SET(libraryOutputDir ${libraryOutputDir}/${CONCRETE_PROJECT_COMPILER_TARGET})
    ENDIF(${_CONCRETE_PROJECT_COMPILER_TARGET_SUBDIRECTORY})

    SET_PROPERTY(CACHE CONCRETE_PROJECT_LIBRARY_OUTPUT_DIRECTORY PROPERTY VALUE ${libraryOutputDir})
    #[[ end set output dir ]] ########################################

    # begin set build types
    SET(buildTypes "")
    IF(_CONCRETE_PROJECT_CONFIGURATION_TYPES)
        GET_PROPERTY(languages GLOBAL PROPERTY ENABLED_LANGUAGES)

        FOREACH(var ${_CONCRETE_PROJECT_CONFIGURATION_TYPES})
            STRING(TOUPPER "${var}" upperValue)

            IF(NOT CMAKE_EXE_LINKER_FLAGS_${upperValue})
                SET(CMAKE_EXE_LINKER_FLAGS_${upperValue} CACHE STRING "Flags used by the linker during ${upperValue} builds." FORCE)
            ENDIF(NOT CMAKE_EXE_LINKER_FLAGS_${upperValue})
            
            FOREACH(lang ${languages})
                SET(langUpperValue)                
                STRING(TOUPPER "${lang}" langUpperValue)

                IF(NOT CMAKE_${langUpperValue}_FLAGS_${upperValue})
                    SET(CMAKE_${langUpperValue}_FLAGS_${upperValue} CACHE STRING "Flags used by the ${langUpperValue} compiler during ${upperValue} builds." FORCE)
                ENDIF(NOT CMAKE_${langUpperValue}_FLAGS_${upperValue})

            ENDFOREACH(lang ${languages})            
        ENDFOREACH(var ${_CONCRETE_PROJECT_CONFIGURATION_TYPES})

        IF(CMAKE_CONFIGURATION_TYPES)
            SET_PROPERTY(CACHE CMAKE_CONFIGURATION_TYPES PROPERTY VALUE "${_CONCRETE_PROJECT_CONFIGURATION_TYPES}")
            SET_PROPERTY(CACHE CMAKE_CONFIGURATION_TYPES PROPERTY HELPSTRING "configuration types")            
        ELSE()
            IF(NOT CMAKE_BUILD_TYPE)
                SET(CMAKE_BUILD_TYPE "${buildTypes}" CACHE STRING "" FORCE)
            ENDIF()

            SET_PROPERTY(CACHE CMAKE_BUILD_TYPE PROPERTY HELPSTRING "Choose the type of build")

            SET_PROPERTY(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "${buildTypes}")
        ENDIF(CMAKE_CONFIGURATION_TYPES)
    ENDIF(_CONCRETE_PROJECT_CONFIGURATION_TYPES)
    # end set build types

    #[[
        add a interface target named of ConcreteInterface
        for as properties interface for other target
    #]]
    CONCRETE_METHOD_ADD_TARGET(
        TARGET_NAME 
            ConcreteInterface
        TYPE        
            "Interface"
        CREATE_ONLY
    )
    
    CONCRETE_INTERNAL_METHOD_CLEAR_CACHE()

    CONCRETE_INTERNAL_METHOD_EXPORT_SCOPE_VARIABLES()
ENDFUNCTION(CONCRETE_METHOD_PROJECT_CONFIGURE)

FUNCTION(CONCRETE_METHOD_GLOBAL_TARGET_CONFIGURE)
    SET(options)
    SET(singleValueKey)
    SET(mulitValueKey PROPERTIES LINK_LIBRARIES LINK_OPTIONS INCLUDE_DIRECTORIES COMPILE_OPTIONS COMPILE_DEFINITIONS SOURCES)

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    SET(targetName ConcreteInterface)

    # TODO::参数检查

    IF(_CONCRETE_PROPERTIES)
        SET_TARGET_PROPERTIES(${targetName} PROPERTIES ${_CONCRETE_PROPERTIES})
    ENDIF(_CONCRETE_PROPERTIES)

    IF(_CONCRETE_LINK_OPTIONS)
        TARGET_LINK_OPTIONS(${targetName} INTERFACE ${_CONCRETE_LINK_OPTIONS})
    ENDIF(_CONCRETE_LINK_OPTIONS)

    IF(_CONCRETE_LINK_LIBRARIES)
        TARGET_LINK_LIBRARIES(${targetName} INTERFACE ${_CONCRETE_LINK_LIBRARIES})
    ENDIF(_CONCRETE_LINK_LIBRARIES)

    IF(_CONCRETE_INCLUDE_DIRECTORIES)
        TARGET_INCLUDE_DIRECTORIES(${targetName} INTERFACE ${_CONCRETE_INCLUDE_DIRECTORIES})
    ENDIF(_CONCRETE_INCLUDE_DIRECTORIES)

    IF(_CONCRETE_COMPILE_OPTIONS)
        TARGET_COMPILE_OPTIONS(${targetName} INTERFACE ${_CONCRETE_COMPILE_OPTIONS})
    ENDIF(_CONCRETE_COMPILE_OPTIONS)

    IF(_CONCRETE_COMPILE_DEFINITIONS)
        TARGET_COMPILE_DEFINITIONS(${targetName} INTERFACE ${_CONCRETE_COMPILE_DEFINITIONS})
    ENDIF(_CONCRETE_COMPILE_DEFINITIONS)

    IF(_CONCRETE_SOURCES)
        TARGET_SOURCES(${targetName} INTERFACE ${_CONCRETE_SOURCES})
    ENDIF(_CONCRETE_SOURCES)

    cotire(${targetName})
ENDFUNCTION(CONCRETE_METHOD_GLOBAL_TARGET_CONFIGURE)

FUNCTION(CONCRETE_METHOD_PROJECT_CONFIGURE_FILE)
    SET(options COPY_ONLY)
    SET(singleValueKey SOURCE_FILE_PATH DEST_FILE_PATH NEWLINE_STYLE)
    SET(mulitValueKey COPY_OPTIONS)

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    IF(NOT _CONCRETE_SOURCE_FILE_PATH)
        MESSAGE(FATAL_ERROR "Must set source file path")
    ELSE()
        IF(NOT EXISTS ${_CONCRETE_SOURCE_FILE_PATH})
            MESSAGE(FATAL_ERROR "Source file not exists")
        ENDIF(NOT EXISTS ${_CONCRETE_SOURCE_FILE_PATH})
    ENDIF(_CONCRETE_SOURCE_FILE_PATH)

    IF(NOT _CONCRETE_DEST_FILE_PATH)
        MESSAGE(FATAL_ERROR "Must set dest file path")
    ENDIF(NOT _CONCRETE_DEST_FILE_PATH)

    IF(${_CONCRETE_COPY_ONLY})
        IF(_CONCRETE_NEWLINE_STYLE)
            MESSAGE(WARNING "Newline style option may not be used with CopyOnly")
        ENDIF(_CONCRETE_NEWLINE_STYLE)

        CONFIGURE_FILE(
            ${SOURCE_FILE_PATH}
            ${DEST_FILE_PATH}
            COPYONLY
        )
        RETURN()
    ENDIF(${_CONCRETE_COPY_ONLY})

    SET(newlineStyle)
    IF (_CONCRETE_NEWLINE_STYLE)
        IF (${_CONCRETE_NEWLINE_STYLE} STREQUAL "UNIX")
            SET(newlineStyle "UNIX") 
        ENDIF(${_CONCRETE_NEWLINE_STYLE} STREQUAL "UNIX")

        IF (${_CONCRETE_NEWLINE_STYLE} STREQUAL "DOS")
            SET(newlineStyle "DOS") 
        ENDIF(${_CONCRETE_NEWLINE_STYLE} STREQUAL "DOS")        

        IF (${_CONCRETE_NEWLINE_STYLE} STREQUAL "WIN32")
            SET(newlineStyle "WIN32") 
        ENDIF(${_CONCRETE_NEWLINE_STYLE} STREQUAL "WIN32")        

        IF (${_CONCRETE_NEWLINE_STYLE} STREQUAL "LF")
            SET(newlineStyle "LF") 
        ENDIF(${_CONCRETE_NEWLINE_STYLE} STREQUAL "LF")        

        IF (${_CONCRETE_NEWLINE_STYLE} STREQUAL "CRLF")
            SET(newlineStyle "CRLF") 
        ENDIF(${_CONCRETE_NEWLINE_STYLE} STREQUAL "CRLF")        
    ENDIF(_CONCRETE_NEWLINE_STYLE)

    set(copyOptions)
    IF (_CONCRETE_COPY_OPTIONS)
        FOREACH(var ${_CONCRETE_COPY_OPTIONS})
            IF(${var} STREQUAL "EscapeQuotes")
                SET(copyOptions ${copyOptions} ESCAPE_QUOTES)
            ENDIF(${var} STREQUAL "EscapeQuotes")

            IF(${var} STREQUAL "@Only")
                SET(copyOptions ${copyOptions} @ONLY)
            ENDIF(${var} STREQUAL "@Only")
        ENDFOREACH(var ${_CONCRETE_COPY_OPTIONS})            
    ENDIF(_CONCRETE_COPY_OPTIONS)

    CONFIGURE_FILE(
        ${SOURCE_FILE_PATH}
        ${DEST_FILE_PATH}
        ${copyOptions}
        NEWLINE_STYLE ${newlineStyle}
    )
ENDFUNCTION(CONCRETE_METHOD_PROJECT_CONFIGURE_FILE)

# FUNCTION(CONCRETE_METHOD_SET_GLOBAL_COMPILE_OPTIONS_AND_DEFINITIONS)
    # SET(options APPEND WITHOUT_DEBUG USE_UNICODE WARNING_AS_ERROR)
    # SET(singleValueKey BUILD_TYPE LANGUAGE_OR_LINKER COPY_FROM_TYPE WARNING_LEVEL DEBUG_INFO_FORMAT)
    # SET(mulitValueKey)
    
    # CMAKE_PARSE_ARGUMENTS(
    #     _CONCRETE
    #     "${options}"
    #     "${singleValueKey}"
    #     "${mulitValueKey}"
    #     ${ARGN}
    # )

#     IF(NOT _CONCRETE_BUILD_TYPE)
#         MESSAGE(FATAL_ERROR "Build type must be set")
#     ENDIF(NOT _CONCRETE_BUILD_TYPE)

#     IF (NOT _CONCRETE_LANGUAGE_OR_LINKER)
#         MESSAGE(FATAL_ERROR "language or linker must be set")
#     ENDIF(NOT _CONCRETE_LANGUAGE_OR_LINKER)

#     SET(flagName)
#     IF(${_CONCRETE_BUILD_TYPE} STREQUAL "ALL_BUILD")
#         IF (${_CONCRETE_LANGUAGE_OR_LINKER} STREQUAL "Linker")
#             SET(flagName CMAKE_EXE_LINKER_FLAGS)
#         ELSE()
#             SET(language)
#             STRING(TOUPPER "${_CONCRETE_LANGUAGE_OR_LINKER}" language)
#             SET(flagName CMAKE_${language}_FLAGS)
#         ENDIF(${_CONCRETE_LANGUAGE_OR_LINKER} STREQUAL "Linker")
#     ELSE()
#         SET(buildType)
#         STRING(TOUPPER "${_CONCRETE_BUILD_TYPE}" buildType)

#         IF (${_CONCRETE_LANGUAGE_OR_LINKER} STREQUAL "Linker")
#             SET(flagName CMAKE_EXE_LINKER_FLAGS_${buildType})
#         ELSE()
#             SET(language)
#             STRING(TOUPPER "${_CONCRETE_LANGUAGE_OR_LINKER}" language)
#             SET(flagName CMAKE_${language}_FLAGS_${buildType})
#         ENDIF(${_CONCRETE_LANGUAGE_OR_LINKER} STREQUAL "Linker")
#     ENDIF(${_CONCRETE_BUILD_TYPE} STREQUAL "ALL_BUILD")

#     IF(NOT DEFINED ${flagName})
#         MESSAGE(FATAL_ERROR "cache variable flag can not find")
#     ENDIF(NOT DEFINED ${flagName})

#     SET(flagCopyFrom)
#     IF(_CONCRETE_COPY_FROM_TYPE)
#         IF(${_CONCRETE_COPY_FROM_TYPE} STREQUAL "ALL_BUILD")
#             IF (${_CONCRETE_LANGUAGE_OR_LINKER} STREQUAL "Linker")
#                 SET(flagCopyFrom CMAKE_EXE_LINKER_FLAGS)
#             ELSE()
#                 SET(language)
#                 STRING(TOUPPER "${_CONCRETE_LANGUAGE_OR_LINKER}" language)
#                 SET(flagCopyFrom CMAKE_${language}_FLAGS)
#             ENDIF(${_CONCRETE_LANGUAGE_OR_LINKER} STREQUAL "Linker")
#         ELSE()
#             SET(buildType)
#             STRING(TOUPPER "${_CONCRETE_COPY_FROM_TYPE}" buildType)

#             IF (${_CONCRETE_LANGUAGE_OR_LINKER} STREQUAL "Linker")
#                 SET(flagCopyFrom CMAKE_EXE_LINKER_FLAGS_${buildType})
#             ELSE()
#                 SET(language)
#                 STRING(TOUPPER "${_CONCRETE_LANGUAGE_OR_LINKER}" language)
#                 SET(flagCopyFrom CMAKE_${language}_FLAGS_${buildType})
#             ENDIF(${_CONCRETE_LANGUAGE_OR_LINKER} STREQUAL "Linker")
#         ENDIF(${_CONCRETE_BUILD_TYPE} STREQUAL "ALL_BUILD")

#         IF(NOT DEFINED ${flagCopyFrom})
#             MESSAGE(FATAL_ERROR "Copy source not exists")
#         ELSE()
#             SET_PROPERTY(CACHE ${flagName} PROPERTY VALUE "${${flagCopyFrom}}")

#             RETURN()
#         ENDIF(NOT DEFINED ${flagCopyFrom})
#     ENDIF(_CONCRETE_COPY_FROM_TYPE)

#     SET(length)
#     SET(flags "")
#     IF(${_CONCRETE_APPEND})
#         SET(flags "${${flagName}}")
        
#         STRING(LENGTH "${flags}" length)
#         IF(NOT ${length} EQUAL 0)
#             STRING(APPEND flags " ")
#         ENDIF(NOT ${length} EQUAL 0)
#     ENDIF(${_CONCRETE_APPEND})

#     IF(${_CONCRETE_WITHOUT_DEBUG})
#         CONCRETE_INTERNAL_METHOD_ADD_NDEBUG_FLAG(flags)
#     ENDIF(${_CONCRETE_WITHOUT_DEBUG})

#     IF (${_CONCRETE_WARNING_AS_ERROR})
#         CONCRETE_INTERNAL_METHOD_ADD_WARNING_AS_ERROR_FLAG(flags)
#     ENDIF(${_CONCRETE_WARNING_AS_ERROR})

#     IF(${_CONCRETE_USE_UNICODE})
#         CONCRETE_INTERNAL_METHOD_ADD_UNICODE_FLAG(flags)
#     ENDIF(${_CONCRETE_USE_UNICODE})

#     IF(_CONCRETE_WARNING_LEVEL)
#         CONCRETE_INTERNAL_METHOD_ADD_WARNING_LEVEL_FLAG(flags ${_CONCRETE_WARNING_LEVEL})
#     ENDIF(_CONCRETE_WARNING_LEVEL)

#     IF (_CONCRETE_DEBUG_INFO_FORMAT)
#         CONCRETE_INTERNAL_METHOD_ADD_DEBUG_INFO_FORMAT(flags ${_CONCRETE_DEBUG_INFO_FORMAT})
#     ENDIF(_CONCRETE_DEBUG_INFO_FORMAT)

#     STRING(LENGTH "${flags}" length)

#     IF(NOT ${length} EQUAL 0)
#         # pop last space char
#         CONCRETE_METHOD_STRING_POP_LAST(flags 1 flags)

#         SET_PROPERTY(CACHE ${flagName} PROPERTY VALUE "${flags}")
#     ENDIF(NOT ${length} EQUAL 0)
# ENDFUNCTION(CONCRETE_METHOD_SET_GLOBAL_COMPILE_OPTIONS_AND_DEFINITIONS)

FUNCTION(CONCRETE_METHOD_SET_GLOBAL_PROPERTIES)
    SET(options)
    SET(singleValueKey)
    SET(mulitValueKey PROPERTIES)

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    IF (_CONCRETE_PROPERTIES)
        SET(index 0)
        LIST(LENGTH _CONCRETE_PROPERTIES length)

        WHILE(${index} LESS ${length})
            LIST(GET _CONCRETE_PROPERTIES ${index} key)

            MATH(EXPR indexIncrement "${index} + 1")

            LIST(GET _CONCRETE_PROPERTIES ${indexIncrement} value)

            SET_PROPERTY(GLOBAL PROPERTY ${key} ${value})

            MATH(EXPR index "${index} + 2")
        ENDWHILE(${index} LESS ${length})
    ENDIF(_CONCRETE_PROPERTIES)
ENDFUNCTION(CONCRETE_METHOD_SET_GLOBAL_PROPERTIES)

FUNCTION(CONCRETE_METHOD_SET_VS_STARTUP_PROJECT TARGET)
    SET_PROPERTY(DIRECTORY ${CMAKE_HOME_DIRECTORY} PROPERTY VS_STARTUP_PROJECT ${TARGET})
ENDFUNCTION(CONCRETE_METHOD_SET_VS_STARTUP_PROJECT)