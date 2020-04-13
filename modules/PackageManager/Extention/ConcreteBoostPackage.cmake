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

macro(__concrete_boost_hash_table)
    set(Boost_1_72_0_HASH_SHA256 "c66e88d5786f2ca4dbebb14e06b566fb642a1a6947ad8cc9091f9f445134143f")        
    set(Boost_1_71_0_HASH_SHA256 "96b34f7468f26a141f6020efb813f1a2f3dfb9797ecf76a7d7cbd843cc95f5bd")        
    set(Boost_1_70_0_HASH_SHA256 "882b48708d211a5f48e60b0124cf5863c1534cd544ecd0664bb534a4b5d506e9")        
    set(Boost_1_69_0_HASH_SHA256 "9a2c2819310839ea373f42d69e733c339b4e9a19deab6bfec448281554aa4dbb")        
    set(Boost_1_68_0_HASH_SHA256 "da3411ea45622579d419bfda66f45cd0f8c32a181d84adfa936f5688388995cf")        
endmacro(__concrete_boost_hash_table)

function(__concrete_boost_get_toolset TOOLSET TOOLSET_VERSION)
    if(MSVC)
        set(${TOOLSET} msvc PARENT_SCOPE)

        get_property(toolsetDefined CACHE CMAKE_GENERATOR_TOOLSET PROPERTY VALUE DEFINED)
        
        if (${toolsetDefined})            
            get_property(toolset CACHE CMAKE_GENERATOR_TOOLSET PROPERTY VALUE)

            if (${toolset} STREQUAL "v100")     # VS2010
                set(${TOOLSET_VERSION} "10.0" PARENT_SCOPE)
            elseif(${toolset} STREQUAL "v110")  # VS2012
                set(${TOOLSET_VERSION} "11.0" PARENT_SCOPE)
            elseif(${toolset} STREQUAL "v120")  # VS2013
                set(${TOOLSET_VERSION} "12.0" PARENT_SCOPE)
            elseif(${toolset} STREQUAL "v140")  # VS2015
                set(${TOOLSET_VERSION} "14.0" PARENT_SCOPE)
            elseif(${toolset} STREQUAL "v141")  # VS2017
                set(${TOOLSET_VERSION} "14.1" PARENT_SCOPE)
            elseif(${toolset} STREQUAL "v142")  # VS2019
                set(${TOOLSET_VERSION} "14.2" PARENT_SCOPE)
            else()
                concrete_error("unknown msvc toolset version")
            endif()
        else()
            get_property(toolset CACHE CMAKE_GENERATOR PROPERTY VALUE)

            if (${toolset} STREQUAL "Visual Studio 9 2008")     # VS2008
                set(${TOOLSET_VERSION} "9.0" PARENT_SCOPE)
            elseif(${toolset} STREQUAL "Visual Studio 10 2010")  # VS2010
                set(${TOOLSET_VERSION} "10.0" PARENT_SCOPE)
            elseif(${toolset} STREQUAL "Visual Studio 11 2012")  # VS2012
                set(${TOOLSET_VERSION} "11.0" PARENT_SCOPE)
            elseif(${toolset} STREQUAL "Visual Studio 12 2013")  # VS2013
                set(${TOOLSET_VERSION} "12.0" PARENT_SCOPE)
            elseif(${toolset} STREQUAL "Visual Studio 14 2015")  # VS2015
                set(${TOOLSET_VERSION} "14.0" PARENT_SCOPE)
            elseif(${toolset} STREQUAL "Visual Studio 15 2017")  # VS2017
                set(${TOOLSET_VERSION} "14.1" PARENT_SCOPE)
            elseif(${toolset} STREQUAL "Visual Studio 16 2019")  # VS2019
                set(${TOOLSET_VERSION} "14.2" PARENT_SCOPE)
            else()
                concrete_error("unknown msvc toolset version")
            endif()    
        endif()
    endif(MSVC)    
endfunction(__concrete_boost_get_toolset)

function(concrete_package_boost)
    set(options STATIC SHARED SINGLE_THREADING MULTI_THREADING RUNTIME_LINK_STATIC)

    set(singleValueKey
        TARGET_NAME 
        VERSION
        TOOLSET
        TOOLSET_VERSION
        DOWNLOAD_METHOD
        )

    set(mulitValueKey WITH_BUILD WITHOUT_BUILD FIND_PACKAGE_ARGUMENTS)

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE_BOOST
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    __concrete_boost_hash_table()

    if(_CONCRETE_BOOST_TARGET_NAME)
        set(targetPackageName ${_CONCRETE_BOOST_TARGET_NAME})
    else()
        set(targetPackageName Boost)
    endif(_CONCRETE_BOOST_TARGET_NAME)

    if(_CONCRETE_BOOST_VERSION)
        set(targetPackageVersion ${_CONCRETE_BOOST_VERSION})
    else()
        set(targetPackageVersion "1.72.0")
    endif(_CONCRETE_BOOST_VERSION)

    set(linkOptions)

    if (_CONCRETE_BOOST_STATIC)        
        string(APPEND linkOptions "link=static ")
    endif()

    if (_CONCRETE_BOOST_SHARED)        
        string(APPEND linkOptions "link=shared")
    endif()

    set(threadingOptions)

    if (_CONCRETE_BOOST_SINGLE_THREADING)
        string(APPEND threadingOptions "threading=single ")
    endif()

    if (_CONCRETE_BOOST_MULTI_THREADING)
        string(APPEND threadingOptions "threading=multi ")
    endif()

    set(withBuild)
    if(_CONCRETE_BOOST_WITH_BUILD)
        foreach(var ${_CONCRETE_BOOST_WITH_BUILD})
            string(APPEND withBuild "--without-${var}")
        endforeach()
    endif()

    set(withoutBuild)
    if(_CONCRETE_BOOST_WITHOUT_BUILD)
        foreach(var ${_CONCRETE_BOOST_WITHOUT_BUILD})
            string(APPEND withoutBuild "--without-${var}")
        endforeach()
    endif()

    set(runtimeLinkOptions)

    if(_CONCRETE_BOOST_RUNTIME_LINK_STATIC)
        string(APPEND runtimeLinkOptions "runtime-link=static ")
    endif()

    string(REPLACE "." "_" boostPackageName ${targetPackageVersion})

    set(boostPackageURLS 
        "https://dl.bintray.com/boostorg/release/${targetPackageVersion}/source/boost_${boostPackageName}.tar.gz"
        "https://github.com/boostorg/boost/archive/boost-${targetPackageVersion}.tar.gz"
        "https://sourceforge.net/projects/boost/files/boost/${targetPackageVersion}/boost_${boostPackageName}.tar.gz"
        "http://mirror.nienbo.com/boost/${targetPackageVersion}/boost_${boostPackageName}.tar.gz"
    )

    if (DEFINED Boost_${boostPackageName}_HASH_SHA256)
        set(hashCheck URL_HASH SHA256=${Boost_${boostPackageName}_HASH_SHA256})
    endif()

    if (MSVC)
        set(bootstrap bootstrap.bat)
    else()
        set(bootstrap bootstrap.sh)
    endif(MSVC)

    __concrete_boost_get_toolset(toolset toolsetVersion)

    if (_CONCRETE_BOOST_TOOLSET)
        set(toolset ${_CONCRETE_TOOLSET})
    endif()

    if (_CONCRETE_BOOST_TOOLSET_VERSION)
        set(toolsetVersion ${_CONCRETE_TOOLSET_VERSION})
    endif()

    if (${CONCRETE_PROJECT_COMPILER_TARGET} STREQUAL "x86")
        set(addressModel "32")
    elseif(${CONCRETE_PROJECT_COMPILER_TARGET} STREQUAL "x64")
        set(addressModel "64")
    endif()

    set(downloadOptions)

    if(_CONCRETE_BOOST_DOWNLOAD_METHOD)
        if(${_CONCRETE_BOOST_DOWNLOAD_METHOD} STREQUAL "url")
            set(downloadMethod "url")
        elseif(${_CONCRETE_BOOST_DOWNLOAD_METHOD} STREQUAL "git")
            set(downloadMethod "git")
        endif()
    else()
        set(downloadMethod "url")
    endif()

    if(${downloadMethod} STREQUAL "url")
        set(downloadOptions PACKAGE_TYPE url LINKS ${boostPackageURLS} ${hashCheck})
    elseif(${downloadMethod} STREQUAL "git")
        set(downloadOptions PACKAGE_TYPE git REPOSITORY https://github.com/boostorg/boost.git COMMIT_TAG boost-${targetPackageVersion} GIT_SUBMODULES_RECURSE ON)
    else()
        concrete_error("unsupport method")
    endif()

    concrete_package(
        boost

        PACKAGES ${targetPackageName}

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

        ${targetPackageName}_FIND_PACKAGE_ARGUMENTS
            ${_CONCRETE_BOOST_FIND_PACKAGE_ARGUMENTS}
    )

    concrete_clear_moudule_cache(Boost_DIR Boost_INCLUDE_DIR boost_headers_DIR)

    set(BOOST_FOUND ${BOOST_FOUND} PARENT_SCOPE)

    concrete_export_package_manager_path(boost)
endfunction(concrete_package_boost)

