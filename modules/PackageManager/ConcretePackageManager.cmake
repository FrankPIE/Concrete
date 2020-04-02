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

INCLUDE_GUARD(GLOBAL)

INCLUDE(FetchContent)
INCLUDE(CMakeParseArguments)

FUNCTION(__fetchContent PACKAGE_NAME)
    SET(options)

    SET(urlDownloadSingleValueKey
            URL_HASH
            TARGET_NAME
            TIMEOUT
            TLS_VERIFY
            TLS_CAINFO
            NETRC_LEVEL
            NETRC_FILE
        )

    SET(gitCloneSingleValueKey
            GIT_REMOTE_NAME
            GIT_SUBMODULES_RECURSE
            GIT_SHALLOW 
        )

    SET(svnCloneSingleValueKey
            SVN_TRUST_CERT 
        )

    SET(cvsCloneSingleValueKey
            CVS_MODULE 
        )

    SET(singleValueKey 
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

    SET(urlDownloadMulitValueKey
            LINKS
            HTTP_HEADER
        )

    SET(gitCloneMulitValueKey
            GIT_SUBMODULES 
            GIT_CONFIG
        )

    SET(mulitValueKey
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

    SET(packageName ${PACKAGE_NAME})

    IF(NOT _CONCRETE_PACKAGE_TYPE)
        MESSAGE(FATAL_ERROR "can't find package type")
    ENDIF(NOT _CONCRETE_PACKAGE_TYPE)

    SET(fetchContentParamters)

    # URL Type
    IF(${_CONCRETE_PACKAGE_TYPE} STREQUAL "URL")
        IF(_CONCRETE_LINKS)
            SET(packageTarget ${_CONCRETE_LINKS})
        ELSE()
            MESSAGE(FATAL_ERROR "can't find url address")
        ENDIF(_CONCRETE_LINKS)    

        LIST(APPEND fetchContentParamters ${packageName} URL ${packageTarget})

        IF(_CONCRETE_URL_HASH)
            LIST(APPEND fetchContentParamters URL_HASH ${_CONCRETE_URL_HASH})
        ENDIF(_CONCRETE_URL_HASH)

        IF(_CONCRETE_TARGET_NAME)
            LIST(APPEND fetchContentParamters DOWNLOAD_NAME ${_CONCRETE_TARGET_NAME})
        ENDIF(_CONCRETE_TARGET_NAME)

        IF (_CONCRETE_TIMEOUT)
            LIST(APPEND fetchContentParamters TIMEOUT ${_CONCRETE_TIMEOUT})
        ENDIF(_CONCRETE_TIMEOUT)

        IF (_CONCRETE_USERNAME)
            LIST(APPEND fetchContentParamters HTTP_USERNAME ${_CONCRETE_USERNAME})
        ENDIF(_CONCRETE_USERNAME)

        IF (_CONCRETE_PASSWORD)
            LIST(APPEND fetchContentParamters HTTP_PASSWORD ${_CONCRETE_PASSWORD})
        ENDIF(_CONCRETE_PASSWORD)

        IF (_CONCRETE_HTTP_HEADER)
            LIST(APPEND fetchContentParamters HTTP_HEADER ${_CONCRETE_HTTP_HEADER})
        ENDIF(_CONCRETE_HTTP_HEADER)

        IF (_CONCRETE_TLS_VERIFY)
            LIST(APPEND fetchContentParamters TLS_VERIFY ${_CONCRETE_TLS_VERIFY})
        ENDIF (_CONCRETE_TLS_VERIFY)

        IF (_CONCRETE_TLS_CAINFO)
            LIST(APPEND fetchContentParamters TLS_CAINFO ${_CONCRETE_TLS_CAINFO})
        ENDIF (_CONCRETE_TLS_CAINFO)

        IF (_CONCRETE_NETRC_LEVEL)
            LIST(APPEND fetchContentParamters NETRC ${_CONCRETE_NETRC_LEVEL})
        ENDIF (_CONCRETE_NETRC_LEVEL)

        IF (_CONCRETE_NETRC_FILE)
            LIST(APPEND fetchContentParamters NETRC_FILE ${_CONCRETE_NETRC_FILE})
        ENDIF (_CONCRETE_NETRC_FILE)
    # GIT Type
    ELSE(${_CONCRETE_PACKAGE_TYPE} STREQUAL "URL")
        IF (_CONCRETE_REPOSITORY)
            SET(repository ${_CONCRETE_REPOSITORY})
        ELSE()
            MESSAGE(FATAL_ERROR "can't find repository url")
        ENDIF(_CONCRETE_REPOSITORY)

        IF(_CONCRETE_COMMIT_TAG)
            SET(tag ${_CONCRETE_COMMIT_TAG})
        ELSE()
            MESSAGE(FATAL_ERROR "can't find repository tag, branch or commit")
        ENDIF(_CONCRETE_COMMIT_TAG)

        IF (${_CONCRETE_PACKAGE_TYPE} STREQUAL "GIT")            
            LIST(APPEND fetchContentParamters GIT_REPOSITORY ${repository} GIT_TAG ${tag} GIT_PROGRESS ON)

            IF(_CONCRETE_GIT_REMOTE_NAME)
                LIST(APPEND fetchContentParamters GIT_REMOTE_NAME ${_CONCRETE_GIT_REMOTE_NAME})
            ENDIF(_CONCRETE_GIT_REMOTE_NAME)

            IF(_CONCRETE_GIT_SUBMODULES)
                LIST(APPEND fetchContentParamters GIT_SUBMODULES ${_CONCRETE_GIT_SUBMODULES})
            ENDIF(_CONCRETE_GIT_SUBMODULES)

            IF(_CONCRETE_GIT_SUBMODULES_RECURSE)
                LIST(APPEND fetchContentParamters GIT_SUBMODULES_RECURSE ${_CONCRETE_GIT_SUBMODULES_RECURSE})
            ENDIF(_CONCRETE_GIT_SUBMODULES_RECURSE)

            IF(_CONCRETE_GIT_SHALLOW)
               LIST(APPEND fetchContentParamters GIT_SHALLOW ${_CONCRETE_GIT_SHALLOW})
            ENDIF(_CONCRETE_GIT_SHALLOW)

            IF(_CONCRETE_GIT_CONFIG)
               LIST(APPEND fetchContentParamters GIT_CONFIG ${_CONCRETE_GIT_CONFIG})
            ENDIF(_CONCRETE_GIT_CONFIG)
        ELSEIF(${_CONCRETE_PACKAGE_TYPE} STREQUAL "SVN")
            LIST(APPEND fetchContentParamters SVN_REPOSITORY ${repository} SVN_REVISION "-r${tag}")

            IF (_CONCRETE_USERNAME)
                LIST(APPEND fetchContentParamters SVN_USERNAME ${_CONCRETE_USERNAME})
            ENDIF(_CONCRETE_USERNAME)

            IF (_CONCRETE_PASSWORD)
                LIST(APPEND fetchContentParamters SVN_PASSWORD ${_CONCRETE_PASSWORD})
            ENDIF(_CONCRETE_PASSWORD)

            IF (_CONCRETE_SVN_TRUST_CERT)
                LIST(APPEND fetchContentParamters SVN_TRUST_CERT ${_CONCRETE_SVN_TRUST_CERT})
            ENDIF(_CONCRETE_SVN_TRUST_CERT)
        ELSEIF(${_CONCRETE_PACKAGE_TYPE} STREQUAL "HG")
            LIST(APPEND fetchContentParamters HG_REPOSITORY ${repository} HG_TAG ${tag})
        ELSEIF(${_CONCRETE_PACKAGE_TYPE} STREQUAL "CVS")
            LIST(APPEND fetchContentParamters CVS_REPOSITORY ${repository} CVS_TAG ${tag})

            IF(_CONCRETE_CVS_MODULE)
                LIST(APPEND fetchContentParamters CVS_MODULE ${_CONCRETE_CVS_MODULE})
            ENDIF(_CONCRETE_CVS_MODULE)
        ENDIF(${_CONCRETE_PACKAGE_TYPE} STREQUAL "GIT")
    ENDIF(${_CONCRETE_PACKAGE_TYPE} STREQUAL "URL")

    IF (_CONCRETE_DOWNLOAD_COMMAND)
        LIST(APPEND fetchContentParamters DOWNLOAD_COMMAND ${_CONCRETE_DOWNLOAD_COMMAND})
    ENDIF(_CONCRETE_DOWNLOAD_COMMAND)

    IF (_CONCRETE_UPDATE_PATCH_OPTIONS)
        LIST(APPEND fetchContentParamters ${_CONCRETE_UPDATE_PATCH_OPTIONS})
    ENDIF(_CONCRETE_UPDATE_PATCH_OPTIONS)

    IF(_CONCRETE_SOURCE_DIR)
        SET(sourceDirectory ${_CONCRETE_SOURCE_DIR})
    ELSE()
        SET(sourceDirectory ${CONCRETE_PROJECT_PACKAGE_CONFIG_DIRECTORY}/${packageName}/source)
    ENDIF(_CONCRETE_SOURCE_DIR)

    IF (_CONCRETE_BINARY_DIR)
        SET(binaryDirectory ${_CONCRETE_BINARY_DIR})
    ELSE()
        SET(binaryDirectory ${CONCRETE_PROJECT_PACKAGE_CONFIG_DIRECTORY}/${packageName}/install)
    ENDIF(_CONCRETE_BINARY_DIR)

    IF (_CONCRETE_SUBBUILD_DIR)
        SET(subBuildDirectory ${_CONCRETE_SUBBUILD_DIR})
    ELSE()
        SET(subBuildDirectory ${CONCRETE_PROJECT_PACKAGE_CONFIG_DIRECTORY}/${packageName}/cmake-project)
    ENDIF(_CONCRETE_SUBBUILD_DIR)

    LIST(APPEND fetchContentParamters 
        SOURCE_DIR ${sourceDirectory}
        BINARY_DIR ${binaryDirectory}
        SUBBUILD_DIR ${subBuildDirectory}    
        )
    
    FetchContent_Declare(${packageName} ${fetchContentParamters})
ENDFUNCTION(__fetchContent)

FUNCTION(__executeProcess PACKAGE_NAME RESULT)
    SET(options DOWNLOAD_ONLY)

    SET(singleValueKey WORKING_DIRECTORY)

    SET(mulitValueKey 
            COMMANDS            
        )

    STRING(TOLOWER ${packageName} lcPackageName)

    SET(newArgs ${ARGN})

    STRING(REPLACE "PACKAGE_SOURCE_DIR" "${${lcPackageName}_SOURCE_DIR}" newArgs ${newArgs})
    STRING(REPLACE "PACKAGE_BINARY_DIR" "${${lcPackageName}_BINARY_DIR}" newArgs ${newArgs})
    STRING(REPLACE "PACKAGE_SUBBUILD_DIR" "${${lcPackageName}_SUBBUILD_DIR}" newArgs ${newArgs})
    
    CONCRETE_METHOD_SEPARATE_ARGUMENTS(${newArgs} newArgs COMMAND_MODE "Windows")

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${newArgs}
    )

    IF (_CONCRETE_WORKING_DIRECTORY)
        SET(workingDirectory ${_CONCRETE_WORKING_DIRECTORY})
    ELSE()
        SET(workingDirectory ${${lcPackageName}_SOURCE_DIR})
    ENDIF(_CONCRETE_WORKING_DIRECTORY)

    IF (_CONCRETE_COMMANDS)
        SET(command ${_CONCRETE_COMMANDS})

        MESSAGE(STATUS ${command})
        
        EXECUTE_PROCESS(
            COMMAND ${command}
            WORKING_DIRECTORY "${workingDirectory}"
            RESULT_VARIABLE result
        )

        IF (${result} STREQUAL "0")            
            SET(${RESULT} ${result} PARENT_SCOPE)
        ELSE()
            MESSAGE(FATAL_ERROR "${result}")
        ENDIF()
    ENDIF(_CONCRETE_COMMANDS)
ENDFUNCTION(__executeProcess)

FUNCTION(__DownloadAndBuildPackage PACKAGE_NAME)
    SET(options 
        DOWNLOAD_ONLY          
        )

    SET(singleValueKey VERSION BUILD_TOOLSET)

    SET(mulitValueKey 
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

    IF (_CONCRETE_BUILD_TOOLSET)
        SET(buildToolset ${_CONCRETE_BUILD_TOOLSET})
    ELSE()
        SET(buildToolset "None")
    ENDIF()

    SET(packageName ${PACKAGE_NAME})

    IF (_CONCRETE_VERSION)
        GET_PROPERTY(packageVersionDefined CACHE CONCRETE_PACKAGE_MANAGER_${packageName}_VERSION PROPERTY VALUE SET)

        IF (${packageVersionDefined})
            GET_PROPERTY(packageVersion CACHE CONCRETE_PACKAGE_MANAGER_${packageName}_VERSION PROPERTY VALUE)

            IF (NOT ${packageVersion} VERSION_EQUAL ${_CONCRETE_VERSION})
                GET_PROPERTY(packageBuildedDefined CACHE CONCRETE_PACKAGE_MANAGER_${packageName}_BUILDED PROPERTY VALUE SET)

                IF (${packageBuildedDefined})
                    SET_PROPERTY(CACHE CONCRETE_PACKAGE_MANAGER_${packageName}_BUILDED PROPERTY VALUE FALSE) 
                ELSE()   
                    SET(CONCRETE_PACKAGE_MANAGER_${packageName}_BUILDED FALSE CACHE BOOL "${packageName} builded flag" FORCE)
                ENDIF()
            ENDIF()

            SET_PROPERTY(CACHE CONCRETE_PACKAGE_MANAGER_${packageName}_VERSION PROPERTY VALUE ${_CONCRETE_VERSION})
        ELSE()
            SET(CONCRETE_PACKAGE_MANAGER_${packageName}_VERSION ${_CONCRETE_VERSION} CACHE INTERNAL "${packageName} version" FORCE)
        ENDIF(${packageVersionDefined})
    ENDIF(_CONCRETE_VERSION)

    IF (_CONCRETE_DOWNLOAD_OPTIONS)
        __fetchContent(${packageName} ${_CONCRETE_DOWNLOAD_OPTIONS})

        STRING(TOLOWER ${packageName} lcPackageName)

        FetchContent_GetProperties(${packageName})

        IF (NOT ${lcPackageName}_POPULATED)
            FetchContent_Populate(${packageName})

            SET(${lcPackageName}_SOURCE_DIR ${${lcPackageName}_SOURCE_DIR} PARENT_SCOPE)
            SET(${lcPackageName}_BINARY_DIR ${${lcPackageName}_BINARY_DIR} PARENT_SCOPE)
            SET(${lcPackageName}_SUBBUILD_DIR ${${lcPackageName}_SUBBUILD_DIR} PARENT_SCOPE)

            GET_PROPERTY(packageBuildedDefined CACHE CONCRETE_PACKAGE_MANAGER_${packageName}_BUILDED PROPERTY VALUE SET)

            IF (NOT ${packageBuildedDefined})
                SET(CONCRETE_PACKAGE_MANAGER_${packageName}_BUILDED FALSE CACHE BOOL "${packageName} builded flag" FORCE)
            ENDIF()

            IF (${_CONCRETE_DOWNLOAD_ONLY})
                RETURN()
            ENDIF(${_CONCRETE_DOWNLOAD_ONLY})

            IF (NOT ${CONCRETE_PACKAGE_MANAGER_${packageName}_BUILDED})
                IF (${buildToolset} STREQUAL "Customize")
                    IF (_CONCRETE_BUILD_COMMANDS)
                        SET(commandsList "${_CONCRETE_BUILD_COMMANDS}")
                    ELSE()
                        MESSAGE(WARNING "no build commands option found, may set BUILD_TOOLSET option None")
                    ENDIF()
                ElSEIF(${buildToolset} STREQUAL "CMake")
                    __CMakeStandardBuildCommands(commandsList ${_CONCRETE_CMAKE_STANDARD_BUILD_OPTIONS})
                ENDIF()

                # Build Step
                IF (_CONCRETE_CONFIGURE_COMMANDS)
                    FOREACH(var ${_CONCRETE_CONFIGURE_COMMANDS})
                        CONCRETE_METHOD_PROJECT_CONFIGURE_FILE(${var})
                    ENDFOREACH()                    
                ENDIF(_CONCRETE_CONFIGURE_COMMANDS)

                IF (_CONCRETE_CREATE_DIRECTORYS)
                    FOREACH(var ${_CONCRETE_CREATE_DIRECTORYS})
                        STRING(REPLACE "PACKAGE_SOURCE_DIR" "${${lcPackageName}_SOURCE_DIR}" var ${var})
                        STRING(REPLACE "PACKAGE_BINARY_DIR" "${${lcPackageName}_BINARY_DIR}" var ${var})
                        STRING(REPLACE "PACKAGE_SUBBUILD_DIR" "${${lcPackageName}_SUBBUILD_DIR}" var ${var})

                        CONCRETE_METHOD_CREATE_DIRECTORYS(DIRECTORYS ${var} ABSOULT_PATH)
                    ENDFOREACH()                    
                ENDIF()

                FOREACH(var ${commandsList})
                    __executeProcess(${packageName} result ${var})

                    IF (NOT ${result} STREQUAL "0")
                        BREAK()
                    ENDIF()
                ENDFOREACH()                    

                IF (${result} STREQUAL "0")
                    SET_PROPERTY(CACHE CONCRETE_PACKAGE_MANAGER_${packageName}_BUILDED PROPERTY VALUE TRUE)    
                ENDIF()
            ENDIF(NOT ${CONCRETE_PACKAGE_MANAGER_${packageName}_BUILDED})
        ENDIF(NOT ${lcPackageName}_POPULATED)
    ENDIF(_CONCRETE_DOWNLOAD_OPTIONS)

ENDFUNCTION(__DownloadAndBuildPackage)

FUNCTION(__CMakeStandardBuildCommands CommandsOutput)
    SET(options)

    SET(singleValueKey ROOT_DIR INSTALL_DIR
        CMAKE_GENERATOR CMAKE_GENERATOR_PLATFORM CMAKE_GENERATOR_TOOLSET CMAKE_SYSTEM_VERSION)  

    SET(mulitValueKey CMAKE_CONFIGURE_TYPES)

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    IF (_CONCRETE_ROOT_DIR)
        SET(rootDir ${_CONCRETE_ROOT_DIR})
    ELSE()
        SET(rootDir "${${lcPackageName}_SOURCE_DIR}")
    ENDIF()

    IF (_CONCRETE_INSTALL_DIR)
        SET(installDir ${_CONCRETE_INSTALL_DIR})
    ELSE()
        SET(installDir "${${lcPackageName}_BINARY_DIR}")
    ENDIF()

    SET(dirs ${rootDir} ${installDir})

    FOREACH(var ${dirs})
        STRING(REPLACE "PACKAGE_SOURCE_DIR" "${${lcPackageName}_SOURCE_DIR}" var ${var})
        STRING(REPLACE "PACKAGE_BINARY_DIR" "${${lcPackageName}_BINARY_DIR}" var ${var})
        STRING(REPLACE "PACKAGE_SUBBUILD_DIR" "${${lcPackageName}_SUBBUILD_DIR}" var ${var})        
    ENDFOREACH()
    
    CONCRETE_METHOD_UUID(uuid)
    
    SET(buildDir "${rootDir}/build-${uuid}")            

    CONCRETE_METHOD_CREATE_DIRECTORYS(DIRECTORYS ${buildDir} ABSOULT_PATH)

    SET(generatorCommand "COMMANDS cmake ")

    IF (_CONCRETE_CMAKE_GENERATOR)
        STRING(APPEND generatorCommand "-G '${_CONCRETE_CMAKE_GENERATOR}' ")
    ELSE()
        STRING(APPEND generatorCommand "-G '${CMAKE_GENERATOR}' ")
    ENDIF()

    IF (_CONCRETE_CMAKE_GENERATOR_PLATFORM)
        STRING(APPEND generatorCommand "-A '${_CONCRETE_CMAKE_GENERATOR_PLATFORM}' ")
    ELSE()
        STRING(APPEND generatorCommand "-A '${CMAKE_GENERATOR_PLATFORM}' ")
    ENDIF()

    IF (_CONCRETE_CMAKE_GENERATOR_TOOLSET)
        STRING(APPEND generatorCommand "-DCMAKE_GENERATOR_TOOLSET=${_CONCRETE_CMAKE_GENERATOR_TOOLSET} ")
    ELSE()
        GET_PROPERTY(generatorToolsetDefined CACHE CMAKE_GENERATOR_TOOLSET PROPERTY VALUE SET)

        IF (${generatorToolsetDefined})
            IF (NOT ${CMAKE_GENERATOR_TOOLSET} STREQUAL "")
                STRING(APPEND generatorCommand "-DCMAKE_GENERATOR_TOOLSET=${CMAKE_GENERATOR_TOOLSET} ")
            ENDIF()
        ENDIF()
    ENDIF()

    IF (_CONCRETE_CMAKE_SYSTEM_VERSION)
        STRING(APPEND generatorCommand "-DCMAKE_SYSTEM_VERSION=${_CONCRETE_CMAKE_SYSTEM_VERSION} ")
    ELSE()
        GET_PROPERTY(systemVersionDefined CACHE CMAKE_SYSTEM_VERSION PROPERTY VALUE SET)

        IF (${systemVersionDefined})
            STRING(APPEND generatorCommand "-DCMAKE_SYSTEM_VERSION=${CMAKE_SYSTEM_VERSION} ")
        ENDIF()
    ENDIF()

    STRING(APPEND generatorCommand "./.. WORKING_DIRECTORY ${buildDir}")

    LIST(APPEND commands ${generatorCommand})

    IF (_CONCRETE_CMAKE_CONFIGURE_TYPES)
        SET(configureTypes ${_CONCRETE_CMAKE_CONFIGURE_TYPES})
    ELSE()
        SET(configureTypes Debug Release)
    ENDIF()

    FOREACH(var ${configureTypes})
        SET(buildCommand "COMMANDS cmake --build . --config ${var} WORKING_DIRECTORY ${buildDir}")

        LIST(APPEND commands ${buildCommand})
    ENDFOREACH()    

    FOREACH(var ${configureTypes})
        SET(installCommand "COMMANDS cmake --install . --config ${var} --prefix ${installDir} WORKING_DIRECTORY ${buildDir}")

        LIST(APPEND commands ${installCommand})
    ENDFOREACH() 

    SET(${CommandsOutput} ${commands} PARENT_SCOPE)
ENDFUNCTION(__CMakeStandardBuildCommands)

FUNCTION(CONCRETE_METHOD_SET_PACKAGE_MANAGER_PROPERTY)
    SET(singleValueProperty VERBOSE)
    SET(mulitValueProperty)

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueProperty}"
        "${mulitValueProperty}"
        ${ARGN}
    )

    IF(_CONCRETE_VERBOSE)
        IF (${_CONCRETE_VERBOSE})
            SET(FETCHCONTENT_QUIET OFF PARENT_SCOPE)
        ELSE()
            SET(FETCHCONTENT_QUIET ON PARENT_SCOPE)
        ENDIF(${_CONCRETE_VERBOSE})
    ENDIF(_CONCRETE_VERBOSE)
ENDFUNCTION(CONCRETE_METHOD_SET_PACKAGE_MANAGER_PROPERTY)

FUNCTION(CONCRETE_METHOD_FETCH_PACKAGE PACKAGE_NAME)
    SET(options USE_BINARY_DIR_AS_PACKAGE_ROOT)

    SET(singleValueKey PACKAGE_ROOT)

    SET(mulitValueKey)

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    __DownloadAndBuildPackage(${PACKAGE_NAME} ${_CONCRETE_UNPARSED_ARGUMENTS})

    STRING(TOLOWER ${PACKAGE_NAME} lcPackageName)

    IF(${_CONCRETE_USE_BINARY_DIR_AS_PACKAGE_ROOT})
        SET(pakcageRoot ${${lcPackageName}_BINARY_DIR})
    ElSE()
        IF(_CONCRETE_PACKAGE_ROOT)
            SET(pakcageRoot ${_CONCRETE_PACKAGE_ROOT})
        ELSE()
            SET(pakcageRoot ${${lcPackageName}_SOURCE_DIR})
        ENDIF()
    ENDIF()

    LIST(APPEND CMAKE_PREFIX_PATH ${pakcageRoot})

    SET(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} PARENT_SCOPE)
ENDFUNCTION(CONCRETE_METHOD_FETCH_PACKAGE)

FUNCTION(CONCRETE_METHOD_FIND_PACKAGE PACKAGE_NAME)
    SET(options)

    SET(singleValueKey)

    SET(mulitValueKey PACKAGES FIND_PACKAGE_ARGUMENTS)

    CMAKE_PARSE_ARGUMENTS(
        _ "${options}" "${singleValueKey}" "${mulitValueKey}"
        ${ARGN}
    )

    IF (_PACKAGES)
        FOREACH(var ${_PACKAGES})
            STRING(UPPER ${var} ucPackage)
            SET(mulitValueKey ${mulitValueKey} ${ucPackage}_FIND_PACKAGE_ARGUMENTS)
        ENDFOREACH()
    ENDIF()

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE "${options}" "${singleValueKey}" "${mulitValueKey}"
        ${ARGN}
    )

    CONCRETE_METHOD_FETCH_PACKAGE(${PACKAGE_NAME} ${_CONCRETE_UNPARSED_ARGUMENTS})

    IF (_CONCRETE_PACKAGES)
        FOREACH(var ${_CONCRETE_PACKAGES})
            STRING(UPPER ${var} ucPackage)
            FIND_PACKAGE(${var} ${_CONCRETE_${ucPackage}_FIND_PACKAGE_ARGUMENTS})

            SET(${var}_FOUND ${${var}_FOUND} PARENT_SCOPE)
        ENDFOREACH()
    ELSE()
        FIND_PACKAGE(${PACKAGE_NAME} ${_CONCRETE_FIND_PACKAGE_ARGUMENTS})

        SET(${PACKAGE_NAME}_FOUND ${${PACKAGE_NAME}_FOUND} PARENT_SCOPE)
    ENDIF()
ENDFUNCTION(CONCRETE_METHOD_FIND_PACKAGE)