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

MACRO(CONCRETE_METHOD_PROJECT_INITIALIZATION)     
    SET(options PROJECT_GEN_COMPILER_TARGET_SUBDIRECTORY PROJECT_LANGUAGE_C PROJECT_LANGUAGE_CXX PROJECT_LANGUAGE_CUDA PROJECT_LANGUAGE_OBJC PROJECT_LANGUAGE_OBJCXX PROJECT_LANGUAGE_FORTRAN PROJECT_LANGUAGE_ASM)

    SET(singleValueKey PROJECT_NAME PROJECT_DESCRIPTION PROJECT_HOMEPAGE_URL PROJECT_ROOT_DIR PROJECT_BINARY_OUTPUT_DIR PROJECT_LIBRARY_OUTPUT_DIR)
    
    SET(mulitValueKey PROJECT_VERSION PROJECT_BUILD_TYPES)

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    UNSET(options)
    UNSET(singleValueKey)
    UNSET(mulitValueKey)

    # begin set project
    IF(_CONCRETE_PROJECT_NAME)
        SET(CONCRETE_PROJECT_NAME ${_CONCRETE_PROJECT_NAME} CACHE INTERNAL "project name" FORCE)
    ELSE()
        MESSAGE(FATAL_ERROR "Project name must be set")
    ENDIF(_CONCRETE_PROJECT_NAME)

    SET(languages)

    # C
    IF(${_CONCRETE_PROJECT_LANGUAGE_C})
        SET(languages ${languages} C)
    ENDIF(${_CONCRETE_PROJECT_LANGUAGE_C})

    # CXX
    IF(${_CONCRETE_PROJECT_LANGUAGE_CXX})
        SET(languages ${languages} CXX)
    ENDIF(${_CONCRETE_PROJECT_LANGUAGE_CXX})

    # CUDA
    IF(${_CONCRETE_PROJECT_LANGUAGE_CUDA})
        SET(languages ${languages} CUDA)
    ENDIF(${_CONCRETE_PROJECT_LANGUAGE_CUDA})

    # OBJC
    IF(${_CONCRETE_PROJECT_LANGUAGE_OBJC})
        SET(languages ${languages} OBJC)
    ENDIF(${_CONCRETE_PROJECT_LANGUAGE_OBJC})

    # OBJCXX
    IF(${_CONCRETE_PROJECT_LANGUAGE_OBJCXX})
        SET(languages ${languages} OBJCXX)
    ENDIF(${_CONCRETE_PROJECT_LANGUAGE_OBJCXX})

    # Fortran
    IF(${_CONCRETE_PROJECT_LANGUAGE_FORTRAN})
        SET(languages ${languages} Fortran)
    ENDIF(${_CONCRETE_PROJECT_LANGUAGE_FORTRAN})

    # ASM
    IF(${_CONCRETE_PROJECT_LANGUAGE_ASM})
        SET(languages ${languages} ASM)
    ENDIF(${_CONCRETE_PROJECT_LANGUAGE_ASM})

    SET(languagesListLenght)
    LIST(LENGTH languages languagesListLenght)

    ####################################################################
    IF(_CONCRETE_PROJECT_VERSION)
        SET(versionListLength)

        LIST(LENGTH _CONCRETE_PROJECT_VERSION versionListLength)

        IF (${versionListLength} GREATER 0)
            SET(major)
            LIST(GET _CONCRETE_PROJECT_VERSION 0 major)
            SET(CONCRETE_PROJECT_SOFTWARE_VERSION_MAJOR ${major} CACHE INTERNAL "software version major" FORCE)
            UNSET(major)
            SET(CONCRETE_PROJECT_SOFTWARE_VERSION "${CONCRETE_PROJECT_SOFTWARE_VERSION_MAJOR}" CACHE INTERNAL "software version" FORCE)
        ENDIF(${versionListLength} GREATER 0)

        IF (${versionListLength} GREATER 1)
            SET(minor)
            LIST(GET _CONCRETE_PROJECT_VERSION 1 minor)
            SET(CONCRETE_PROJECT_SOFTWARE_VERSION_MINOR ${minor} CACHE INTERNAL "software version minor" FORCE)
            UNSET(minor)
            SET(CONCRETE_PROJECT_SOFTWARE_VERSION "${CONCRETE_PROJECT_SOFTWARE_VERSION_MAJOR}.${CONCRETE_PROJECT_SOFTWARE_VERSION_MINOR}" CACHE INTERNAL "software version" FORCE)
        ENDIF(${versionListLength} GREATER 1)

        IF (${versionListLength} GREATER 2)
            SET(patch)
            LIST(GET _CONCRETE_PROJECT_VERSION 2 patch)
            SET(CONCRETE_PROJECT_SOFTWARE_VERSION_PATCH ${patch} CACHE INTERNAL "software version patch" FORCE)
            UNSET(patch)
            SET(CONCRETE_PROJECT_SOFTWARE_VERSION "${CONCRETE_PROJECT_SOFTWARE_VERSION_MAJOR}.${CONCRETE_PROJECT_SOFTWARE_VERSION_MINOR}.${CONCRETE_PROJECT_SOFTWARE_VERSION_PATCH}" CACHE INTERNAL "software version" FORCE)
        ENDIF(${versionListLength} GREATER 2)

        IF (${versionListLength} GREATER 3)
            SET(tweak)
            LIST(GET _CONCRETE_PROJECT_VERSION 3 tweak)
            SET(CONCRETE_PROJECT_SOFTWARE_VERSION_TWEAK ${tweak} CACHE INTERNAL "software version tweak" FORCE)
            UNSET(tweak)
            SET(CONCRETE_PROJECT_SOFTWARE_VERSION "${CONCRETE_PROJECT_SOFTWARE_VERSION_MAJOR}.${CONCRETE_PROJECT_SOFTWARE_VERSION_MINOR}.${CONCRETE_PROJECT_SOFTWARE_VERSION_PATCH}.${CONCRETE_PROJECT_SOFTWARE_VERSION_TWEAK}" CACHE INTERNAL "software version" FORCE)
        ENDIF(${versionListLength} GREATER 3)

        UNSET(versionListLength)
    ENDIF(_CONCRETE_PROJECT_VERSION)

    IF (_CONCRETE_PROJECT_DESCRIPTION)
        SET(CONCRETE_PROJECT_DESCRIPTION ${_CONCRETE_PROJECT_DESCRIPTION} CACHE INTERNAL "project description" FORCE)
    ENDIF(_CONCRETE_PROJECT_DESCRIPTION)

    IF (_CONCRETE_PROJECT_HOMEPAGE_URL)
        SET(CONCRETE_PROJECT_HOMEPAGE_URL ${_CONCRETE_PROJECT_HOMEPAGE_URL} CACHE INTERNAL "project homepage url" FORCE)
    ENDIF(_CONCRETE_PROJECT_HOMEPAGE_URL)

    SET(cmakeVersion "$CACHE{CMAKE_CACHE_MAJOR_VERSION}.$CACHE{CMAKE_CACHE_MINOR_VERSION}.$CACHE{CMAKE_CACHE_PATCH_VERSION}")

    IF ( ${cmakeVersion} VERSION_GREATER_EQUAL "3.12.4")
        IF (${languagesListLenght} GREATER 0)
            IF (_CONCRETE_PROJECT_VERSION)

                PROJECT(${CONCRETE_PROJECT_NAME} 
                        LANGUAGES ${languages} 
                        VERSION ${CONCRETE_PROJECT_SOFTWARE_VERSION} 
                        DESCRIPTION ${CONCRETE_PROJECT_DESCRIPTION} 
                        HOMEPAGE_URL ${CONCRETE_PROJECT_HOMEPAGE_URL}
                        )
            ELSE()

                PROJECT(${CONCRETE_PROJECT_NAME}
                        LANGUAGES ${languages} 
                        DESCRIPTION ${CONCRETE_PROJECT_DESCRIPTION}
                        HOMEPAGE_URL ${CONCRETE_PROJECT_HOMEPAGE_URL}
                        )
            ENDIF(_CONCRETE_PROJECT_VERSION)
        ELSE()
            IF (_CONCRETE_PROJECT_VERSION)

                PROJECT(${CONCRETE_PROJECT_NAME}
                        VERSION ${CONCRETE_PROJECT_SOFTWARE_VERSION} 
                        DESCRIPTION ${CONCRETE_PROJECT_DESCRIPTION}
                        HOMEPAGE_URL ${CONCRETE_PROJECT_HOMEPAGE_URL}
                        )
            ELSE()

                PROJECT(${CONCRETE_PROJECT_NAME} 
                        DESCRIPTION ${CONCRETE_PROJECT_DESCRIPTION}
                        HOMEPAGE_URL ${CONCRETE_PROJECT_HOMEPAGE_URL}
                        )

            ENDIF(_CONCRETE_PROJECT_VERSION)
        ENDIF(${languagesListLenght} GREATER 0)
    ELSE()
        IF (${languagesListLenght} GREATER 0)
            IF (_CONCRETE_PROJECT_VERSION)

                PROJECT(${CONCRETE_PROJECT_NAME}
                        LANGUAGES ${languages} 
                        VERSION ${CONCRETE_PROJECT_SOFTWARE_VERSION} 
                        DESCRIPTION ${CONCRETE_PROJECT_DESCRIPTION}
                        )

            ELSE()

                PROJECT(${CONCRETE_PROJECT_NAME} 
                        LANGUAGES ${languages} 
                        DESCRIPTION ${CONCRETE_PROJECT_DESCRIPTION}
                        )

            ENDIF(_CONCRETE_PROJECT_VERSION)
        ELSE()
            IF (_CONCRETE_PROJECT_VERSION)

                PROJECT(${CONCRETE_PROJECT_NAME} 
                        VERSION ${CONCRETE_PROJECT_SOFTWARE_VERSION} 
                        DESCRIPTION ${CONCRETE_PROJECT_DESCRIPTION}
                        )
                        
            ELSE()

                PROJECT(${CONCRETE_PROJECT_NAME} 
                        DESCRIPTION ${CONCRETE_PROJECT_DESCRIPTION}
                        )

            ENDIF(_CONCRETE_PROJECT_VERSION)
        ENDIF(${languagesListLenght} GREATER 0)
    ENDIF(${cmakeVersion} VERSION_GREATER_EQUAL "3.12.4")

    UNSET(cmakeVersion)

    # end set project 

    CONCRETE_METHOD_COLLECT_SYSTEM_INFORMATION()

    SET(CONCRETE_PROJECT_NAME ${CMAKE_PROJECT_NAME} CACHE INTERNAL "project name" FORCE)

    IF(_CONCRETE_PROJECT_ROOT_DIR)
        SET(CONCRETE_PROJECT_ROOT_DIRECTORY ${_CONCRETE_PROJECT_ROOT_DIR} CACHE PATH "prject root dir default as ${CMAKE_HOME_DIRECTORY}" FORCE)
    ELSE(_CONCRETE_PROJECT_ROOT_DIR)
        SET(CONCRETE_PROJECT_ROOT_DIRECTORY "${${CMAKE_PROJECT_NAME}_BINARY_DIR}" CACHE PATH "prject root dir default as ${CMAKE_HOME_DIRECTORY}" FORCE)
    ENDIF(_CONCRETE_PROJECT_ROOT_DIR)

    # begin set compiler target
    # set platform compiler target x86 or x64 or arm(not supported yet)
    IF (CMAKE_CL_64)
        SET(CONCRETE_PROJECT_COMPILER_TARGET x64 CACHE INTERNAL "project compiler target" FORCE)
    ELSE()
        SET(CONCRETE_PROJECT_COMPILER_TARGET x86 CACHE INTERNAL "project compiler target" FORCE)
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

    SET(CONCRETE_PROJECT_BINARY_OUTPUT_DIRECTORY ${runtimeOutputDir} CACHE PATH "global binary files generate directory" FORCE)

    UNSET(runtimeOutputDir)

    SET(libraryOutputDir)

    IF(_CONCRETE_PROJECT_LIBRARY_OUTPUT_DIR)
        SET(libraryOutputDir ${_CONCRETE_PROJECT_LIBRARY_OUTPUT_DIR})
    ELSE(_CONCRETE_PROJECT_LIBRARY_OUTPUT_DIR)
        SET(libraryOutputDir ${CONCRETE_PROJECT_ROOT_DIRECTORY}/lib)
    ENDIF(_CONCRETE_PROJECT_LIBRARY_OUTPUT_DIR)

    IF (${_CONCRETE_PROJECT_GEN_COMPILER_TARGET_SUBDIRECTORY})
        SET(libraryOutputDir ${libraryOutputDir}/${CONCRETE_PROJECT_COMPILER_TARGET})
    ENDIF(${_CONCRETE_PROJECT_GEN_COMPILER_TARGET_SUBDIRECTORY})

    SET(CONCRETE_PROJECT_LIBRARY_OUTPUT_DIRECTORY ${libraryOutputDir} CACHE PATH "global binary files generate directory" FORCE)

    UNSET(libraryOutputDir)

    SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CONCRETE_PROJECT_BINARY_OUTPUT_DIRECTORY})        
    SET(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CONCRETE_PROJECT_LIBRARY_OUTPUT_DIRECTORY})
    SET(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CONCRETE_PROJECT_LIBRARY_OUTPUT_DIRECTORY})
    #[[ end set output dir ]] ########################################

    # begin set build types
    SET(buildTypes "")
    IF(_CONCRETE_PROJECT_BUILD_TYPES)
        FOREACH(var ${_CONCRETE_PROJECT_BUILD_TYPES})
            STRING(APPEND buildTypes "${var};")

            SET(upperValue)
            STRING(TOUPPER "${var}" upperValue)

            IF(NOT CMAKE_EXE_LINKER_FLAGS_${upperValue})
                SET(CMAKE_EXE_LINKER_FLAGS_${upperValue} CACHE STRING "Flags used by the linker during ${upperValue} builds." FORCE)
            ENDIF(NOT CMAKE_EXE_LINKER_FLAGS_${upperValue})

            IF (${languagesListLenght} EQUAL 0)
                SET(languages C CXX)
            ENDIF(${languagesListLenght} EQUAL 0)

            FOREACH(lang ${languages})
                SET(langUpperValue)                
                STRING(TOUPPER "${lang}" langUpperValue)

                IF(NOT CMAKE_${langUpperValue}_FLAGS_${upperValue})
                    SET(CMAKE_${langUpperValue}_FLAGS_${upperValue} CACHE STRING "Flags used by the ${langUpperValue} compiler during ${upperValue} builds." FORCE)
                ENDIF(NOT CMAKE_${langUpperValue}_FLAGS_${upperValue})

                UNSET(langUpperValue)
            ENDFOREACH(lang ${languages})
            
            UNSET(upperValue)
        ENDFOREACH(var ${_CONCRETE_PROJECT_BUILD_TYPES})

        SET(length)
        STRING(LENGTH "${buildTypes}" length)
        MATH(EXPR length "${length} - 1")
        STRING(SUBSTRING "${buildTypes}" 0 ${length} buildTypes)
        UNSET(length)        

        IF(CMAKE_CONFIGURATION_TYPES) # multiconfig generator?
            SET(CMAKE_CONFIGURATION_TYPES "${buildTypes}" CACHE STRING "Choose the type of build" FORCE) 
        ELSE()
            IF(NOT CMAKE_BUILD_TYPE)
                SET(CMAKE_BUILD_TYPE "${buildTypes}" CACHE STRING "" FORCE)
            ENDIF()

            SET_PROPERTY(CACHE CMAKE_BUILD_TYPE PROPERTY HELPSTRING "Choose the type of build")

            SET_PROPERTY(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "${buildTypes}")
        ENDIF()
    ENDIF(_CONCRETE_PROJECT_BUILD_TYPES)

    UNSET(buildTypes)
    UNSET(languagesListLenght)
    UNSET(languages)

    # end set build types
ENDMACRO(CONCRETE_METHOD_PROJECT_INITIALIZATION)

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
    SET(options APPEND)
    SET(singleValueKey BUILD_TYPE LANGUAGE_OR_LINKER COPY_FROM_TYPE)
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
    IF(${_CONCRETE_BUILD_TYPE} STREQUAL "")
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
    ENDIF(${_CONCRETE_BUILD_TYPE} STREQUAL "")

    IF(NOT DEFINED ${flagName})
        MESSAGE(FATAL_ERROR "cache variable flag can not find")
    ENDIF(NOT DEFINED ${flagName})

    SET(flagCopyFrom)
    IF(_CONCRETE_COPY_FROM_TYPE)
        IF(${_CONCRETE_COPY_FROM_TYPE} STREQUAL "")
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
        ENDIF(${_CONCRETE_BUILD_TYPE} STREQUAL "")

        IF(NOT DEFINED ${flagCopyFrom})
            MESSAGE(FATAL_ERROR "Copy source not exists")
        ELSE()
            SET_PROPERTY(CACHE ${flagName} PROPERTY VALUE "${${flagCopyFrom}}")

            RETURN()
        ENDIF(NOT DEFINED ${flagCopyFrom})
    ENDIF(_CONCRETE_COPY_FROM_TYPE)

    SET(flags)
    IF(${_CONCRETE_APPEND})
        SET(flags "${${flagName}}")
    ENDIF(${_CONCRETE_APPEND})

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
