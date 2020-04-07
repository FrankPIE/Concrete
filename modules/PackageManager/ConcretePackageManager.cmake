# MIT License
# 
# Copyright (c) 2020 MadStrawberry
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

include(FetchContent)
include(CMakeParseArguments)

function(__concrete_fecth_content PACKAGE_NAME)
    set(options)

    set(urlDownloadSingleValueKey
            URL_HASH
            TARGET_NAME
            TIMEOUT
            TLS_VERIFY
            TLS_CAINFO
            NETRC_LEVEL
            NETRC_FILE
        )

    set(gitCloneSingleValueKey
            GIT_REMOTE_NAME
            GIT_SUBMODULES_RECURSE
            GIT_SHALLOW 
        )

    set(svnCloneSingleValueKey
            SVN_TRUST_CERT 
        )

    set(cvsCloneSingleValueKey
            CVS_MODULE 
        )

    set(singleValueKey 
            PACKAGE_TYPE
            DOWNLOAD_COMMAND
            REPOSITORY
            COMMIT_TAG
            USERNAME
            PASSWORD
            SOURCE_DIR
            BINARY_DIR
            SUBBUILD_DIR
            ${urlDownloadSingleValueKey}
            ${gitCloneSingleValueKey}
            ${svnCloneSingleValueKey}
            ${cvsCloneSingleValueKey}
        )

    set(urlDownloadMulitValueKey
            LINKS
            HTTP_HEADER
        )

    set(gitCloneMulitValueKey
            GIT_SUBMODULES 
            GIT_CONFIG
        )

    set(mulitValueKey
        ${urlDownloadMulitValueKey}
        ${gitCloneMulitValueKey}
        UPDATE_PATCH_OPTIONS
        )

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    set(packageName ${PACKAGE_NAME})

    if(NOT _CONCRETE_PACKAGE_TYPE)
        concrete_error("can't find package type")
    endif(NOT _CONCRETE_PACKAGE_TYPE)

    set(fetchContentParamters)

    # URL Type
    if(${_CONCRETE_PACKAGE_TYPE} STREQUAL "url")
        if(_CONCRETE_LINKS)
            set(packageTarget ${_CONCRETE_LINKS})
        else()
            concrete_error("can't find url address")
        endif(_CONCRETE_LINKS)    

        list(APPEND fetchContentParamters ${packageName} URL ${packageTarget})

        if(_CONCRETE_URL_HASH)
            list(APPEND fetchContentParamters URL_HASH ${_CONCRETE_URL_HASH})
        endif(_CONCRETE_URL_HASH)

        if(_CONCRETE_TARGET_NAME)
            list(APPEND fetchContentParamters DOWNLOAD_NAME ${_CONCRETE_TARGET_NAME})
        endif(_CONCRETE_TARGET_NAME)

        if (_CONCRETE_TIMEOUT)
            list(APPEND fetchContentParamters TIMEOUT ${_CONCRETE_TIMEOUT})
        endif(_CONCRETE_TIMEOUT)

        if (_CONCRETE_USERNAME)
            list(APPEND fetchContentParamters HTTP_USERNAME ${_CONCRETE_USERNAME})
        endif(_CONCRETE_USERNAME)

        if (_CONCRETE_PASSWORD)
            list(APPEND fetchContentParamters HTTP_PASSWORD ${_CONCRETE_PASSWORD})
        endif(_CONCRETE_PASSWORD)

        if (_CONCRETE_HTTP_HEADER)
            list(APPEND fetchContentParamters HTTP_HEADER ${_CONCRETE_HTTP_HEADER})
        endif(_CONCRETE_HTTP_HEADER)

        if (_CONCRETE_TLS_VERIFY)
            list(APPEND fetchContentParamters TLS_VERIFY ${_CONCRETE_TLS_VERIFY})
        endif (_CONCRETE_TLS_VERIFY)

        if (_CONCRETE_TLS_CAINFO)
            list(APPEND fetchContentParamters TLS_CAINFO ${_CONCRETE_TLS_CAINFO})
        endif (_CONCRETE_TLS_CAINFO)

        if (_CONCRETE_NETRC_LEVEL)
            list(APPEND fetchContentParamters NETRC ${_CONCRETE_NETRC_LEVEL})
        endif (_CONCRETE_NETRC_LEVEL)

        if (_CONCRETE_NETRC_FILE)
            list(APPEND fetchContentParamters NETRC_FILE ${_CONCRETE_NETRC_FILE})
        endif (_CONCRETE_NETRC_FILE)
    # GIT Type
    else(${_CONCRETE_PACKAGE_TYPE} STREQUAL "url")
        if (_CONCRETE_REPOSITORY)
            set(repository ${_CONCRETE_REPOSITORY})
        else()
            concrete_error("can't find repository url")
        endif(_CONCRETE_REPOSITORY)

        if(_CONCRETE_COMMIT_TAG)
            set(tag ${_CONCRETE_COMMIT_TAG})
        else()
            concrete_error("can't find repository tag, branch or commit")
        endif(_CONCRETE_COMMIT_TAG)

        if (${_CONCRETE_PACKAGE_TYPE} STREQUAL "git")            
            list(APPEND fetchContentParamters GIT_REPOSITORY ${repository} GIT_TAG ${tag} GIT_PROGRESS ON)

            if(_CONCRETE_GIT_REMOTE_NAME)
                list(APPEND fetchContentParamters GIT_REMOTE_NAME ${_CONCRETE_GIT_REMOTE_NAME})
            endif(_CONCRETE_GIT_REMOTE_NAME)

            if(_CONCRETE_GIT_SUBMODULES)
                list(APPEND fetchContentParamters GIT_SUBMODULES ${_CONCRETE_GIT_SUBMODULES})
            endif(_CONCRETE_GIT_SUBMODULES)

            if(_CONCRETE_GIT_SUBMODULES_RECURSE)
                list(APPEND fetchContentParamters GIT_SUBMODULES_RECURSE ${_CONCRETE_GIT_SUBMODULES_RECURSE})
            endif(_CONCRETE_GIT_SUBMODULES_RECURSE)

            if(_CONCRETE_GIT_SHALLOW)
               list(APPEND fetchContentParamters GIT_SHALLOW ${_CONCRETE_GIT_SHALLOW})
            endif(_CONCRETE_GIT_SHALLOW)

            if(_CONCRETE_GIT_CONFIG)
               list(APPEND fetchContentParamters GIT_CONFIG ${_CONCRETE_GIT_CONFIG})
            endif(_CONCRETE_GIT_CONFIG)
        elseif(${_CONCRETE_PACKAGE_TYPE} STREQUAL "svn")
            list(APPEND fetchContentParamters SVN_REPOSITORY ${repository} SVN_REVISION "-r${tag}")

            if (_CONCRETE_USERNAME)
                list(APPEND fetchContentParamters SVN_USERNAME ${_CONCRETE_USERNAME})
            endif(_CONCRETE_USERNAME)

            if (_CONCRETE_PASSWORD)
                list(APPEND fetchContentParamters SVN_PASSWORD ${_CONCRETE_PASSWORD})
            endif(_CONCRETE_PASSWORD)

            if (_CONCRETE_SVN_TRUST_CERT)
                list(APPEND fetchContentParamters SVN_TRUST_CERT ${_CONCRETE_SVN_TRUST_CERT})
            endif(_CONCRETE_SVN_TRUST_CERT)
        elseif(${_CONCRETE_PACKAGE_TYPE} STREQUAL "hg")
            list(APPEND fetchContentParamters HG_REPOSITORY ${repository} HG_TAG ${tag})
        elseif(${_CONCRETE_PACKAGE_TYPE} STREQUAL "cvs")
            list(APPEND fetchContentParamters CVS_REPOSITORY ${repository} CVS_TAG ${tag})

            if(_CONCRETE_CVS_MODULE)
                list(APPEND fetchContentParamters CVS_MODULE ${_CONCRETE_CVS_MODULE})
            endif(_CONCRETE_CVS_MODULE)
        endif(${_CONCRETE_PACKAGE_TYPE} STREQUAL "git")
    endif(${_CONCRETE_PACKAGE_TYPE} STREQUAL "url")

    if (_CONCRETE_DOWNLOAD_COMMAND)
        list(APPEND fetchContentParamters DOWNLOAD_COMMAND ${_CONCRETE_DOWNLOAD_COMMAND})
    endif(_CONCRETE_DOWNLOAD_COMMAND)

    if (_CONCRETE_UPDATE_PATCH_OPTIONS)
        list(APPEND fetchContentParamters ${_CONCRETE_UPDATE_PATCH_OPTIONS})
    endif(_CONCRETE_UPDATE_PATCH_OPTIONS)

    if(_CONCRETE_SOURCE_DIR)
        set(sourceDirectory ${_CONCRETE_SOURCE_DIR})
    else()
        set(sourceDirectory ${FETCHCONTENT_BASE_DIR}/${packageName}/source)
    endif(_CONCRETE_SOURCE_DIR)

    if (_CONCRETE_BINARY_DIR)
        set(binaryDirectory ${_CONCRETE_BINARY_DIR})
    else()
        set(binaryDirectory ${FETCHCONTENT_BASE_DIR}/${packageName}/install)
    endif(_CONCRETE_BINARY_DIR)

    if (_CONCRETE_SUBBUILD_DIR)
        set(subBuildDirectory ${_CONCRETE_SUBBUILD_DIR})
    else()
        set(subBuildDirectory ${FETCHCONTENT_BASE_DIR}/${packageName}/cmake-project)
    endif(_CONCRETE_SUBBUILD_DIR)

    list(APPEND fetchContentParamters 
        SOURCE_DIR ${sourceDirectory}
        BINARY_DIR ${binaryDirectory}
        SUBBUILD_DIR ${subBuildDirectory}    
        )
    
    FetchContent_Declare(${packageName} ${fetchContentParamters})
endfunction(__concrete_fecth_content)

function(__concrete_execute_build_process PACKAGE_NAME RESULT)
    set(options DOWNLOAD_ONLY)

    set(singleValueKey WORKING_DIRECTORY)

    set(mulitValueKey 
            COMMANDS            
        )

    string(TOLOWER ${packageName} lcPackageName)

    set(newArgs ${ARGN})

    string(REPLACE "PACKAGE_SOURCE_DIR" "${${lcPackageName}_SOURCE_DIR}" newArgs ${newArgs})
    string(REPLACE "PACKAGE_BINARY_DIR" "${${lcPackageName}_BINARY_DIR}" newArgs ${newArgs})
    string(REPLACE "PACKAGE_SUBBUILD_DIR" "${${lcPackageName}_SUBBUILD_DIR}" newArgs ${newArgs})
    
    concrete_separate_arguments(${newArgs} newArgs COMMAND_MODE "Windows")

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${newArgs}
    )

    if (_CONCRETE_WORKING_DIRECTORY)
        set(workingDirectory ${_CONCRETE_WORKING_DIRECTORY})
    else()
        set(workingDirectory ${${lcPackageName}_SOURCE_DIR})
    endif(_CONCRETE_WORKING_DIRECTORY)

    if (_CONCRETE_COMMANDS)
        set(command ${_CONCRETE_COMMANDS})

        concrete_debug("command : ${command}")
        
        execute_process(
            COMMAND ${command}
            WORKING_DIRECTORY "${workingDirectory}"
            RESULT_VARIABLE result
        )

        if (${result} STREQUAL "0")            
            set(${RESULT} ${result} PARENT_SCOPE)
        else()
            concrete_error("${result}")
        endif()
    endif(_CONCRETE_COMMANDS)
endfunction(__concrete_execute_build_process)

function(__concrete_cmake_standard_commands CommandsOutput)
    set(options)

    set(singleValueKey ROOT_DIR INSTALL_DIR
        CMAKE_GENERATOR CMAKE_GENERATOR_PLATFORM CMAKE_GENERATOR_TOOLSET CMAKE_SYSTEM_VERSION CMAKE_ARGS)  

    set(mulitValueKey CMAKE_CONFIGURE_TYPES)

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    if (_CONCRETE_ROOT_DIR)
        set(rootDir ${_CONCRETE_ROOT_DIR})
    else()
        set(rootDir "${${lcPackageName}_SOURCE_DIR}")
    endif()

    if (_CONCRETE_INSTALL_DIR)
        set(installDir ${_CONCRETE_INSTALL_DIR})
    else()
        set(installDir "${${lcPackageName}_BINARY_DIR}")
    endif()

    set(dirs rootDir installDir)

    foreach(var ${dirs})
        string(REPLACE "PACKAGE_SOURCE_DIR" "${${lcPackageName}_SOURCE_DIR}" ${var} ${${var}})
        string(REPLACE "PACKAGE_BINARY_DIR" "${${lcPackageName}_BINARY_DIR}" ${var} ${${var}})
        string(REPLACE "PACKAGE_SUBBUILD_DIR" "${${lcPackageName}_SUBBUILD_DIR}" ${var} ${${var}})        
    endforeach()
    
    get_property(buildPathDefined CACHE CONCRETE_${packageName}_BUILD_PATH PROPERTY VALUE SET)

    if (NOT ${buildPathDefined})
        concrete_uuid(uuid)
        
        set(buildDir "${rootDir}/build-${uuid}")            

        concrete_create_directorys(DIRECTORYS ${buildDir} ABSOULT_PATH)

        set(CONCRETE_${packageName}_BUILD_PATH ${buildDir} CACHE PATH "${packageName} build path" FORCE)
    else()
        set(buildDir "${CONCRETE_${packageName}_BUILD_PATH}")

        if (NOT EXISTS ${buildDir})
            concrete_create_directorys(DIRECTORYS ${buildDir} ABSOULT_PATH)
        endif()
    endif()

    if (NOT ${CONCRETE_PACKAGE_MANAGER_${packageName}_BUILDED})
    if (EXISTS ${buildDir}/CMakeCache.txt)
        concrete_remove_file(FILES ${buildDir}/CMakeCache.txt)
    endif()
    endif()

    set(generatorCommand "COMMANDS ${CMAKE_COMMAND} ")

    if (_CONCRETE_CMAKE_GENERATOR)
        string(APPEND generatorCommand "-G '${_CONCRETE_CMAKE_GENERATOR}' ")
    else()
        string(APPEND generatorCommand "-G '${CMAKE_GENERATOR}' ")
    endif()

    if (_CONCRETE_CMAKE_GENERATOR_PLATFORM)
        string(APPEND generatorCommand "-A '${_CONCRETE_CMAKE_GENERATOR_PLATFORM}' ")
    else()
        string(APPEND generatorCommand "-A '${CMAKE_GENERATOR_PLATFORM}' ")
    endif()

    if (_CONCRETE_CMAKE_GENERATOR_TOOLSET)
        string(APPEND generatorCommand "-DCMAKE_GENERATOR_TOOLSET=${_CONCRETE_CMAKE_GENERATOR_TOOLSET} ")
    else()
        get_property(generatorToolsetDefined CACHE CMAKE_GENERATOR_TOOLSET PROPERTY VALUE SET)

        if (${generatorToolsetDefined})
            if (NOT ${CMAKE_GENERATOR_TOOLSET} STREQUAL "")
                string(APPEND generatorCommand "-DCMAKE_GENERATOR_TOOLSET=${CMAKE_GENERATOR_TOOLSET} ")
            endif()
        endif()
    endif()

    if (_CONCRETE_CMAKE_SYSTEM_VERSION)
        string(APPEND generatorCommand "-DCMAKE_SYSTEM_VERSION=${_CONCRETE_CMAKE_SYSTEM_VERSION} ")
    else()
        get_property(systemVersionDefined CACHE CMAKE_SYSTEM_VERSION PROPERTY VALUE SET)

        if (${systemVersionDefined})
            string(APPEND generatorCommand "-DCMAKE_SYSTEM_VERSION=${CMAKE_SYSTEM_VERSION} ")
        endif()
    endif()

    string(APPEND generatorCommand "-DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH} ")

    string(APPEND generatorCommand "-DCMAKE_INSTALL_PREFIX=${installDir} ")

    if (_CONCRETE_CMAKE_ARGS)
        foreach(var ${_CONCRETE_CMAKE_ARGS})
            string(APPEND generatorCommand "${var} ")
        endforeach()    
    endif()

    string(APPEND generatorCommand "${rootDir} WORKING_DIRECTORY ${buildDir}")

    list(APPEND commands ${generatorCommand})

    if (_CONCRETE_CMAKE_CONFIGURE_TYPES)
        set(configureTypes ${_CONCRETE_CMAKE_CONFIGURE_TYPES})
    else()
        set(configureTypes Debug Release)
    endif()

    foreach(var ${configureTypes})
        set(buildCommand "COMMANDS ${CMAKE_COMMAND} --build . --config ${var} WORKING_DIRECTORY ${buildDir}")

        list(APPEND commands ${buildCommand})
    endforeach()    

    foreach(var ${configureTypes})
        set(installCommand "COMMANDS ${CMAKE_COMMAND} --install . --config ${var} --prefix ${installDir} WORKING_DIRECTORY ${buildDir}")

        list(APPEND commands ${installCommand})
    endforeach() 

    set(${CommandsOutput} ${commands} PARENT_SCOPE)
endfunction(__concrete_cmake_standard_commands)

function(__concrete_download_and_build PACKAGE_NAME)
    set(options 
        DOWNLOAD_ONLY          
        )

    set(singleValueKey BUILD_TOOLSET)

    set(mulitValueKey 
            DOWNLOAD_OPTIONS 
            CMAKE_STANDARD_BUILD_OPTIONS
            BUILD_COMMANDS 
            CONFIGURE_COMMANDS
            CREATE_DIRECTORYS
        )

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    if (_CONCRETE_BUILD_TOOLSET)
        set(buildToolset ${_CONCRETE_BUILD_TOOLSET})
    else()
        set(buildToolset "None")
    endif()

    set(packageName ${PACKAGE_NAME})

    if (_CONCRETE_DOWNLOAD_OPTIONS)
        __concrete_fecth_content(${packageName} ${_CONCRETE_DOWNLOAD_OPTIONS})

        string(TOLOWER ${packageName} lcPackageName)

        FetchContent_GetProperties(${packageName})

        if (NOT ${lcPackageName}_POPULATED)
            FetchContent_Populate(${packageName})

            set(${lcPackageName}_SOURCE_DIR ${${lcPackageName}_SOURCE_DIR} PARENT_SCOPE)
            set(${lcPackageName}_BINARY_DIR ${${lcPackageName}_BINARY_DIR} PARENT_SCOPE)
            set(${lcPackageName}_SUBBUILD_DIR ${${lcPackageName}_SUBBUILD_DIR} PARENT_SCOPE)

            get_property(packageBuildedDefined CACHE CONCRETE_PACKAGE_MANAGER_${packageName}_BUILDED PROPERTY VALUE SET)

            if (NOT ${packageBuildedDefined})
                set(CONCRETE_PACKAGE_MANAGER_${packageName}_BUILDED FALSE CACHE BOOL "${packageName} builded flag" FORCE)
            endif()

            if (${_CONCRETE_DOWNLOAD_ONLY})
                return()
            endif(${_CONCRETE_DOWNLOAD_ONLY})

            if (NOT ${CONCRETE_PACKAGE_MANAGER_${packageName}_BUILDED}) 
                # Build Step
                if (_CONCRETE_CONFIGURE_COMMANDS)
                    foreach(var ${_CONCRETE_CONFIGURE_COMMANDS})
                        concrete_configure_file(${var})
                    endforeach()                    
                endif(_CONCRETE_CONFIGURE_COMMANDS)

                if (_CONCRETE_CREATE_DIRECTORYS)
                    foreach(var ${_CONCRETE_CREATE_DIRECTORYS})
                        string(REPLACE "PACKAGE_SOURCE_DIR" "${${lcPackageName}_SOURCE_DIR}" var ${var})
                        string(REPLACE "PACKAGE_BINARY_DIR" "${${lcPackageName}_BINARY_DIR}" var ${var})
                        string(REPLACE "PACKAGE_SUBBUILD_DIR" "${${lcPackageName}_SUBBUILD_DIR}" var ${var})

                        concrete_create_directorys(DIRECTORYS ${var} ABSOULT_PATH)
                    endforeach()                    
                endif()

                if (${buildToolset} STREQUAL "Customize")
                    if (_CONCRETE_BUILD_COMMANDS)
                        set(commandsList "${_CONCRETE_BUILD_COMMANDS}")
                    else()
                        concrete_warning("no build commands option found, may set BUILD_TOOLSET option None")
                    endif()
                elseif(${buildToolset} STREQUAL "CMake")
                    __concrete_cmake_standard_commands(commandsList ${_CONCRETE_CMAKE_STANDARD_BUILD_OPTIONS})
                elseif(${buildToolset} STREQUAL "None")
                    return()
                endif()

                foreach(var ${commandsList})
                    __concrete_execute_build_process(${packageName} result ${var})

                    if (NOT ${result} STREQUAL "0")
                        break()
                    endif()
                endforeach()                    

                if (${result} STREQUAL "0")
                    set(CONCRETE_PACKAGE_MANAGER_${packageName}_BUILDED TRUE CACHE BOOL "${packageName} builded flag" FORCE)
                endif()
            endif(NOT ${CONCRETE_PACKAGE_MANAGER_${packageName}_BUILDED})
        endif(NOT ${lcPackageName}_POPULATED)
    endif(_CONCRETE_DOWNLOAD_OPTIONS)
endfunction(__concrete_download_and_build)

function(__concrete_fecth_package PACKAGE_NAME)
    set(options)

    set(singleValueKey)

    set(mulitValueKey DOWNLOAD_BUILD_STEP_OPTIONS)

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    __concrete_download_and_build(${PACKAGE_NAME} ${_CONCRETE_DOWNLOAD_BUILD_STEP_OPTIONS})

    string(TOLOWER ${PACKAGE_NAME} lcPackageName)

    list(APPEND CMAKE_PREFIX_PATH ${${lcPackageName}_BINARY_DIR} ${${lcPackageName}_SOURCE_DIR})

    set(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} PARENT_SCOPE)

    concrete_export_package_manager_path(${lcPackageName})
endfunction(__concrete_fecth_package)

function(concrete_package PACKAGE_NAME)
    set(options)

    set(singleValueKey PACKAGE_ROOT VERSION)

    set(mulitValueKey PACKAGES DEPEND_PACKAGES_PATH FIND_PACKAGE_ARGUMENTS FETCH_PACKAGE_ARGUMENTS)

    CMAKE_PARSE_ARGUMENTS(
        _ "${options}" "${singleValueKey}" "${mulitValueKey}"
        ${ARGN}
    )

    if (_PACKAGES)
        foreach(var ${_PACKAGES})
            string(TOUPPER ${var} ucPackage)
            set(mulitValueKey ${mulitValueKey} ${ucPackage}_FIND_PACKAGE_ARGUMENTS)
        endforeach()
    endif()

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE "${options}" "${singleValueKey}" "${mulitValueKey}"
        ${ARGN}
    )

    set(packageName ${PACKAGE_NAME})

    if (_CONCRETE_VERSION)
        get_property(packageVersionDefined CACHE CONCRETE_PACKAGE_MANAGER_${packageName}_VERSION PROPERTY VALUE SET)

        if (${packageVersionDefined})
            get_property(packageVersion CACHE CONCRETE_PACKAGE_MANAGER_${packageName}_VERSION PROPERTY VALUE)

            if (NOT ${packageVersion} VERSION_EQUAL ${_CONCRETE_VERSION})
                get_property(packageBuildedDefined CACHE CONCRETE_PACKAGE_MANAGER_${packageName}_BUILDED PROPERTY VALUE SET)

                if (${packageBuildedDefined})
                    set_property(CACHE CONCRETE_PACKAGE_MANAGER_${packageName}_BUILDED PROPERTY VALUE FALSE) 
                else()   
                    set(CONCRETE_PACKAGE_MANAGER_${packageName}_BUILDED FALSE CACHE BOOL "${packageName} builded flag" FORCE)
                endif()
            endif()

            set_property(CACHE CONCRETE_PACKAGE_MANAGER_${packageName}_VERSION PROPERTY VALUE ${_CONCRETE_VERSION})
        else()
            set(CONCRETE_PACKAGE_MANAGER_${packageName}_VERSION ${_CONCRETE_VERSION} CACHE INTERNAL "${packageName} version" FORCE)
        endif(${packageVersionDefined})
    endif(_CONCRETE_VERSION)

    if (_CONCRETE_DEPEND_PACKAGES_PATH)
        list(APPEND CMAKE_PREFIX_PATH ${_CONCRETE_DEPEND_PACKAGES_PATH})
    endif()

    __concrete_fecth_package(${PACKAGE_NAME} ${_CONCRETE_FETCH_PACKAGE_ARGUMENTS})

    if (_CONCRETE_PACKAGES)
        foreach(var ${_CONCRETE_PACKAGES})
            string(TOUPPER ${var} ucPackage)
            find_package(${var} ${_CONCRETE_${ucPackage}_FIND_PACKAGE_ARGUMENTS})

            set(${var}_FOUND ${${var}_FOUND} PARENT_SCOPE)
        endforeach()
    else()
        find_package(${PACKAGE_NAME} ${_CONCRETE_FIND_PACKAGE_ARGUMENTS})

        set(${PACKAGE_NAME}_FOUND ${${PACKAGE_NAME}_FOUND} PARENT_SCOPE)
    endif()

    string(TOLOWER ${PACKAGE_NAME} lcPackageName)

    concrete_export_package_manager_path(${lcPackageName})
endfunction(concrete_package)

function(concrete_set_package_manager_properties)
    set(singleValueProperty VERBOSE BASE_DIR)
    set(mulitValueProperty)

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueProperty}"
        "${mulitValueProperty}"
        ${ARGN}
    )

    if(_CONCRETE_VERBOSE)
        if (${_CONCRETE_VERBOSE})
            set(FETCHCONTENT_QUIET OFF PARENT_SCOPE)
        else()
            set(FETCHCONTENT_QUIET ON PARENT_SCOPE)
        endif(${_CONCRETE_VERBOSE})
    endif(_CONCRETE_VERBOSE)

    if (_CONCRETE_BASE_DIR)
        set_property(CACHE FETCHCONTENT_BASE_DIR PROPERTY VALUE ${_CONCRETE_BASE_DIR})
    endif()
endfunction(concrete_set_package_manager_properties)

macro(concrete_export_package_manager_path PACKAGE_NAME)
    set(${PACKAGE_NAME}_SOURCE_DIR ${${PACKAGE_NAME}_SOURCE_DIR} PARENT_SCOPE)
    set(${PACKAGE_NAME}_BINARY_DIR ${${PACKAGE_NAME}_BINARY_DIR} PARENT_SCOPE)
    set(${PACKAGE_NAME}_SUBBUILD_DIR ${${PACKAGE_NAME}_SUBBUILD_DIR} PARENT_SCOPE)
endmacro(concrete_export_package_manager_path)
