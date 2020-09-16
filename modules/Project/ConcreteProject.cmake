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

function(concrete_generator_toolset)
    if (MSVC)
        set(toolset ${CMAKE_VS_PLATFORM_TOOLSET})            
    endif()

    if ("_${toolset}" STREQUAL "_")
        set(toolset ${CMAKE_GENERATOR_TOOLSET})

        if ("_${toolset}" STREQUAL "_")
            set(toolset ${CMAKE_GENERATOR})
        endif()        
    endif()

    if ("${toolset}" STREQUAL "Visual Studio 16 2019" OR "${toolset}" STREQUAL "v142")
        set_property(CACHE CONCRETE_GENERATOR_TOOLSET PROPERTY VALUE "v142")
    elseif("${toolset}" STREQUAL "Visual Studio 15 2017" OR "${toolset}" STREQUAL "v141")
        set_property(CACHE CONCRETE_GENERATOR_TOOLSET PROPERTY VALUE "v141")
    elseif("${toolset}" STREQUAL "Visual Studio 14 2015" OR "${toolset}" STREQUAL "v140")
        set_property(CACHE CONCRETE_GENERATOR_TOOLSET PROPERTY VALUE "v140")
    endif()
endfunction(concrete_generator_toolset)

# https://bitbucket.org/ignitionrobotics/ign-cmake/issues/7/the-top-level-cmakeliststxt-file-for-a
macro(concrete_project PROJECT_NAME)         
    set(options 
        WITH_COMPILER_TARGET_POSTFIX 
    )

    set(singleValueKey 
        NAME DESCRIPTION HOMEPAGE_URL PACKAGE_NAME
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
    set_property(CACHE CONCRETE_PROJECT_NAME PROPERTY VALUE ${PROJECT_NAME})

    if (_CONCRETE_PROJECT_PACKAGE_NAME)
        set(packageName ${_CONCRETE_PROJECT_PACKAGE_NAME})
    else()
        set(packageName ${CONCRETE_PROJECT_NAME})
    endif()

    set_property(CACHE CONCRETE_PACKAGE_NAME PROPERTY VALUE ${packageName})
    set_property(CACHE CONCRETE_EXPORT_NAME PROPERTY VALUE ${packageName}Targets)
    set_property(CACHE CONCRETE_EXPORT_NAMESPACE PROPERTY VALUE ${packageName}::)

    if (_CONCRETE_PROJECT_LANGUAGES)
        foreach(var ${_CONCRETE_PROJECT_LANGUAGES})
            concrete_check_language_supported(${var} result)
            
            if(NOT ${result})
                concrete_error("Not supported language ${var}")
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

        if(${CONCRETE_PROJECT_SOFTWARE_VERSION} STREQUAL "")
            set_property(CACHE CONCRETE_PROJECT_SOFTWARE_VERSION_MAJOR PROPERTY VALUE 0)
            set_property(CACHE CONCRETE_PROJECT_SOFTWARE_VERSION_MINOR PROPERTY VALUE 0)
            set_property(CACHE CONCRETE_PROJECT_SOFTWARE_VERSION_PATCH PROPERTY VALUE 1)
            set_property(CACHE CONCRETE_PROJECT_SOFTWARE_VERSION_TWEAK PROPERTY VALUE 0)
            set_property(CACHE CONCRETE_PROJECT_SOFTWARE_VERSION PROPERTY VALUE "0.0.1.0")
        endif()

        list(APPEND projectParameterList VERSION ${CONCRETE_PROJECT_SOFTWARE_VERSION})
    endif(_CONCRETE_PROJECT_VERSION)

    if (_CONCRETE_PROJECT_DESCRIPTION)
        set_property(CACHE CONCRETE_PROJECT_DESCRIPTION PROPERTY VALUE ${_CONCRETE_PROJECT_DESCRIPTION})
        list(APPEND projectParameterList DESCRIPTION ${CONCRETE_PROJECT_DESCRIPTION})
    endif(_CONCRETE_PROJECT_DESCRIPTION)

    if (_CONCRETE_PROJECT_HOMEPAGE_URL)
        set_property(CACHE CONCRETE_PROJECT_HOMEPAGE_URL PROPERTY VALUE ${_CONCRETE_PROJECT_HOMEPAGE_URL})

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

    # generator toolset
    concrete_generator_toolset()

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

    if (${_CONCRETE_PROJECT_WITH_COMPILER_TARGET_POSTFIX})
        set(runtimeOutputDir ${runtimeOutputDir}/${CONCRETE_PROJECT_COMPILER_TARGET})
    endif(${_CONCRETE_PROJECT_WITH_COMPILER_TARGET_POSTFIX})

    set_property(CACHE CONCRETE_PROJECT_BINARY_OUTPUT_DIRECTORY PROPERTY VALUE ${runtimeOutputDir})

    if(_CONCRETE_PROJECT_LIBRARY_OUTPUT_DIR)
        set(libraryOutputDir ${_CONCRETE_PROJECT_LIBRARY_OUTPUT_DIR})
    else(_CONCRETE_PROJECT_LIBRARY_OUTPUT_DIR)
        set(libraryOutputDir ${CONCRETE_PROJECT_ROOT_DIRECTORY}/lib)
    endif(_CONCRETE_PROJECT_LIBRARY_OUTPUT_DIR)

    if (${_CONCRETE_PROJECT_WITH_COMPILER_TARGET_POSTFIX})
        set(libraryOutputDir ${libraryOutputDir}/${CONCRETE_PROJECT_COMPILER_TARGET})
    endif(${_CONCRETE_PROJECT_WITH_COMPILER_TARGET_POSTFIX})

    set_property(CACHE CONCRETE_PROJECT_LIBRARY_OUTPUT_DIRECTORY PROPERTY VALUE ${libraryOutputDir})

    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CONCRETE_PROJECT_BINARY_OUTPUT_DIRECTORY})        
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CONCRETE_PROJECT_LIBRARY_OUTPUT_DIRECTORY})
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CONCRETE_PROJECT_LIBRARY_OUTPUT_DIRECTORY})

    #[[ end set output dir ]] ########################################

    # begin set build types
    if(_CONCRETE_PROJECT_CONFIGURATION_TYPES)
        get_property(languages GLOBAL PROPERTY ENABLED_LANGUAGES)

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
                set(CMAKE_BUILD_TYPE "${_CONCRETE_PROJECT_CONFIGURATION_TYPES}" CACHE STRING "" FORCE)
            endif()

            set_property(CACHE CMAKE_BUILD_TYPE PROPERTY HELPSTRING "Choose the type of build")

            set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "${_CONCRETE_PROJECT_CONFIGURATION_TYPES}")
        endif(CMAKE_CONFIGURATION_TYPES)
    endif(_CONCRETE_PROJECT_CONFIGURATION_TYPES)
    # end set build types

    #[[
        add a interface target named of ConcreteInterface
        for as properties interface for other target
    #]]
    concrete_target(
        ConcreteInterface
        
        "Interface"

        CREATE_ONLY
    )

    concrete_install(
        TARGETS ConcreteInterface 
        DEFAULT_EXPORT
    )
    
    __concrete_clear_cache()
endmacro(concrete_project)

function(concrete_global_target_configure)
    set(options)
    set(singleValueKey)
    set(mulitValueKey PROPERTIES LINK_DIRECTORIES LINK_LIBRARIES LINK_OPTIONS INCLUDE_DIRECTORIES COMPILE_OPTIONS COMPILE_FEATURES COMPILE_DEFINITIONS SOURCES)

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
        set_target_properties(${targetName} PROPERTIES ${_CONCRETE_PROPERTIES})
    endif(_CONCRETE_PROPERTIES)

    if(_CONCRETE_LINK_OPTIONS)
        target_link_options(${targetName} INTERFACE ${_CONCRETE_LINK_OPTIONS})
    endif(_CONCRETE_LINK_OPTIONS)

    if(_CONCRETE_LINK_DIRECTORIES)
        target_link_directories(${targetName} INTERFACE ${_CONCRETE_INCLUDE_DIRECTORIES})
    endif(_CONCRETE_LINK_DIRECTORIES)

    if(_CONCRETE_LINK_LIBRARIES)
        target_link_libraries(${targetName} INTERFACE ${_CONCRETE_LINK_LIBRARIES})
    endif(_CONCRETE_LINK_LIBRARIES)

    if(_CONCRETE_INCLUDE_DIRECTORIES)
        target_include_directories(${targetName} INTERFACE ${_CONCRETE_INCLUDE_DIRECTORIES})
    endif(_CONCRETE_INCLUDE_DIRECTORIES)

    if(_CONCRETE_COMPILE_OPTIONS)
        target_compile_options(${targetName} INTERFACE ${_CONCRETE_COMPILE_OPTIONS})
    endif(_CONCRETE_COMPILE_OPTIONS)

    if(_CONCRETE_COMPILE_DEFINITIONS)
        target_compile_definitions(${targetName} INTERFACE ${_CONCRETE_COMPILE_DEFINITIONS})
    endif(_CONCRETE_COMPILE_DEFINITIONS)
    
    if (_CONCRETE_COMPILE_FEATURES)
        target_compile_features(${targetName} INTERFACE ${_CONCRETE_COMPILE_FEATURES})
    endif()

    if(_CONCRETE_SOURCES)
        target_sources(${targetName} INTERFACE ${_CONCRETE_SOURCES})
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
        concrete_error("Must set source file path")
    else()
        if(NOT EXISTS ${_CONCRETE_SOURCE_FILE_PATH})
            concrete_error("Source file not exists")
        endif(NOT EXISTS ${_CONCRETE_SOURCE_FILE_PATH})
    endif()

    if(NOT _CONCRETE_DEST_FILE_PATH)
        concrete_error("Must set dest file path")
    endif(NOT _CONCRETE_DEST_FILE_PATH)

    set(sourceFile ${_CONCRETE_SOURCE_FILE_PATH})
    set(destFile ${_CONCRETE_DEST_FILE_PATH})

    if(${_CONCRETE_COPY_ONLY})
        if(_CONCRETE_NEWLINE_STYLE)
            concrete_warning("Newline style option may not be used with CopyOnly")
        endif(_CONCRETE_NEWLINE_STYLE)

        CONFIGURE_FILE(
            ${sourceFile}
            ${destFile}
            COPYONLY
        )
        RETURN()
    endif(${_CONCRETE_COPY_ONLY})

    set(newlineStyle)
    if (_CONCRETE_NEWLINE_STYLE)
        if (${_CONCRETE_NEWLINE_STYLE} STREQUAL "UNIX")
            set(newlineStyle NEWLINE_STYLE "UNIX") 
        endif(${_CONCRETE_NEWLINE_STYLE} STREQUAL "UNIX")

        if (${_CONCRETE_NEWLINE_STYLE} STREQUAL "DOS")
            set(newlineStyle NEWLINE_STYLE "DOS") 
        endif(${_CONCRETE_NEWLINE_STYLE} STREQUAL "DOS")        

        if (${_CONCRETE_NEWLINE_STYLE} STREQUAL "WIN32")
            set(newlineStyle NEWLINE_STYLE "WIN32") 
        endif(${_CONCRETE_NEWLINE_STYLE} STREQUAL "WIN32")        

        if (${_CONCRETE_NEWLINE_STYLE} STREQUAL "LF")
            set(newlineStyle NEWLINE_STYLE "LF") 
        endif(${_CONCRETE_NEWLINE_STYLE} STREQUAL "LF")        

        if (${_CONCRETE_NEWLINE_STYLE} STREQUAL "CRLF")
            set(newlineStyle NEWLINE_STYLE "CRLF") 
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

    configure_file(
        ${sourceFile}
        ${destFile}
        ${copyOptions}
        ${newlineStyle}
    )
endfunction(concrete_configure_file)

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