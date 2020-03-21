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

FUNCTION(__CONCRETE_FETCH_CONTENT PACKAGE_NAME)
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
            ${urlDownloadSingleValueKey}
            ${gitCloneSingleValueKey}
            ${svnCloneSingleValueKey}
            ${cvsCloneSingleValueKey}
        )

    SET(urlDownloadMulitValueKey
            URL
            HTTP_HEADER
        )

    SET(gitCloneMulitValueKey
            GIT_SUBMODULES 
            GIT_CONFIG
        )

    SET(mulitValueKey
        ${urlDownloadMulitValueKey}
        ${gitCloneMulitValueKey}
        )

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    SET(packageName ${PACKAGE_NAME})

    IF(NOT DEFINED _CONCRETE_PACKAGE_TYPE)
        MESSAGE(FATAL_ERROR "can't find package type")
    ENDIF(NOT DEFINED _CONCRETE_PACKAGE_TYPE)

    SET(fetchContentParamters)

    # URL Type
    IF(${_CONCRETE_PACKAGE_TYPE} STREQUAL "URL")
        IF(_CONCRETE_URL)
            SET(packageTarget ${_CONCRETE_URL})
        ELSE()
            MESSAGE(FATAL_ERROR "can't find url address")
        ENDIF(_CONCRETE_URL)    

        LIST(APPEND fetchContentParamters ${packageName} URL ${packageTarget})

        IF(_CONCRETE_URL_HASH)
            LIST(APPEND fetchContentParamters URL_HASH ${_CONCRETE_URL_HASH})
        ENDIF(_CONCRETE_URL_HASH)

        IF(_CONCRETE_TARGET_NAME)
            LIST(APPEND fetchContentParamters DOWNLOAD_NAME ${_CONCRETE_TARGET_NAME})
        ENDIF(_CONCRETE_TARGET_NAME)

        IF (_CONCRETE_TIMEOUT)
            SET(timeout ${_CONCRETE_TIMEOUT})
        ELSE()
            SET(timeout 5)
        ENDIF(_CONCRETE_TIMEOUT)

        LIST(APPEND fetchContentParamters TIMEOUT ${timeout})

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

ENDFUNCTION(__CONCRETE_FETCH_CONTENT)

FUNCTION(CONCRETE_FIND_PACKAGE PACKAGE_NAME)
    SET(options)

    SET(singleValueKey)

    SET(mulitValueKey FIND_PACKAGE_ARGUMENTS)

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    __CONCRETE_FETCH_CONTENT(${ARGN})

ENDFUNCTION(CONCRETE_FIND_PACKAGE)

MACRO(CONCRETE_ENABLE_PACKAGE_MANAGER_VERBOSE ENABLE)
    SET(FETCHCONTENT_QUIET ${ENABLE})
ENDMACRO(CONCRETE_ENABLE_PACKAGE_MANAGER_VERBOSE)