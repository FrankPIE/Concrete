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

################## function start ############################
### clear default project cache properties generate
### we must use cmake project function at most first to generate some necessary variables,
### but it will take some unnecessary variables at the same time, 
### this function will clear those unnecessary variables.
function(__concrete_clear_cache)
        # workaround for fix cache value
        # get default project name, as default is "__"
        list(GET CONCRETE_PROJECT_DEFAULT_PARAMETER 0 defaultProjectName)

        # ___BINARY_DIR and ___SOURCE_DIR variables as default
        # will be generator by project function and clear by this function 
        unset(${defaultProjectName}_BINARY_DIR CACHE)
        unset(${defaultProjectName}_SOURCE_DIR CACHE)
        
        # get all build configuration types, like Debug,Release,ect..
        if (CMAKE_CONFIGURATION_TYPES)
            set(buildTypes ${CMAKE_CONFIGURATION_TYPES})
        else()
            set(buildTypes ${CMAKE_BUILD_TYPE})
        endif(CMAKE_CONFIGURATION_TYPES)

        # clear all build types flags cache
        foreach(var ${buildTypes})
            string(TOUPPER "${var}" upperValue)

            UNSET(CMAKE_NONE_FLAGS_${upperValue} CACHE)            
        endforeach(var ${buildTypes})

        # CMAKE_INSTALL_PREFIX will use default project name as prefix, use user define project instead and set
        string(REPLACE "${defaultProjectName}" ${CONCRETE_PROJECT_NAME} value "${CMAKE_INSTALL_PREFIX}")
        set_property(CACHE CMAKE_INSTALL_PREFIX PROPERTY VALUE ${value})    
endfunction(__concrete_clear_cache)
################## function end ############################

################## function start ############################
### get compiler target and set CONCRETE_PROJECT_COMPILER_TARGET property
function(__concrete_check_compiler_target)
    # begin set compiler target
    # set platform compiler target x86 or x64 or arm(not supported yet)
    # if CMAKE_CL_64 has defined, it must be x64
    if (CMAKE_CL_64) 
        set_property(CACHE CONCRETE_PROJECT_COMPILER_TARGET PROPERTY VALUE x64)
    else()
        set_property(CACHE CONCRETE_PROJECT_COMPILER_TARGET PROPERTY VALUE x86)
    endif(CMAKE_CL_64)
    # end set compiler target
endfunction(__concrete_check_compiler_target)
################## function end ############################

################## function start ############################
### get compiler toolset and set CONCRETE_GENERATOR_TOOLSET property
function(__concrete_generator_toolset)
    # find CMAKE_VS_PLATFORM_TOOLSET value first
    # only useful on microsoft visual c++ runtime
    if (MSVC)
        set(toolset ${CMAKE_VS_PLATFORM_TOOLSET})            
    endif()

    # if toolset is empty, 
    # find CMAKE_GENERATOR_TOOLSET or CMAKE_GENERATOR value to determine toolset value
    if ("_${toolset}" STREQUAL "_")
        set(toolset ${CMAKE_GENERATOR_TOOLSET})

        if ("_${toolset}" STREQUAL "_")
            set(toolset ${CMAKE_GENERATOR})
        endif()        
    endif()

    # set CONCRETE_GENERATOR_TOOLSET property value, only support vs2019, vs2017, vs2015 currently
    if ("${toolset}" STREQUAL "Visual Studio 16 2019" OR "${toolset}" STREQUAL "v142")
        set_property(CACHE CONCRETE_GENERATOR_TOOLSET PROPERTY VALUE "v142")
    elseif("${toolset}" STREQUAL "Visual Studio 15 2017" OR "${toolset}" STREQUAL "v141")
        set_property(CACHE CONCRETE_GENERATOR_TOOLSET PROPERTY VALUE "v141")
    elseif("${toolset}" STREQUAL "Visual Studio 14 2015" OR "${toolset}" STREQUAL "v140")
        set_property(CACHE CONCRETE_GENERATOR_TOOLSET PROPERTY VALUE "v140")
    endif()
endfunction(__concrete_generator_toolset)
################## function end ############################

################## function start ############################
### get cmake version
function(__concrete_cmake_version VERSION)
    set(${VERSION} "$CACHE{CMAKE_CACHE_MAJOR_VERSION}.$CACHE{CMAKE_CACHE_MINOR_VERSION}.$CACHE{CMAKE_CACHE_PATCH_VERSION}" PARENT_SCOPE)    
endfunction(__concrete_cmake_version)

################## function end ############################

################## function start ############################
### https://bitbucket.org/ignitionrobotics/ign-cmake/issues/7/the-top-level-cmakeliststxt-file-for-a
### use marco, make all variables at root directory scope
### PROJECT_NAME : generate project name
macro(concrete_project PROJECT_NAME)
    set(options 
        # [obsolete, use USE_DEFAULT_POSTFIX]
        # WITH_COMPILER_TARGET_POSTFIX 
        USE_DEFAULT_FOLDER_POSTFIX # generate /${CONCRETE_PROJECT_COMPILER_TARGET} postfix, like bin/x86/Debug
    )

    set(singleValueKey 
        DESCRIPTION         # project description, same as project description parameter
        HOMEPAGE_URL        # project homepage
        PACKAGE_NAME        # generate pacakage for other project to reference this project 
        ROOT_DIR            # project root directory path
        BINARY_OUTPUT_DIR   # dynamic binary file output directory path
        LIBRARY_OUTPUT_DIR  # static binary file output directory path
        FOLDER_POSTFIX      # user define floder postfix, like bin/${FOLDER_POSTFIX}/Debug
    )
    
    set(mulitValueKey 
        VERSION             # version, major, minor, patch, tweak
        CONFIGURATION_TYPES # configuration types, like Debug, Release, etc...
        LANGUAGES           # enable languages, like c cxx, visit this page for more support languages information https://cmake.org/cmake/help/latest/command/enable_language.html#command:enable_language
    )

    ## parser arguments
    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE_PROJECT
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    ## begin set project
    # set project name into property CONCRETE_PROJECT_NAME
    set_property(CACHE CONCRETE_PROJECT_NAME PROPERTY VALUE ${PROJECT_NAME})

    # set package name, if without given package name, use project name as default
    if (_CONCRETE_PROJECT_PACKAGE_NAME)
        set(packageName ${_CONCRETE_PROJECT_PACKAGE_NAME})
    else()
        set(packageName ${CONCRETE_PROJECT_NAME})
    endif()

    # use package name to generate package relevant properties
    set_property(CACHE CONCRETE_PACKAGE_NAME PROPERTY VALUE ${packageName})
    set_property(CACHE CONCRETE_EXPORT_NAME PROPERTY VALUE ${packageName}Targets)
    set_property(CACHE CONCRETE_EXPORT_NAMESPACE PROPERTY VALUE ${packageName}::)

    # languages check and make project parameters lanaguagas part
    if (_CONCRETE_PROJECT_LANGUAGES)
        foreach(var ${_CONCRETE_PROJECT_LANGUAGES})
            concrete_check_language_supported(${var} result)
            
            if(NOT ${result})
                concrete_error("not support ${var} language")
            endif(NOT ${result})

            ## marco unset temp variable
            unset(result)
        endforeach(var ${_CONCRETE_PROJECT_LANGUAGES})

        list(APPEND projectParameterList LANGUAGES ${_CONCRETE_PROJECT_LANGUAGES})
    else()
        list(APPEND projectParameterList LANGUAGES C CXX)
    endif(_CONCRETE_PROJECT_LANGUAGES)

    # project version set
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
    endif(_CONCRETE_PROJECT_VERSION)

    # 0.0.1.0 as default
    if("_${CONCRETE_PROJECT_SOFTWARE_VERSION}" STREQUAL "_")
        set_property(CACHE CONCRETE_PROJECT_SOFTWARE_VERSION_MAJOR PROPERTY VALUE 0)
        set_property(CACHE CONCRETE_PROJECT_SOFTWARE_VERSION_MINOR PROPERTY VALUE 0)
        set_property(CACHE CONCRETE_PROJECT_SOFTWARE_VERSION_PATCH PROPERTY VALUE 1)
        set_property(CACHE CONCRETE_PROJECT_SOFTWARE_VERSION_TWEAK PROPERTY VALUE 0)
        set_property(CACHE CONCRETE_PROJECT_SOFTWARE_VERSION PROPERTY VALUE "0.0.1.0")
    endif()

    # make project parameters version part
    list(APPEND projectParameterList VERSION ${CONCRETE_PROJECT_SOFTWARE_VERSION})

    # project description
    if (_CONCRETE_PROJECT_DESCRIPTION)
        set_property(CACHE CONCRETE_PROJECT_DESCRIPTION PROPERTY VALUE ${_CONCRETE_PROJECT_DESCRIPTION})
        list(APPEND projectParameterList DESCRIPTION ${CONCRETE_PROJECT_DESCRIPTION})
    endif(_CONCRETE_PROJECT_DESCRIPTION)

    if (_CONCRETE_PROJECT_HOMEPAGE_URL)
        set_property(CACHE CONCRETE_PROJECT_HOMEPAGE_URL PROPERTY VALUE ${_CONCRETE_PROJECT_HOMEPAGE_URL})
        
        __concrete_camke_version(cmakeVersion)

        # only cmake version greater than 3.12.4 support the HOMEPAGE_URL parameter
        if (${cmakeVersion} VERSION_GREATER_EQUAL "3.12.4")
            list(APPEND projectParameterList HOMEPAGE_URL ${CONCRETE_PROJECT_HOMEPAGE_URL})
        endif(${cmakeVersion} VERSION_GREATER_EQUAL "3.12.4")
    endif(_CONCRETE_PROJECT_HOMEPAGE_URL)

    # project command for languages, version, description, homeurl
    # cmake project second call to generate turely project information
    project(${CONCRETE_PROJECT_NAME} ${projectParameterList})
    # end set project 

    # collect system information
    concrete_collect_system_information()

    # check compiler target
    __concrete_check_compiler_target()

    # generator toolset
    __concrete_generator_toolset()

    if(_CONCRETE_PROJECT_ROOT_DIR)
        set_property(CACHE CONCRETE_PROJECT_ROOT_DIRECTORY PROPERTY VALUE ${_CONCRETE_PROJECT_ROOT_DIR})
    else(_CONCRETE_PROJECT_ROOT_DIR)
        set_property(CACHE CONCRETE_PROJECT_ROOT_DIRECTORY PROPERTY VALUE ${CMAKE_HOME_DIRECTORY})
    endif(_CONCRETE_PROJECT_ROOT_DIR)

    #[[ begin set output dir ]]

    # set generate folder name
    # if use default, will add compiler target as postfix
    if(_CONCRETE_PROJECT_USE_DEFAULT_FOLDER_POSTFIX)
        set(folderPostfix "/${CONCRETE_PROJECT_COMPILER_TARGET}")
    endif(_CONCRETE_PROJECT_USE_DEFAULT_FOLDER_POSTFIX)
    
    # if user defined, use it as postfix
    if(_CONCRETE_PROJECT_FOLDER_POSTFIX)
        set(folderPostfix "/${_CONCRETE_PROJECT_FOLDER_POSTFIX}")        
    endif(_CONCRETE_PROJECT_FOLDER_POSTFIX)
    # or folderPostfix as empty
    
    # set runtime binary file output directory
    if(_CONCRETE_PROJECT_BINARY_OUTPUT_DIR)
        set(runtimeOutputDir ${_CONCRETE_PROJECT_BINARY_OUTPUT_DIR})
    else(_CONCRETE_PROJECT_BINARY_OUTPUT_DIR)
        set(runtimeOutputDir ${CONCRETE_PROJECT_ROOT_DIRECTORY}/bin)
    endif(_CONCRETE_PROJECT_BINARY_OUTPUT_DIR)

    # set static binary file output directory
    if(_CONCRETE_PROJECT_LIBRARY_OUTPUT_DIR)
        set(libraryOutputDir ${_CONCRETE_PROJECT_LIBRARY_OUTPUT_DIR})
    else(_CONCRETE_PROJECT_LIBRARY_OUTPUT_DIR)
        set(libraryOutputDir ${CONCRETE_PROJECT_ROOT_DIRECTORY}/lib)
    endif(_CONCRETE_PROJECT_LIBRARY_OUTPUT_DIR)

    # set to global cache property
    set_property(CACHE CONCRETE_PROJECT_BINARY_OUTPUT_DIRECTORY  PROPERTY VALUE ${runtimeOutputDir}${folderPostfix})
    set_property(CACHE CONCRETE_PROJECT_LIBRARY_OUTPUT_DIRECTORY PROPERTY VALUE ${libraryOutputDir}${folderPostfix})

    # set cmake variable to take effect
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CONCRETE_PROJECT_BINARY_OUTPUT_DIRECTORY})        
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CONCRETE_PROJECT_LIBRARY_OUTPUT_DIRECTORY})
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CONCRETE_PROJECT_LIBRARY_OUTPUT_DIRECTORY})

    # unset temp variable
    unset(runtimeOutputDir)
    unset(libraryOutputDir)
    unset(folderPostfix)
    #[[ end set output dir ]]

    # begin set build types
    if(_CONCRETE_PROJECT_CONFIGURATION_TYPES)
        # get enabled languages to generate global flag properties
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

        # set cmake build-in property value
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

    # add a interface target named of ConcreteInterface
    # for as properties interface for other target
    concrete_target(
        ConcreteInterface
        
        "Interface"

        CREATE_ONLY
    )

    # set install property
    concrete_install(
        TARGETS ConcreteInterface 
        DEFAULT_EXPORT
    )
    
    # clear invalid cache
    __concrete_clear_cache()
endmacro(concrete_project)
################## function end ############################

################## function start ############################
# set global target configure
# use this target to instead cmake global setting 
function(concrete_global_target_configure)
    set(options)

    set(singleValueKey)

    set(mulitValueKey 
        PROPERTIES          # for set_target_properties, set global project properties
        LINK_DIRECTORIES    # for target_link_directories, set global link directories
        LINK_LIBRARIES      # for target_link_libraries, set global link libraries
        LINK_OPTIONS        # for target_link_options, set global link options
        INCLUDE_DIRECTORIES # for target_include_directories, set global include directories
        COMPILE_OPTIONS     # for target_compile_options, set global compiler options
        COMPILE_FEATURES    # for target_compile_features, set global compiler features
        COMPILE_DEFINITIONS # for target_compile_definitions, set global compiler marco
        SOURCES             # for target_sources, set sources list
        )

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
################## function end ############################

################## function start ############################
# cmake configure file opertor warpper
function(concrete_configure_file)
    set(options 
        COPY_ONLY   # use as COPYONLY
        )

    set(singleValueKey 
        SOURCE_FILE_PATH    # source file path, must set
        DEST_FILE_PATH      # dest file path, must set
        NEWLINE_STYLE       # use as 
        )

    set(mulitValueKey 
        COPY_OPTIONS
        )

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    if(NOT _CONCRETE_SOURCE_FILE_PATH)
        concrete_error("must set source file path")
    else()
        if(NOT EXISTS ${_CONCRETE_SOURCE_FILE_PATH})
            concrete_error("source file not exists")
        endif(NOT EXISTS ${_CONCRETE_SOURCE_FILE_PATH})
    endif()

    if(NOT _CONCRETE_DEST_FILE_PATH)
        concrete_error("must set dest file path")
    endif(NOT _CONCRETE_DEST_FILE_PATH)

    set(sourceFile ${_CONCRETE_SOURCE_FILE_PATH})
    set(destFile ${_CONCRETE_DEST_FILE_PATH})

    if(${_CONCRETE_COPY_ONLY})
        if(_CONCRETE_NEWLINE_STYLE)
            concrete_warning("newline style option may not be used with CopyOnly")
        endif(_CONCRETE_NEWLINE_STYLE)

        CONFIGURE_FILE(
            ${sourceFile}
            ${destFile}
            COPYONLY
        )
        RETURN()
    endif(${_CONCRETE_COPY_ONLY})

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
################## function end ############################

################## function start ############################
# set global properties
# useful to setting cmake global properties
# some magic will use this function
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
        
        # loop setting every of property
        WHILE(${index} LESS ${length})
            list(GET _CONCRETE_PROPERTIES ${index} key)

            math(EXPR indexIncrement "${index} + 1")

            list(GET _CONCRETE_PROPERTIES ${indexIncrement} value)

            set_property(GLOBAL PROPERTY ${key} ${value})

            math(EXPR index "${index} + 2")
        ENDWHILE(${index} LESS ${length})
    endif(_CONCRETE_PROPERTIES)
endfunction(concrete_set_global_properties)
################## function end ############################