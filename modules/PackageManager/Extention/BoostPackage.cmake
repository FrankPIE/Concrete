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

MACRO(__BoostHashTable)
    SET(Boost_1_72_0_HASH_SHA256 "c66e88d5786f2ca4dbebb14e06b566fb642a1a6947ad8cc9091f9f445134143f")        
    SET(Boost_1_71_0_HASH_SHA256 "96b34f7468f26a141f6020efb813f1a2f3dfb9797ecf76a7d7cbd843cc95f5bd")        
    SET(Boost_1_70_0_HASH_SHA256 "882b48708d211a5f48e60b0124cf5863c1534cd544ecd0664bb534a4b5d506e9")        
    SET(Boost_1_69_0_HASH_SHA256 "9a2c2819310839ea373f42d69e733c339b4e9a19deab6bfec448281554aa4dbb")        
    SET(Boost_1_68_0_HASH_SHA256 "da3411ea45622579d419bfda66f45cd0f8c32a181d84adfa936f5688388995cf")        
ENDMACRO(__BoostHashTable)

FUNCTION(__BoostGetToolset TOOLSET TOOLSET_VERSION)
    IF(MSVC)
        SET(${TOOLSET} msvc PARENT_SCOPE)

        GET_PROPERTY(toolsetDefined CACHE CMAKE_GENERATOR_TOOLSET PROPERTY VALUE DEFINED)
        
        IF (${toolsetDefined})            
            GET_PROPERTY(toolset CACHE CMAKE_GENERATOR_TOOLSET PROPERTY VALUE)

            IF (${toolset} STREQUAL "v100")     # VS2010
                SET(${TOOLSET_VERSION} "10.0" PARENT_SCOPE)
            ELSEIF(${toolset} STREQUAL "v110")  # VS2012
                SET(${TOOLSET_VERSION} "11.0" PARENT_SCOPE)
            ELSEIF(${toolset} STREQUAL "v120")  # VS2013
                SET(${TOOLSET_VERSION} "12.0" PARENT_SCOPE)
            ELSEIF(${toolset} STREQUAL "v140")  # VS2015
                SET(${TOOLSET_VERSION} "14.0" PARENT_SCOPE)
            ELSEIF(${toolset} STREQUAL "v141")  # VS2017
                SET(${TOOLSET_VERSION} "14.1" PARENT_SCOPE)
            ELSEIF(${toolset} STREQUAL "v142")  # VS2019
                SET(${TOOLSET_VERSION} "14.2" PARENT_SCOPE)
            ELSE()
                MESSAGE(FATAL_ERROR "unknown msvc toolset version")
            ENDIF()
        ELSE()
            GET_PROPERTY(toolset CACHE CMAKE_GENERATOR PROPERTY VALUE)

            IF (${toolset} STREQUAL "Visual Studio 9 2008")     # VS2008
                SET(${TOOLSET_VERSION} "9.0" PARENT_SCOPE)
            ELSEIF(${toolset} STREQUAL "Visual Studio 10 2010")  # VS2010
                SET(${TOOLSET_VERSION} "10.0" PARENT_SCOPE)
            ELSEIF(${toolset} STREQUAL "Visual Studio 11 2012")  # VS2012
                SET(${TOOLSET_VERSION} "11.0" PARENT_SCOPE)
            ELSEIF(${toolset} STREQUAL "Visual Studio 12 2013")  # VS2013
                SET(${TOOLSET_VERSION} "12.0" PARENT_SCOPE)
            ELSEIF(${toolset} STREQUAL "Visual Studio 14 2015")  # VS2015
                SET(${TOOLSET_VERSION} "14.0" PARENT_SCOPE)
            ELSEIF(${toolset} STREQUAL "Visual Studio 15 2017")  # VS2017
                SET(${TOOLSET_VERSION} "14.1" PARENT_SCOPE)
            ELSEIF(${toolset} STREQUAL "Visual Studio 16 2019")  # VS2019
                SET(${TOOLSET_VERSION} "14.2" PARENT_SCOPE)
            ELSE()
                MESSAGE(FATAL_ERROR "unknown msvc toolset version")
            ENDIF()    
        ENDIF()
    ENDIF(MSVC)    
ENDFUNCTION(__BoostGetToolset)

FUNCTION(CONCRETE_METHOD_FIND_BOOST_PACKAGE)
    SET(options STATIC SHARED SINGLE_THREADING MULTI_THREADING RUNTIME_LINK_STATIC)

    SET(singleValueKey
        TARGET_NAME 
        VERSION
        TOOLSET
        TOOLSET_VERSION
        DOWNLOAD_METHOD
        )

    SET(mulitValueKey WITH_BUILD WITHOUT_BUILD FIND_PACKAGE_ARGUMENTS)

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE_BOOST
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    __BoostHashTable()

    IF(_CONCRETE_BOOST_TARGET_NAME)
        SET(targetPackageName ${_CONCRETE_BOOST_TARGET_NAME})
    ELSE()
        SET(targetPackageName Boost)
    ENDIF(_CONCRETE_BOOST_TARGET_NAME)

    IF(_CONCRETE_BOOST_VERSION)
        SET(targetPackageVersion ${_CONCRETE_BOOST_VERSION})
    ELSE()
        SET(targetPackageVersion "1.72.0")
    ENDIF(_CONCRETE_BOOST_VERSION)

    SET(linkOptions)

    IF (_CONCRETE_BOOST_STATIC)        
        STRING(APPEND linkOptions "link=static ")
    ENDIF()

    IF (_CONCRETE_BOOST_SHARED)        
        STRING(APPEND linkOptions "link=shared")
    ENDIF()

    SET(threadingOptions)

    IF (_CONCRETE_BOOST_SINGLE_THREADING)
        STRING(APPEND threadingOptions "threading=single ")
    ENDIF()

    IF (_CONCRETE_BOOST_MULTI_THREADING)
        STRING(APPEND threadingOptions "threading=multi ")
    ENDIF()

    SET(withBuild)
    IF(_CONCRETE_BOOST_WITH_BUILD)
        FOREACH(var ${_CONCRETE_BOOST_WITH_BUILD})
            STRING(APPEND withBuild "--without-${var}")
        ENDFOREACH()
    ENDIF()

    SET(withoutBuild)
    IF(_CONCRETE_BOOST_WITHOUT_BUILD)
        FOREACH(var ${_CONCRETE_BOOST_WITHOUT_BUILD})
            STRING(APPEND withoutBuild "--without-${var}")
        ENDFOREACH()
    ENDIF()

    SET(runtimeLinkOptions)

    IF(_CONCRETE_BOOST_RUNTIME_LINK_STATIC)
        STRING(APPEND runtimeLinkOptions "runtime-link=static ")
    ENDIF()

    STRING(REPLACE "." "_" boostPackageName ${targetPackageVersion})

    SET(boostPackageURLS 
        "https://dl.bintray.com/boostorg/release/${targetPackageVersion}/source/boost_${boostPackageName}.tar.gz"
        "https://github.com/boostorg/boost/archive/boost-${targetPackageVersion}.tar.gz"
        "https://sourceforge.net/projects/boost/files/boost/${targetPackageVersion}/boost_${boostPackageName}.tar.gz"
        "http://mirror.nienbo.com/boost/${targetPackageVersion}/boost_${boostPackageName}.tar.gz"
    )

    IF (DEFINED Boost_${boostPackageName}_HASH_SHA256)
        SET(hashCheck URL_HASH SHA256=${Boost_${boostPackageName}_HASH_SHA256})
    ENDIF()

    IF (MSVC)
        SET(bootstrap bootstrap.bat)
    ELSE()
        SET(bootstrap bootstrap.sh)
    ENDIF(MSVC)

    __BoostGetToolset(toolset toolsetVersion)

    IF (_CONCRETE_BOOST_TOOLSET)
        SET(toolset ${_CONCRETE_TOOLSET})
    ENDIF()

    IF (_CONCRETE_BOOST_TOOLSET_VERSION)
        SET(toolsetVersion ${_CONCRETE_TOOLSET_VERSION})
    ENDIF()

    IF (${CONCRETE_PROJECT_COMPILER_TARGET} STREQUAL "x86")
        SET(addressModel "32")
    ELSEIF(${CONCRETE_PROJECT_COMPILER_TARGET} STREQUAL "x64")
        SET(addressModel "64")
    ENDIF()

    SET(downloadOptions)

    IF(_CONCRETE_BOOST_DOWNLOAD_METHOD)
        IF(${_CONCRETE_BOOST_DOWNLOAD_METHOD} STREQUAL "URL")
            SET(downloadMethod "URL")
        ELSEIF(${_CONCRETE_BOOST_DOWNLOAD_METHOD} STREQUAL "GIT")
            SET(downloadMethod "GIT")
        ENDIF()
    ELSE()
        SET(downloadMethod "URL")
    ENDIF()

    IF(${downloadMethod} STREQUAL "URL")
        SET(downloadOptions PACKAGE_TYPE URL LINKS ${boostPackageURLS} ${hashCheck})
    ELSEIF(${downloadMethod} STREQUAL "GIT")
        SET(downloadOptions PACKAGE_TYPE GIT REPOSITORY https://github.com/boostorg/boost.git COMMIT_TAG boost-${targetPackageVersion} GIT_SUBMODULES_RECURSE ON)
    ELSE()
        MESSAGE(FATAL_ERROR "unsupport method")
    ENDIF()

    CONCRETE_METHOD_FIND_PACKAGE(
        ${targetPackageName}

        VERSION ${targetPackageVersion}
        
        FETCH_PACKAGE_ARGUMENTS
            DOWNLOAD_BUILD_STEP_OPTIONS
                BUILD_TOOLSET "Customize"

                DOWNLOAD_OPTIONS
                    ${downloadOptions}
                    
                BUILD_COMMANDS
                    "COMMANDS ${bootstrap} WORKING_DIRECTORY PACKAGE_SOURCE_DIR"
                    "COMMANDS b2 stage ${linkOptions} ${threadingOptions} ${runtimeLinkOptions} toolset=${toolset}-${toolsetVersion} address-model=${addressModel} ${withBuild} ${withoutBuild} WORKING_DIRECTORY PACKAGE_SOURCE_DIR"
                    "COMMANDS b2 install ${linkOptions} ${threadingOptions} ${runtimeLinkOptions} --prefix=PACKAGE_BINARY_DIR address-model=${addressModel} ${withBuild} ${withoutBuild} WORKING_DIRECTORY PACKAGE_SOURCE_DIR"

        FIND_PACKAGE_ARGUMENTS
            ${_CONCRETE_BOOST_FIND_PACKAGE_ARGUMENTS}
    )

    SET(Boost_FOUND ${Boost_FOUND} PARENT_SCOPE)

ENDFUNCTION(CONCRETE_METHOD_FIND_BOOST_PACKAGE)

