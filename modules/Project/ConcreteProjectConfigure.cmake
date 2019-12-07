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

INCLUDE( Project/Internal/ConcreteBuildTypeOptions )
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

MACRO(CONCRETE_INTERNAL_METHOD_EXPORT_SCOPE_VARIABLES)
    IF (MSVC)
        SET(MSVC ${MSVC} PARENT_SCOPE)
    ENDIF(MSVC)
ENDMACRO(CONCRETE_INTERNAL_METHOD_EXPORT_SCOPE_VARIABLES)

FUNCTION(CONCRETE_METHOD_PROJECT_INITIALIZATION)     
    SET(options PROJECT_GEN_COMPILER_TARGET_SUBDIRECTORY 
    PROJECT_LANGUAGE_C PROJECT_LANGUAGE_CXX PROJECT_LANGUAGE_CUDA PROJECT_LANGUAGE_OBJC PROJECT_LANGUAGE_OBJCXX PROJECT_LANGUAGE_FORTRAN PROJECT_LANGUAGE_ASM)

    SET(singleValueKey PROJECT_NAME PROJECT_DESCRIPTION PROJECT_HOMEPAGE_URL PROJECT_ROOT_DIR PROJECT_BINARY_OUTPUT_DIR PROJECT_LIBRARY_OUTPUT_DIR)
    
    SET(mulitValueKey PROJECT_VERSION PROJECT_BUILD_TYPES)

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

    # SET(languages)

    # SET(languagesListLenght)
    # LIST(LENGTH languages languagesListLenght)

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
        # CONCRETE_INTERNAL_METHOD_ENABLE_LANGUAGE(CUDA)
        # SET(languages ${languages} CUDA)
    ENDIF(${_CONCRETE_PROJECT_LANGUAGE_CUDA})

    # OBJC
    IF(${_CONCRETE_PROJECT_LANGUAGE_OBJC})
        LIST(APPEND projectParameterList OBJC)
        # CONCRETE_INTERNAL_METHOD_ENABLE_LANGUAGE(OBJC)
        # SET(languages ${languages} OBJC)
    ENDIF(${_CONCRETE_PROJECT_LANGUAGE_OBJC})

    # OBJCXX
    IF(${_CONCRETE_PROJECT_LANGUAGE_OBJCXX})
        LIST(APPEND projectParameterList OBJCXX)

        # CONCRETE_INTERNAL_METHOD_ENABLE_LANGUAGE(OBJCXX)
        # SET(languages ${languages} OBJCXX)
    ENDIF(${_CONCRETE_PROJECT_LANGUAGE_OBJCXX})

    # Fortran
    IF(${_CONCRETE_PROJECT_LANGUAGE_FORTRAN})
        LIST(APPEND projectParameterList Fortran)

        # CONCRETE_INTERNAL_METHOD_ENABLE_LANGUAGE(Fortran)
        # SET(languages ${languages} Fortran)
    ENDIF(${_CONCRETE_PROJECT_LANGUAGE_FORTRAN})

    # ASM
    IF(${_CONCRETE_PROJECT_LANGUAGE_ASM})
        LIST(APPEND projectParameterList ASM)
        # CONCRETE_INTERNAL_METHOD_ENABLE_LANGUAGE(ASM)
        # SET(languages ${languages} ASM)
    ENDIF(${_CONCRETE_PROJECT_LANGUAGE_ASM})

    ####################################################################
    IF(_CONCRETE_PROJECT_VERSION)
        SET(versionListLength)

        LIST(LENGTH _CONCRETE_PROJECT_VERSION versionListLength)

        IF (${versionListLength} GREATER 0)
            SET(major)
            LIST(GET _CONCRETE_PROJECT_VERSION 0 major)

            SET_PROPERTY(CACHE CONCRETE_PROJECT_SOFTWARE_VERSION_MAJOR PROPERTY VALUE ${major})
            # SET(CONCRETE_PROJECT_SOFTWARE_VERSION_MAJOR ${major} CACHE INTERNAL "software version major" FORCE)
            SET_PROPERTY(CACHE CONCRETE_PROJECT_SOFTWARE_VERSION PROPERTY VALUE "${CONCRETE_PROJECT_SOFTWARE_VERSION_MAJOR}")
            # SET(CONCRETE_PROJECT_SOFTWARE_VERSION "${CONCRETE_PROJECT_SOFTWARE_VERSION_MAJOR}" CACHE INTERNAL "software version" FORCE)
        ENDIF(${versionListLength} GREATER 0)

        IF (${versionListLength} GREATER 1)
            SET(minor)
            LIST(GET _CONCRETE_PROJECT_VERSION 1 minor)
            SET_PROPERTY(CACHE CONCRETE_PROJECT_SOFTWARE_VERSION_MINOR PROPERTY VALUE ${minor})
            # SET(CONCRETE_PROJECT_SOFTWARE_VERSION_MINOR ${minor} CACHE INTERNAL "software version minor" FORCE)
            SET_PROPERTY(CACHE CONCRETE_PROJECT_SOFTWARE_VERSION PROPERTY VALUE "${CONCRETE_PROJECT_SOFTWARE_VERSION_MAJOR}.${CONCRETE_PROJECT_SOFTWARE_VERSION_MINOR}")
            # SET(CONCRETE_PROJECT_SOFTWARE_VERSION "${CONCRETE_PROJECT_SOFTWARE_VERSION_MAJOR}.${CONCRETE_PROJECT_SOFTWARE_VERSION_MINOR}" CACHE INTERNAL "software version" FORCE)
        ENDIF(${versionListLength} GREATER 1)

        IF (${versionListLength} GREATER 2)
            SET(patch)
            LIST(GET _CONCRETE_PROJECT_VERSION 2 patch)
            SET_PROPERTY(CACHE CONCRETE_PROJECT_SOFTWARE_VERSION_PATCH PROPERTY VALUE ${patch})
            # SET(CONCRETE_PROJECT_SOFTWARE_VERSION_PATCH ${patch} CACHE INTERNAL "software version patch" FORCE)
            SET_PROPERTY(CACHE CONCRETE_PROJECT_SOFTWARE_VERSION PROPERTY VALUE "${CONCRETE_PROJECT_SOFTWARE_VERSION_MAJOR}.${CONCRETE_PROJECT_SOFTWARE_VERSION_MINOR}.${CONCRETE_PROJECT_SOFTWARE_VERSION_PATCH}")
            # SET(CONCRETE_PROJECT_SOFTWARE_VERSION "${CONCRETE_PROJECT_SOFTWARE_VERSION_MAJOR}.${CONCRETE_PROJECT_SOFTWARE_VERSION_MINOR}.${CONCRETE_PROJECT_SOFTWARE_VERSION_PATCH}" CACHE INTERNAL "software version" FORCE)
        ENDIF(${versionListLength} GREATER 2)

        IF (${versionListLength} GREATER 3)
            SET(tweak)
            LIST(GET _CONCRETE_PROJECT_VERSION 3 tweak)
            SET_PROPERTY(CACHE CONCRETE_PROJECT_SOFTWARE_VERSION_TWEAK PROPERTY VALUE ${tweak})
            # SET(CONCRETE_PROJECT_SOFTWARE_VERSION_TWEAK ${tweak} CACHE INTERNAL "software version tweak" FORCE)
            SET_PROPERTY(CACHE CONCRETE_PROJECT_SOFTWARE_VERSION PROPERTY VALUE "${CONCRETE_PROJECT_SOFTWARE_VERSION_MAJOR}.${CONCRETE_PROJECT_SOFTWARE_VERSION_MINOR}.${CONCRETE_PROJECT_SOFTWARE_VERSION_PATCH}.${CONCRETE_PROJECT_SOFTWARE_VERSION_TWEAK}")
            # SET(CONCRETE_PROJECT_SOFTWARE_VERSION "${CONCRETE_PROJECT_SOFTWARE_VERSION_MAJOR}.${CONCRETE_PROJECT_SOFTWARE_VERSION_MINOR}.${CONCRETE_PROJECT_SOFTWARE_VERSION_PATCH}.${CONCRETE_PROJECT_SOFTWARE_VERSION_TWEAK}" CACHE INTERNAL "software version" FORCE)
        ENDIF(${versionListLength} GREATER 3)

        IF(NOT ${CONCRETE_PROJECT_SOFTWARE_VERSION} STREQUAL "")
            LIST(APPEND projectParameterList VERSION ${CONCRETE_PROJECT_SOFTWARE_VERSION})
        ENDIF(NOT ${CONCRETE_PROJECT_SOFTWARE_VERSION} STREQUAL "")
    ENDIF(_CONCRETE_PROJECT_VERSION)

    IF (_CONCRETE_PROJECT_DESCRIPTION)
        SET_PROPERTY(CACHE CONCRETE_PROJECT_DESCRIPTION PROPERTY VALUE ${_CONCRETE_PROJECT_DESCRIPTION})
        # SET(CONCRETE_PROJECT_DESCRIPTION ${_CONCRETE_PROJECT_DESCRIPTION} CACHE INTERNAL "project description" FORCE)
        LIST(APPEND projectParameterList DESCRIPTION ${CONCRETE_PROJECT_DESCRIPTION})
    ENDIF(_CONCRETE_PROJECT_DESCRIPTION)

    IF (_CONCRETE_PROJECT_HOMEPAGE_URL)
        SET_PROPERTY(CACHE CONCRETE_PROJECT_HOMEPAGE_URL PROPERTY VALUE ${_CONCRETE_PROJECT_HOMEPAGE_URL})
        # SET(CONCRETE_PROJECT_HOMEPAGE_URL ${_CONCRETE_PROJECT_HOMEPAGE_URL} CACHE INTERNAL "project homepage url" FORCE)

        SET(cmakeVersion "$CACHE{CMAKE_CACHE_MAJOR_VERSION}.$CACHE{CMAKE_CACHE_MINOR_VERSION}.$CACHE{CMAKE_CACHE_PATCH_VERSION}")

        IF (${cmakeVersion} VERSION_GREATER_EQUAL "3.12.4")
            LIST(APPEND projectParameterList HOMEPAGE_URL ${CONCRETE_PROJECT_HOMEPAGE_URL})
        ENDIF(${cmakeVersion} VERSION_GREATER_EQUAL "3.12.4")        
    ENDIF(_CONCRETE_PROJECT_HOMEPAGE_URL)

    # project command for languages, version, description, homeurl
    PROJECT(${CONCRETE_PROJECT_NAME} ${projectParameterList})

    # IF ( ${cmakeVersion} VERSION_GREATER_EQUAL "3.12.4")
    #     IF (${languagesListLenght} GREATER 0)
    #         IF (_CONCRETE_PROJECT_VERSION)

    #             PROJECT(${CONCRETE_PROJECT_NAME} 
    #                     LANGUAGES ${languages} 
    #                     VERSION ${CONCRETE_PROJECT_SOFTWARE_VERSION} 
    #                     DESCRIPTION ${CONCRETE_PROJECT_DESCRIPTION} 
    #                     HOMEPAGE_URL ${CONCRETE_PROJECT_HOMEPAGE_URL}
    #                     )
    #         ELSE()

    #             PROJECT(${CONCRETE_PROJECT_NAME}
    #                     LANGUAGES ${languages} 
    #                     DESCRIPTION ${CONCRETE_PROJECT_DESCRIPTION}
    #                     HOMEPAGE_URL ${CONCRETE_PROJECT_HOMEPAGE_URL}
    #                     )
    #         ENDIF(_CONCRETE_PROJECT_VERSION)
    #     ELSE()
    #         IF (_CONCRETE_PROJECT_VERSION)

    #             PROJECT(${CONCRETE_PROJECT_NAME}
    #                     VERSION ${CONCRETE_PROJECT_SOFTWARE_VERSION} 
    #                     DESCRIPTION ${CONCRETE_PROJECT_DESCRIPTION}
    #                     HOMEPAGE_URL ${CONCRETE_PROJECT_HOMEPAGE_URL}
    #                     )
    #         ELSE()

    #             PROJECT(${CONCRETE_PROJECT_NAME} 
    #                     DESCRIPTION ${CONCRETE_PROJECT_DESCRIPTION}
    #                     HOMEPAGE_URL ${CONCRETE_PROJECT_HOMEPAGE_URL}
    #                     )

    #         ENDIF(_CONCRETE_PROJECT_VERSION)
    #     ENDIF(${languagesListLenght} GREATER 0)
    # ELSE()
    #     IF (${languagesListLenght} GREATER 0)
    #         IF (_CONCRETE_PROJECT_VERSION)

    #             PROJECT(${CONCRETE_PROJECT_NAME}
    #                     LANGUAGES ${languages} 
    #                     VERSION ${CONCRETE_PROJECT_SOFTWARE_VERSION} 
    #                     DESCRIPTION ${CONCRETE_PROJECT_DESCRIPTION}
    #                     )

    #         ELSE()

    #             PROJECT(${CONCRETE_PROJECT_NAME} 
    #                     LANGUAGES ${languages} 
    #                     DESCRIPTION ${CONCRETE_PROJECT_DESCRIPTION}
    #                     )

    #         ENDIF(_CONCRETE_PROJECT_VERSION)
    #     ELSE()
    #         IF (_CONCRETE_PROJECT_VERSION)

    #             PROJECT(${CONCRETE_PROJECT_NAME} 
    #                     VERSION ${CONCRETE_PROJECT_SOFTWARE_VERSION} 
    #                     DESCRIPTION ${CONCRETE_PROJECT_DESCRIPTION}
    #                     )
                        
    #         ELSE()

    #             PROJECT(${CONCRETE_PROJECT_NAME} 
    #                     DESCRIPTION ${CONCRETE_PROJECT_DESCRIPTION}
    #                     )

    #         ENDIF(_CONCRETE_PROJECT_VERSION)
    #     ENDIF(${languagesListLenght} GREATER 0)
    # ENDIF(${cmakeVersion} VERSION_GREATER_EQUAL "3.12.4")

    # end set project 

    CONCRETE_METHOD_COLLECT_SYSTEM_INFORMATION()

    IF(_CONCRETE_PROJECT_ROOT_DIR)
        SET_PROPERTY(CACHE CONCRETE_PROJECT_ROOT_DIRECTORY PROPERTY VALUE ${_CONCRETE_PROJECT_ROOT_DIR})
        # SET(CONCRETE_PROJECT_ROOT_DIRECTORY ${_CONCRETE_PROJECT_ROOT_DIR} CACHE PATH "prject root dir default as ${CMAKE_HOME_DIRECTORY}" FORCE)
    ELSE(_CONCRETE_PROJECT_ROOT_DIR)
        SET_PROPERTY(CACHE CONCRETE_PROJECT_ROOT_DIRECTORY PROPERTY VALUE "${${CMAKE_PROJECT_NAME}_BINARY_DIR}")
        # SET(CONCRETE_PROJECT_ROOT_DIRECTORY "${${CMAKE_PROJECT_NAME}_BINARY_DIR}" CACHE PATH "prject root dir default as ${CMAKE_HOME_DIRECTORY}" FORCE)
    ENDIF(_CONCRETE_PROJECT_ROOT_DIR)

    # begin set compiler target
    # set platform compiler target x86 or x64 or arm(not supported yet)
    IF (CMAKE_CL_64)
        SET_PROPERTY(CACHE CONCRETE_PROJECT_COMPILER_TARGET PROPERTY VALUE x64)
        # SET(CONCRETE_PROJECT_COMPILER_TARGET x64 CACHE INTERNAL "project compiler target" FORCE)
    ELSE()
        SET_PROPERTY(CACHE CONCRETE_PROJECT_COMPILER_TARGET PROPERTY VALUE x86)
        # SET(CONCRETE_PROJECT_COMPILER_TARGET x86 CACHE INTERNAL "project compiler target" FORCE)
    ENDIF(CMAKE_CL_64)
    # end set compiler target

    #[[ begin set output dir ]] ########################################
    SET(runtimeOutputDir)

    IF(_CONCRETE_PROJECT_BINARY_OUTPUT_DIR)
        SET(runtimeOutputDir ${_CONCRETE_PROJECT_BINARY_OUTPUT_DIR})
    ELSE(_CONCRETE_PROJECT_BINARY_OUTPUT_DIR)
        SET(runtimeOutputDir ${CONCRETE_PROJECT_ROOT_DIRECTORY}/bin)
    ENDIF(_CONCRETE_PROJECT_BINARY_OUTPUT_DIR)

    IF (${_CONCRETE_PROJECT_GEN_COMPILER_TARGET_SUBDIRECTORY})
        SET(runtimeOutputDir ${runtimeOutputDir}/${CONCRETE_PROJECT_COMPILER_TARGET})
    ENDIF(${_CONCRETE_PROJECT_GEN_COMPILER_TARGET_SUBDIRECTORY})

    SET_PROPERTY(CACHE CONCRETE_PROJECT_BINARY_OUTPUT_DIRECTORY PROPERTY VALUE ${runtimeOutputDir})
    # SET(CONCRETE_PROJECT_BINARY_OUTPUT_DIRECTORY ${runtimeOutputDir} CACHE PATH "global binary files generate directory" FORCE)

    SET(libraryOutputDir)

    IF(_CONCRETE_PROJECT_LIBRARY_OUTPUT_DIR)
        SET(libraryOutputDir ${_CONCRETE_PROJECT_LIBRARY_OUTPUT_DIR})
    ELSE(_CONCRETE_PROJECT_LIBRARY_OUTPUT_DIR)
        SET(libraryOutputDir ${CONCRETE_PROJECT_ROOT_DIRECTORY}/lib)
    ENDIF(_CONCRETE_PROJECT_LIBRARY_OUTPUT_DIR)

    IF (${_CONCRETE_PROJECT_GEN_COMPILER_TARGET_SUBDIRECTORY})
        SET(libraryOutputDir ${libraryOutputDir}/${CONCRETE_PROJECT_COMPILER_TARGET})
    ENDIF(${_CONCRETE_PROJECT_GEN_COMPILER_TARGET_SUBDIRECTORY})

    SET_PROPERTY(CACHE CONCRETE_PROJECT_LIBRARY_OUTPUT_DIRECTORY PROPERTY VALUE ${libraryOutputDir})
    # SET(CONCRETE_PROJECT_LIBRARY_OUTPUT_DIRECTORY ${libraryOutputDir} CACHE PATH "global binary files generate directory" FORCE)

    SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CONCRETE_PROJECT_BINARY_OUTPUT_DIRECTORY}  PARENT_SCOPE)        
    SET(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CONCRETE_PROJECT_LIBRARY_OUTPUT_DIRECTORY} PARENT_SCOPE)
    SET(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CONCRETE_PROJECT_LIBRARY_OUTPUT_DIRECTORY} PARENT_SCOPE)
    #[[ end set output dir ]] ########################################

    # begin set build types
    SET(buildTypes "")
    IF(_CONCRETE_PROJECT_BUILD_TYPES)
        GET_PROPERTY(languages GLOBAL PROPERTY ENABLED_LANGUAGES)

        FOREACH(var ${_CONCRETE_PROJECT_BUILD_TYPES})
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
            
        ENDFOREACH(var ${_CONCRETE_PROJECT_BUILD_TYPES})

        IF(CMAKE_CONFIGURATION_TYPES)
            SET_PROPERTY(CACHE CMAKE_CONFIGURATION_TYPES PROPERTY VALUE "${_CONCRETE_PROJECT_BUILD_TYPES}")
            SET_PROPERTY(CACHE CMAKE_CONFIGURATION_TYPES PROPERTY HELPSTRING "configuration types")            
        ELSE()
            IF(NOT CMAKE_BUILD_TYPE)
                SET(CMAKE_BUILD_TYPE "${buildTypes}" CACHE STRING "" FORCE)
            ENDIF()

            SET_PROPERTY(CACHE CMAKE_BUILD_TYPE PROPERTY HELPSTRING "Choose the type of build")

            SET_PROPERTY(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "${buildTypes}")
        ENDIF()
    ENDIF(_CONCRETE_PROJECT_BUILD_TYPES)
    # end set build types

    CONCRETE_INTERNAL_METHOD_CLEAR_CACHE()

    CONCRETE_INTERNAL_METHOD_EXPORT_SCOPE_VARIABLES()
ENDFUNCTION(CONCRETE_METHOD_PROJECT_INITIALIZATION)

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

FUNCTION(CONCRETE_METHOD_PROJECT_BUILD_CONFIG_SETTING)
    SET(options APPEND WITHOUT_DEBUG USE_UNICODE WARNING_AS_ERROR)
    SET(singleValueKey BUILD_TYPE LANGUAGE_OR_LINKER COPY_FROM_TYPE WARNING_LEVEL DEBUG_INFO_FORMAT)
    SET(mulitValueKey)
    
    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    IF(NOT _CONCRETE_BUILD_TYPE)
        MESSAGE(FATAL_ERROR "Build type must be set")
    ENDIF(NOT _CONCRETE_BUILD_TYPE)

    IF (NOT _CONCRETE_LANGUAGE_OR_LINKER)
        MESSAGE(FATAL_ERROR "language or linker must be set")
    ENDIF(NOT _CONCRETE_LANGUAGE_OR_LINKER)

    SET(flagName)
    IF(${_CONCRETE_BUILD_TYPE} STREQUAL "ALL_BUILD")
        IF (${_CONCRETE_LANGUAGE_OR_LINKER} STREQUAL "Linker")
            SET(flagName CMAKE_EXE_LINKER_FLAGS)
        ELSE()
            SET(language)
            STRING(TOUPPER "${_CONCRETE_LANGUAGE_OR_LINKER}" language)
            SET(flagName CMAKE_${language}_FLAGS)
        ENDIF(${_CONCRETE_LANGUAGE_OR_LINKER} STREQUAL "Linker")
    ELSE()
        SET(buildType)
        STRING(TOUPPER "${_CONCRETE_BUILD_TYPE}" buildType)

        IF (${_CONCRETE_LANGUAGE_OR_LINKER} STREQUAL "Linker")
            SET(flagName CMAKE_EXE_LINKER_FLAGS_${buildType})
        ELSE()
            SET(language)
            STRING(TOUPPER "${_CONCRETE_LANGUAGE_OR_LINKER}" language)
            SET(flagName CMAKE_${language}_FLAGS_${buildType})
        ENDIF(${_CONCRETE_LANGUAGE_OR_LINKER} STREQUAL "Linker")
    ENDIF(${_CONCRETE_BUILD_TYPE} STREQUAL "ALL_BUILD")

    IF(NOT DEFINED ${flagName})
        MESSAGE(FATAL_ERROR "cache variable flag can not find")
    ENDIF(NOT DEFINED ${flagName})

    SET(flagCopyFrom)
    IF(_CONCRETE_COPY_FROM_TYPE)
        IF(${_CONCRETE_COPY_FROM_TYPE} STREQUAL "ALL_BUILD")
            IF (${_CONCRETE_LANGUAGE_OR_LINKER} STREQUAL "Linker")
                SET(flagCopyFrom CMAKE_EXE_LINKER_FLAGS)
            ELSE()
                SET(language)
                STRING(TOUPPER "${_CONCRETE_LANGUAGE_OR_LINKER}" language)
                SET(flagCopyFrom CMAKE_${language}_FLAGS)
            ENDIF(${_CONCRETE_LANGUAGE_OR_LINKER} STREQUAL "Linker")
        ELSE()
            SET(buildType)
            STRING(TOUPPER "${_CONCRETE_COPY_FROM_TYPE}" buildType)

            IF (${_CONCRETE_LANGUAGE_OR_LINKER} STREQUAL "Linker")
                SET(flagCopyFrom CMAKE_EXE_LINKER_FLAGS_${buildType})
            ELSE()
                SET(language)
                STRING(TOUPPER "${_CONCRETE_LANGUAGE_OR_LINKER}" language)
                SET(flagCopyFrom CMAKE_${language}_FLAGS_${buildType})
            ENDIF(${_CONCRETE_LANGUAGE_OR_LINKER} STREQUAL "Linker")
        ENDIF(${_CONCRETE_BUILD_TYPE} STREQUAL "ALL_BUILD")

        IF(NOT DEFINED ${flagCopyFrom})
            MESSAGE(FATAL_ERROR "Copy source not exists")
        ELSE()
            SET_PROPERTY(CACHE ${flagName} PROPERTY VALUE "${${flagCopyFrom}}")

            RETURN()
        ENDIF(NOT DEFINED ${flagCopyFrom})
    ENDIF(_CONCRETE_COPY_FROM_TYPE)

    SET(length)
    SET(flags "")
    IF(${_CONCRETE_APPEND})
        SET(flags "${${flagName}}")
        
        STRING(LENGTH "${flags}" length)
        IF(NOT ${length} EQUAL 0)
            STRING(APPEND flags " ")
        ENDIF(NOT ${length} EQUAL 0)
    ENDIF(${_CONCRETE_APPEND})

    IF(${_CONCRETE_WITHOUT_DEBUG})
        CONCRETE_INTERNAL_METHOD_ADD_NDEBUG_FLAG(flags)
    ENDIF(${_CONCRETE_WITHOUT_DEBUG})

    IF (${_CONCRETE_WARNING_AS_ERROR})
        CONCRETE_INTERNAL_METHOD_ADD_WARNING_AS_ERROR_FLAG(flags)
    ENDIF(${_CONCRETE_WARNING_AS_ERROR})

    IF(${_CONCRETE_USE_UNICODE})
        CONCRETE_INTERNAL_METHOD_ADD_UNICODE_FLAG(flags)
    ENDIF(${_CONCRETE_USE_UNICODE})

    IF(_CONCRETE_WARNING_LEVEL)
        CONCRETE_INTERNAL_METHOD_ADD_WARNING_LEVEL_FLAG(flags ${_CONCRETE_WARNING_LEVEL})
    ENDIF(_CONCRETE_WARNING_LEVEL)

    IF (_CONCRETE_DEBUG_INFO_FORMAT)
        CONCRETE_INTERNAL_METHOD_ADD_DEBUG_INFO_FORMAT(flags ${_CONCRETE_DEBUG_INFO_FORMAT})
    ENDIF(_CONCRETE_DEBUG_INFO_FORMAT)

    STRING(LENGTH "${flags}" length)

    IF(NOT ${length} EQUAL 0)
        # pop last space char
        CONCRETE_METHOD_STRING_POP_LAST(flags 1 flags)

        SET_PROPERTY(CACHE ${flagName} PROPERTY VALUE "${flags}")
    ENDIF(NOT ${length} EQUAL 0)
ENDFUNCTION(CONCRETE_METHOD_PROJECT_BUILD_CONFIG_SETTING)

FUNCTION(CONCRETE_METHOD_PROJECT_GLOBAL_SETTING)
    SET(options USE_FOLDERS)
    SET(singleValueKey)
    SET(mulitValueKey)

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    IF(${_CONCRETE_USE_FOLDERS})
        SET_PROPERTY(GLOBAL PROPERTY USE_FOLDERS ON)
    ENDIF(${_CONCRETE_USE_FOLDERS})

ENDFUNCTION(CONCRETE_METHOD_PROJECT_GLOBAL_SETTING)
