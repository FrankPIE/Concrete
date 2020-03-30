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
        SET(subBuildDirectory ${CONCRETE_PROJECT_PACKAGE_CONFIG_DIRECTORY}/${packageName}/middle)
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

    SEPARATE_ARGUMENTS(newArgs)

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${newArgs}
    )

    IF (_CONCRETE_WORKING_DIRECTORY)
        SET(workingDirectory ${${lcPackageName}_SOURCE_DIR})
    ELSE()
        SET(workingDirectory ${_CONCRETE_WORKING_DIRECTORY})
    ENDIF(_CONCRETE_WORKING_DIRECTORY)

    IF (_CONCRETE_COMMANDS)
        SET(command ${_CONCRETE_COMMANDS})

        MESSAGE(STATUS "Command:${command}")
        
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
    SET(options DOWNLOAD_ONLY)

    SET(singleValueKey VERSION)

    SET(mulitValueKey 
            DOWNLOAD_OPTIONS 
            BUILD_COMMANDS 
            CONFIGURE_COMMANDS
        )

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

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

            IF (${DOWNLOAD_ONLY})
                RETURN()
            ENDIF(${DOWNLOAD_ONLY})

            IF (NOT ${CONCRETE_PACKAGE_MANAGER_${packageName}_BUILDED})
                MESSAGE(STATUS "Build")
                # Build Step
                IF (_CONCRETE_CONFIGURE_COMMANDS)
                    FOREACH(var ${_CONCRETE_BUILD_COMMANDS})
                        CONCRETE_METHOD_PROJECT_CONFIGURE_FILE(${var})
                    ENDFOREACH()                    
                ENDIF(_CONCRETE_CONFIGURE_COMMANDS)

                IF (_CONCRETE_BUILD_COMMANDS)
                    FOREACH(var ${_CONCRETE_BUILD_COMMANDS})
                        __executeProcess(${packageName} result ${var})

                        IF (NOT ${result} STREQUAL "0")
                            BREAK()
                        ENDIF()
                    ENDFOREACH()                    

                    IF (${result} STREQUAL "0")
                        SET_PROPERTY(CACHE CONCRETE_PACKAGE_MANAGER_${packageName}_BUILDED PROPERTY VALUE TRUE)    
                    ENDIF()
                ENDIF(_CONCRETE_BUILD_COMMANDS)
            ENDIF(NOT ${CONCRETE_PACKAGE_MANAGER_${packageName}_BUILDED})
        ENDIF(NOT ${lcPackageName}_POPULATED)
    ENDIF(_CONCRETE_DOWNLOAD_OPTIONS)

ENDFUNCTION(__DownloadAndBuildPackage)

FUNCTION(CONCRETE_METHOD_FIND_PACKAGE PACKAGE_NAME)
    SET(options USE_BINARY_DIR_AS_PACKAGE_ROOT)

    SET(singleValueKey PACKAGE_ROOT)

    SET(mulitValueKey FIND_PACKAGE_ARGUMENTS)

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    __DownloadAndBuildPackage(${PACKAGE_NAME} ${ARGN})

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

    FIND_PACKAGE(${PACKAGE_NAME} ${_CONCRETE_FIND_PACKAGE_ARGUMENTS})
ENDFUNCTION(CONCRETE_METHOD_FIND_PACKAGE)

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