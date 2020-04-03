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

include_guard(GLOBAL)

include( CMakeParseArguments )

include( Project/Internal/ConcreteProcessProperty )
include( Project/Internal/ConcreteCheckLanguage )

function(__concrete_clear_cache)
        # workaround for fix cache value
        list(GET CONCRETE_PROJECT_DEFAULT_PARAMETER 0 tempName)
        UNSET(${tempName}_BINARY_DIR CACHE)
        UNSET(${tempName}_SOURCE_DIR CACHE)
        
        if (CMAKE_CONFIGURATION_TYPES)
            set(buildTypes ${CMAKE_CONFIGURATION_TYPES})
        else()
            set(buildTypes ${CMAKE_BUILD_TYPE})
        endif(CMAKE_CONFIGURATION_TYPES)

        foreach(var ${buildTypes})
            string(TOUPPER "${var}" upperValue)

            UNSET(CMAKE_NONE_FLAGS_${upperValue} CACHE)            
        endforeach(var ${buildTypes})

        string(REPLACE "${tempName}" ${CONCRETE_PROJECT_NAME} value "${CMAKE_INSTALL_PREFIX}")
        set_property(CACHE CMAKE_INSTALL_PREFIX PROPERTY VALUE ${value})    
endfunction(__concrete_clear_cache)

function(concrete_check_compiler_target)
    # begin set compiler target
    # set platform compiler target x86 or x64 or arm(not supported yet)    
    if (CMAKE_CL_64)
        set_property(CACHE CONCRETE_PROJECT_COMPILER_TARGET PROPERTY VALUE x64)
    else()
        set_property(CACHE CONCRETE_PROJECT_COMPILER_TARGET PROPERTY VALUE x86)
    endif(CMAKE_CL_64)
    # end set compiler target
endfunction(concrete_check_compiler_target)

# https://bitbucket.org/ignitionrobotics/ign-cmake/issues/7/the-top-level-cmakeliststxt-file-for-a
macro(concrete_project)         
    set(options 
        WITH_COMPILER_TARGET_SUBDIR 
    )

    set(singleValueKey 
        NAME DESCRIPTION HOMEPAGE_URL 
        ROOT_DIR BINARY_OUTPUT_DIR LIBRARY_OUTPUT_DIR
    )
    
    set(mulitValueKey 
        VERSION CONFIGURATION_TYPES LANGUAGES
    )

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE_PROJECT
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    # begin set project
    if(_CONCRETE_PROJECT_NAME)
        set_property(CACHE CONCRETE_PROJECT_NAME PROPERTY VALUE ${_CONCRETE_PROJECT_NAME})
    else()
        message(FATAL_ERROR "Project name must be set")
    endif()

    if (_CONCRETE_PROJECT_LANGUAGES)
        foreach(var ${_CONCRETE_PROJECT_LANGUAGES})
            concrete_check_language_supported(${var} result)
            
            if(NOT ${result})
                message(FATAL_ERROR "Not supported language ${var}")
            endif(NOT ${result})
        endforeach(var ${_CONCRETE_PROJECT_LANGUAGES})

        list(APPEND projectParameterList LANGUAGES ${_CONCRETE_PROJECT_LANGUAGES})
    else()
        list(APPEND projectParameterList LANGUAGES C CXX)
    endif(_CONCRETE_PROJECT_LANGUAGES)

    ####################################################################
    if(_CONCRETE_PROJECT_VERSION)
        set(versionListLength)

        list(LENGTH _CONCRETE_PROJECT_VERSION versionListLength)

        if (${versionListLength} GREATER 0)
            list(GET _CONCRETE_PROJECT_VERSION 0 major)
            set_property(CACHE CONCRETE_PROJECT_SOFTWARE_VERSION_MAJOR PROPERTY VALUE ${major})
            set_property(CACHE CONCRETE_PROJECT_SOFTWARE_VERSION PROPERTY VALUE "${CONCRETE_PROJECT_SOFTWARE_VERSION_MAJOR}")
        endif(${versionListLength} GREATER 0)

        if (${versionListLength} GREATER 1)
            list(GET _CONCRETE_PROJECT_VERSION 1 minor)
            set_property(CACHE CONCRETE_PROJECT_SOFTWARE_VERSION_MINOR PROPERTY VALUE ${minor})
            set_property(CACHE CONCRETE_PROJECT_SOFTWARE_VERSION PROPERTY VALUE "${CONCRETE_PROJECT_SOFTWARE_VERSION_MAJOR}.${CONCRETE_PROJECT_SOFTWARE_VERSION_MINOR}")
        endif(${versionListLength} GREATER 1)

        if (${versionListLength} GREATER 2)
            list(GET _CONCRETE_PROJECT_VERSION 2 patch)
            set_property(CACHE CONCRETE_PROJECT_SOFTWARE_VERSION_PATCH PROPERTY VALUE ${patch})
            set_property(CACHE CONCRETE_PROJECT_SOFTWARE_VERSION PROPERTY VALUE "${CONCRETE_PROJECT_SOFTWARE_VERSION_MAJOR}.${CONCRETE_PROJECT_SOFTWARE_VERSION_MINOR}.${CONCRETE_PROJECT_SOFTWARE_VERSION_PATCH}")
        endif(${versionListLength} GREATER 2)

        if (${versionListLength} GREATER 3)
            list(GET _CONCRETE_PROJECT_VERSION 3 tweak)
            set_property(CACHE CONCRETE_PROJECT_SOFTWARE_VERSION_TWEAK PROPERTY VALUE ${tweak})
            set_property(CACHE CONCRETE_PROJECT_SOFTWARE_VERSION PROPERTY VALUE "${CONCRETE_PROJECT_SOFTWARE_VERSION_MAJOR}.${CONCRETE_PROJECT_SOFTWARE_VERSION_MINOR}.${CONCRETE_PROJECT_SOFTWARE_VERSION_PATCH}.${CONCRETE_PROJECT_SOFTWARE_VERSION_TWEAK}")
        endif(${versionListLength} GREATER 3)

        if(NOT ${CONCRETE_PROJECT_SOFTWARE_VERSION} STREQUAL "")
            list(APPEND projectParameterList VERSION ${CONCRETE_PROJECT_SOFTWARE_VERSION})
        endif(NOT ${CONCRETE_PROJECT_SOFTWARE_VERSION} STREQUAL "")
    endif(_CONCRETE_PROJECT_VERSION)

    if (_CONCRETE_PROJECT_DESCRIPTION)
        set_property(CACHE CONCRETE_PROJECT_DESCRIPTION PROPERTY VALUE ${_CONCRETE_PROJECT_DESCRIPTION})
        list(APPEND projectParameterList DESCRIPTION ${CONCRETE_PROJECT_DESCRIPTION})
    endif(_CONCRETE_PROJECT_DESCRIPTION)

    if (_CONCRETE_PROJECT_HOMEPAGE_URL)
        set_property(CACHE CONCRETE_PROJECT_HOMEPAGE_URL PROPERTY VALUE ${_CONCRETE_PROJECT_PROJECT_HOMEPAGE_URL})

        set(cmakeVersion "$CACHE{CMAKE_CACHE_MAJOR_VERSION}.$CACHE{CMAKE_CACHE_MINOR_VERSION}.$CACHE{CMAKE_CACHE_PATCH_VERSION}")

        if (${cmakeVersion} VERSION_GREATER_EQUAL "3.12.4")
            list(APPEND projectParameterList HOMEPAGE_URL ${CONCRETE_PROJECT_HOMEPAGE_URL})
        endif(${cmakeVersion} VERSION_GREATER_EQUAL "3.12.4")        
    endif(_CONCRETE_PROJECT_HOMEPAGE_URL)

    # project command for languages, version, description, homeurl
    project(${CONCRETE_PROJECT_NAME} ${projectParameterList})
    # end set project 

    # collect system information
    concrete_collect_system_information()

    # check compiler target
    concrete_check_compiler_target()

    if(_CONCRETE_PROJECT_ROOT_DIR)
        set_property(CACHE CONCRETE_PROJECT_ROOT_DIRECTORY PROPERTY VALUE ${_CONCRETE_PROJECT_ROOT_DIR})
    else(_CONCRETE_PROJECT_ROOT_DIR)
        set_property(CACHE CONCRETE_PROJECT_ROOT_DIRECTORY PROPERTY VALUE ${CMAKE_HOME_DIRECTORY})
    endif(_CONCRETE_PROJECT_ROOT_DIR)

    #[[ begin set output dir ]] ########################################
    set(runtimeOutputDir)

    if(_CONCRETE_PROJECT_BINARY_OUTPUT_DIR)
        set(runtimeOutputDir ${_CONCRETE_PROJECT_BINARY_OUTPUT_DIR})
    else(_CONCRETE_PROJECT_BINARY_OUTPUT_DIR)
        set(runtimeOutputDir ${CONCRETE_PROJECT_ROOT_DIRECTORY}/bin)
    endif(_CONCRETE_PROJECT_BINARY_OUTPUT_DIR)

    if (${_CONCRETE_PROJECT_WITH_COMPILER_TARGET_SUBDIR})
        set(runtimeOutputDir ${runtimeOutputDir}/${CONCRETE_PROJECT_COMPILER_TARGET})
    endif(${_CONCRETE_PROJECT_WITH_COMPILER_TARGET_SUBDIR})

    set_property(CACHE CONCRETE_PROJECT_BINARY_OUTPUT_DIRECTORY PROPERTY VALUE ${runtimeOutputDir})

    if(_CONCRETE_PROJECT_LIBRARY_OUTPUT_DIR)
        set(libraryOutputDir ${_CONCRETE_PROJECT_LIBRARY_OUTPUT_DIR})
    else(_CONCRETE_PROJECT_LIBRARY_OUTPUT_DIR)
        set(libraryOutputDir ${CONCRETE_PROJECT_ROOT_DIRECTORY}/lib)
    endif(_CONCRETE_PROJECT_LIBRARY_OUTPUT_DIR)

    if (${_CONCRETE_PROJECT_WITH_COMPILER_TARGET_SUBDIR})
        set(libraryOutputDir ${libraryOutputDir}/${CONCRETE_PROJECT_COMPILER_TARGET})
    endif(${_CONCRETE_PROJECT_WITH_COMPILER_TARGET_SUBDIR})

    set_property(CACHE CONCRETE_PROJECT_LIBRARY_OUTPUT_DIRECTORY PROPERTY VALUE ${libraryOutputDir})

    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CONCRETE_PROJECT_BINARY_OUTPUT_DIRECTORY})        
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CONCRETE_PROJECT_LIBRARY_OUTPUT_DIRECTORY})
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CONCRETE_PROJECT_LIBRARY_OUTPUT_DIRECTORY})

    #[[ end set output dir ]] ########################################

    # begin set build types
    set(buildTypes "")
    if(_CONCRETE_PROJECT_CONFIGURATION_TYPES)
        GET_PROPERTY(languages GLOBAL PROPERTY ENABLED_LANGUAGES)

        foreach(var ${_CONCRETE_PROJECT_CONFIGURATION_TYPES})
            string(TOUPPER "${var}" upperValue)

            if(NOT CMAKE_EXE_LINKER_FLAGS_${upperValue})
                set(CMAKE_EXE_LINKER_FLAGS_${upperValue} CACHE STRING "Flags used by the linker during ${upperValue} builds." FORCE)
            endif(NOT CMAKE_EXE_LINKER_FLAGS_${upperValue})
            
            foreach(lang ${languages})
                set(langUpperValue)                
                string(TOUPPER "${lang}" langUpperValue)

                if(NOT CMAKE_${langUpperValue}_FLAGS_${upperValue})
                    set(CMAKE_${langUpperValue}_FLAGS_${upperValue} CACHE STRING "Flags used by the ${langUpperValue} compiler during ${upperValue} builds." FORCE)
                endif(NOT CMAKE_${langUpperValue}_FLAGS_${upperValue})

            endforeach(lang ${languages})            
        endforeach(var ${_CONCRETE_PROJECT_CONFIGURATION_TYPES})

        if(CMAKE_CONFIGURATION_TYPES)
            set_property(CACHE CMAKE_CONFIGURATION_TYPES PROPERTY VALUE "${_CONCRETE_PROJECT_CONFIGURATION_TYPES}")
            set_property(CACHE CMAKE_CONFIGURATION_TYPES PROPERTY HELPSTRING "configuration types")            
        else()
            if(NOT CMAKE_BUILD_TYPE)
                set(CMAKE_BUILD_TYPE "${buildTypes}" CACHE STRING "" FORCE)
            endif()

            set_property(CACHE CMAKE_BUILD_TYPE PROPERTY HELPSTRING "Choose the type of build")

            set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "${buildTypes}")
        endif(CMAKE_CONFIGURATION_TYPES)
    endif(_CONCRETE_PROJECT_CONFIGURATION_TYPES)
    # end set build types

    #[[
        add a interface target named of ConcreteInterface
        for as properties interface for other target
    #]]
    concrete_target(
        TARGET_NAME 
            ConcreteInterface
        TYPE        
            "Interface"
        CREATE_ONLY
    )
    
    __concrete_clear_cache()
endmacro(concrete_project)

function(concrete_global_target_configure)
    set(options)
    set(singleValueKey)
    set(mulitValueKey PROPERTIES LINK_DIRECTORIES LINK_LIBRARIES LINK_OPTIONS INCLUDE_DIRECTORIES COMPILE_OPTIONS COMPILE_DEFINITIONS SOURCES)

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    set(targetName ConcreteInterface)

    # TODO::参数检查

    if(_CONCRETE_PROPERTIES)
        SET_TARGET_PROPERTIES(${targetName} PROPERTIES ${_CONCRETE_PROPERTIES})
    endif(_CONCRETE_PROPERTIES)

    if(_CONCRETE_LINK_OPTIONS)
        TARGET_LINK_OPTIONS(${targetName} INTERFACE ${_CONCRETE_LINK_OPTIONS})
    endif(_CONCRETE_LINK_OPTIONS)

    if(_CONCRETE_LINK_DIRECTORIES)
        TARGET_LINK_DIRECTORIES(${targetName} INTERFACE ${_CONCRETE_INCLUDE_DIRECTORIES})
    endif(_CONCRETE_LINK_DIRECTORIES)

    if(_CONCRETE_LINK_LIBRARIES)
        TARGET_LINK_LIBRARIES(${targetName} INTERFACE ${_CONCRETE_LINK_LIBRARIES})
    endif(_CONCRETE_LINK_LIBRARIES)

    if(_CONCRETE_INCLUDE_DIRECTORIES)
        TARGET_INCLUDE_DIRECTORIES(${targetName} INTERFACE ${_CONCRETE_INCLUDE_DIRECTORIES})
    endif(_CONCRETE_INCLUDE_DIRECTORIES)

    if(_CONCRETE_COMPILE_OPTIONS)
        TARGET_COMPILE_OPTIONS(${targetName} INTERFACE ${_CONCRETE_COMPILE_OPTIONS})
    endif(_CONCRETE_COMPILE_OPTIONS)

    if(_CONCRETE_COMPILE_DEFINITIONS)
        TARGET_COMPILE_DEFINITIONS(${targetName} INTERFACE ${_CONCRETE_COMPILE_DEFINITIONS})
    endif(_CONCRETE_COMPILE_DEFINITIONS)

    if(_CONCRETE_SOURCES)
        TARGET_SOURCES(${targetName} INTERFACE ${_CONCRETE_SOURCES})
    endif(_CONCRETE_SOURCES)
endfunction(concrete_global_target_configure)

function(concrete_configure_file)
    set(options COPY_ONLY)
    set(singleValueKey SOURCE_FILE_PATH DEST_FILE_PATH NEWLINE_STYLE)
    set(mulitValueKey COPY_OPTIONS)

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    if(NOT _CONCRETE_SOURCE_FILE_PATH)
        message(FATAL_ERROR "Must set source file path")
    else()
        if(NOT EXISTS ${_CONCRETE_SOURCE_FILE_PATH})
            message(FATAL_ERROR "Source file not exists")
        endif(NOT EXISTS ${_CONCRETE_SOURCE_FILE_PATH})
    endif(_CONCRETE_SOURCE_FILE_PATH)

    if(NOT _CONCRETE_DEST_FILE_PATH)
        message(FATAL_ERROR "Must set dest file path")
    endif(NOT _CONCRETE_DEST_FILE_PATH)

    if(${_CONCRETE_COPY_ONLY})
        if(_CONCRETE_NEWLINE_STYLE)
            message(WARNING "Newline style option may not be used with CopyOnly")
        endif(_CONCRETE_NEWLINE_STYLE)

        CONFIGURE_FILE(
            ${SOURCE_FILE_PATH}
            ${DEST_FILE_PATH}
            COPYONLY
        )
        RETURN()
    endif(${_CONCRETE_COPY_ONLY})

    set(newlineStyle)
    if (_CONCRETE_NEWLINE_STYLE)
        if (${_CONCRETE_NEWLINE_STYLE} STREQUAL "UNIX")
            set(newlineStyle "UNIX") 
        endif(${_CONCRETE_NEWLINE_STYLE} STREQUAL "UNIX")

        if (${_CONCRETE_NEWLINE_STYLE} STREQUAL "DOS")
            set(newlineStyle "DOS") 
        endif(${_CONCRETE_NEWLINE_STYLE} STREQUAL "DOS")        

        if (${_CONCRETE_NEWLINE_STYLE} STREQUAL "WIN32")
            set(newlineStyle "WIN32") 
        endif(${_CONCRETE_NEWLINE_STYLE} STREQUAL "WIN32")        

        if (${_CONCRETE_NEWLINE_STYLE} STREQUAL "LF")
            set(newlineStyle "LF") 
        endif(${_CONCRETE_NEWLINE_STYLE} STREQUAL "LF")        

        if (${_CONCRETE_NEWLINE_STYLE} STREQUAL "CRLF")
            set(newlineStyle "CRLF") 
        endif(${_CONCRETE_NEWLINE_STYLE} STREQUAL "CRLF")        
    endif(_CONCRETE_NEWLINE_STYLE)

    set(copyOptions)
    if (_CONCRETE_COPY_OPTIONS)
        foreach(var ${_CONCRETE_COPY_OPTIONS})
            if(${var} STREQUAL "EscapeQuotes")
                set(copyOptions ${copyOptions} ESCAPE_QUOTES)
            endif(${var} STREQUAL "EscapeQuotes")

            if(${var} STREQUAL "@Only")
                set(copyOptions ${copyOptions} @ONLY)
            endif(${var} STREQUAL "@Only")
        endforeach(var ${_CONCRETE_COPY_OPTIONS})            
    endif(_CONCRETE_COPY_OPTIONS)

    CONFIGURE_FILE(
        ${SOURCE_FILE_PATH}
        ${DEST_FILE_PATH}
        ${copyOptions}
        NEWLINE_STYLE ${newlineStyle}
    )
endfunction(concrete_configure_file)

# function(CONCRETE_METHOD_SET_GLOBAL_COMPILE_OPTIONS_AND_DEFINITIONS)
    # set(options APPEND WITHOUT_DEBUG USE_UNICODE WARNING_AS_ERROR)
    # set(singleValueKey BUILD_TYPE LANGUAGE_OR_LINKER COPY_FROM_TYPE WARNING_LEVEL DEBUG_INFO_FORMAT)
    # set(mulitValueKey)
    
    # CMAKE_PARSE_ARGUMENTS(
    #     _CONCRETE
    #     "${options}"
    #     "${singleValueKey}"
    #     "${mulitValueKey}"
    #     ${ARGN}
    # )

#     if(NOT _CONCRETE_BUILD_TYPE)
#         message(FATAL_ERROR "Build type must be set")
#     endif(NOT _CONCRETE_BUILD_TYPE)

#     if (NOT _CONCRETE_LANGUAGE_OR_LINKER)
#         message(FATAL_ERROR "language or linker must be set")
#     endif(NOT _CONCRETE_LANGUAGE_OR_LINKER)

#     set(flagName)
#     if(${_CONCRETE_BUILD_TYPE} STREQUAL "ALL_BUILD")
#         if (${_CONCRETE_LANGUAGE_OR_LINKER} STREQUAL "Linker")
#             set(flagName CMAKE_EXE_LINKER_FLAGS)
#         else()
#             set(language)
#             STRING(TOUPPER "${_CONCRETE_LANGUAGE_OR_LINKER}" language)
#             set(flagName CMAKE_${language}_FLAGS)
#         endif(${_CONCRETE_LANGUAGE_OR_LINKER} STREQUAL "Linker")
#     else()
#         set(buildType)
#         STRING(TOUPPER "${_CONCRETE_BUILD_TYPE}" buildType)

#         if (${_CONCRETE_LANGUAGE_OR_LINKER} STREQUAL "Linker")
#             set(flagName CMAKE_EXE_LINKER_FLAGS_${buildType})
#         else()
#             set(language)
#             STRING(TOUPPER "${_CONCRETE_LANGUAGE_OR_LINKER}" language)
#             set(flagName CMAKE_${language}_FLAGS_${buildType})
#         endif(${_CONCRETE_LANGUAGE_OR_LINKER} STREQUAL "Linker")
#     endif(${_CONCRETE_BUILD_TYPE} STREQUAL "ALL_BUILD")

#     if(NOT DEFINED ${flagName})
#         message(FATAL_ERROR "cache variable flag can not find")
#     endif(NOT DEFINED ${flagName})

#     set(flagCopyFrom)
#     if(_CONCRETE_COPY_FROM_TYPE)
#         if(${_CONCRETE_COPY_FROM_TYPE} STREQUAL "ALL_BUILD")
#             if (${_CONCRETE_LANGUAGE_OR_LINKER} STREQUAL "Linker")
#                 set(flagCopyFrom CMAKE_EXE_LINKER_FLAGS)
#             else()
#                 set(language)
#                 STRING(TOUPPER "${_CONCRETE_LANGUAGE_OR_LINKER}" language)
#                 set(flagCopyFrom CMAKE_${language}_FLAGS)
#             endif(${_CONCRETE_LANGUAGE_OR_LINKER} STREQUAL "Linker")
#         else()
#             set(buildType)
#             STRING(TOUPPER "${_CONCRETE_COPY_FROM_TYPE}" buildType)

#             if (${_CONCRETE_LANGUAGE_OR_LINKER} STREQUAL "Linker")
#                 set(flagCopyFrom CMAKE_EXE_LINKER_FLAGS_${buildType})
#             else()
#                 set(language)
#                 STRING(TOUPPER "${_CONCRETE_LANGUAGE_OR_LINKER}" language)
#                 set(flagCopyFrom CMAKE_${language}_FLAGS_${buildType})
#             endif(${_CONCRETE_LANGUAGE_OR_LINKER} STREQUAL "Linker")
#         endif(${_CONCRETE_BUILD_TYPE} STREQUAL "ALL_BUILD")

#         if(NOT DEFINED ${flagCopyFrom})
#             message(FATAL_ERROR "Copy source not exists")
#         else()
#             set_property(CACHE ${flagName} PROPERTY VALUE "${${flagCopyFrom}}")

#             RETURN()
#         endif(NOT DEFINED ${flagCopyFrom})
#     endif(_CONCRETE_COPY_FROM_TYPE)

#     set(length)
#     set(flags "")
#     if(${_CONCRETE_APPEND})
#         set(flags "${${flagName}}")
        
#         STRING(LENGTH "${flags}" length)
#         if(NOT ${length} EQUAL 0)
#             STRING(APPEND flags " ")
#         endif(NOT ${length} EQUAL 0)
#     endif(${_CONCRETE_APPEND})

#     if(${_CONCRETE_WITHOUT_DEBUG})
#         CONCRETE_INTERNAL_METHOD_ADD_NDEBUG_FLAG(flags)
#     endif(${_CONCRETE_WITHOUT_DEBUG})

#     if (${_CONCRETE_WARNING_AS_ERROR})
#         CONCRETE_INTERNAL_METHOD_ADD_WARNING_AS_ERROR_FLAG(flags)
#     endif(${_CONCRETE_WARNING_AS_ERROR})

#     if(${_CONCRETE_USE_UNICODE})
#         CONCRETE_INTERNAL_METHOD_ADD_UNICODE_FLAG(flags)
#     endif(${_CONCRETE_USE_UNICODE})

#     if(_CONCRETE_WARNING_LEVEL)
#         CONCRETE_INTERNAL_METHOD_ADD_WARNING_LEVEL_FLAG(flags ${_CONCRETE_WARNING_LEVEL})
#     endif(_CONCRETE_WARNING_LEVEL)

#     if (_CONCRETE_DEBUG_INFO_FORMAT)
#         CONCRETE_INTERNAL_METHOD_ADD_DEBUG_INFO_FORMAT(flags ${_CONCRETE_DEBUG_INFO_FORMAT})
#     endif(_CONCRETE_DEBUG_INFO_FORMAT)

#     STRING(LENGTH "${flags}" length)

#     if(NOT ${length} EQUAL 0)
#         # pop last space char
#         CONCRETE_METHOD_STRING_POP_LAST(flags 1 flags)

#         set_property(CACHE ${flagName} PROPERTY VALUE "${flags}")
#     endif(NOT ${length} EQUAL 0)
# endfunction(CONCRETE_METHOD_SET_GLOBAL_COMPILE_OPTIONS_AND_DEFINITIONS)

function(concrete_set_global_properties)
    set(options)
    set(singleValueKey)
    set(mulitValueKey PROPERTIES)

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    if (_CONCRETE_PROPERTIES)
        set(index 0)
        list(LENGTH _CONCRETE_PROPERTIES length)

        WHILE(${index} LESS ${length})
            list(GET _CONCRETE_PROPERTIES ${index} key)

            math(EXPR indexIncrement "${index} + 1")

            list(GET _CONCRETE_PROPERTIES ${indexIncrement} value)

            set_property(GLOBAL PROPERTY ${key} ${value})

            math(EXPR index "${index} + 2")
        ENDWHILE(${index} LESS ${length})
    endif(_CONCRETE_PROPERTIES)
endfunction(concrete_set_global_properties)

function(concrete_set_vs_startup_project TARGET)
    set_property(DIRECTORY ${CMAKE_HOME_DIRECTORY} PROPERTY VS_STARTUP_PROJECT ${TARGET})
endfunction(concrete_set_vs_startup_project)