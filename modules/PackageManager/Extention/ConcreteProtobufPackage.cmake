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

function(concrete_package_protobuf)
    set(options CONFIG SHARED BUILD_TEST)

    set(singleValueKey VERSION ZLIB_ROOT)

    set(mulitValueKey PROTOBUF_FIND_PACKAGE_ARGUMENTS CONFIGURE_TYPE)

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE_PROTOBUF
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    if(_CONCRETE_PROTOBUF_VERSION)
        set(targetPackageVersion ${_CONCRETE_PROTOBUF_VERSION})
    else()
        set(targetPackageVersion "3.11.4")
    endif()

    if (_CONCRETE_PROTOBUF_CONFIGURE_TYPE)
        set(configureType CMAKE_CONFIGURE_TYPES ${_CONCRETE_PROTOBUF_CONFIGURE_TYPE})
    endif()

    if (_CONCRETE_PROTOBUF_ZLIB_ROOT)
        set(zlibRootDir ${_CONCRETE_PROTOBUF_ZLIB_ROOT})
    endif()

    set(links 
        "https://github.com/protocolbuffers/protobuf/releases/download/v${targetPackageVersion}/protobuf-cpp-${targetPackageVersion}.tar.gz"
    )

    set(packageName Protobuf)

    if (${_CONCRETE_PROTOBUF_CONFIG})
        set(protobufConfig CONFIG_HINTS "/cmake")
        set(packageName protobuf)

        concrete_debug("protobuf hint : ${protobufConfig}")
    endif()

    if(${_CONCRETE_PROTOBUF_SHARED})
        list(APPEND cmakeArgs "-DBUILD_SHARED_LIBS=ON")
    else()
        list(APPEND cmakeArgs "-DBUILD_SHARED_LIBS=OFF")
    endif()

    if (${_CONCRETE_PROTOBUF_BUILD_TEST})
        list(APPEND cmakeArgs "-Dprotobuf_BUILD_TESTS=ON")
    else()
        list(APPEND cmakeArgs "-Dprotobuf_BUILD_TESTS=OFF")
    endif()

    concrete_package(
        protobuf
    
        VERSION "${targetPackageVersion}"
    
        PACKAGES ${packageName}
    
        FETCH_PACKAGE_ARGUMENTS
            DOWNLOAD_BUILD_STEP_OPTIONS
                BUILD_TOOLSET "CMake"
    
                CMAKE_STANDARD_BUILD_OPTIONS
                    ROOT_DIR "PACKAGE_SOURCE_DIR/cmake"
                    CMAKE_ARGS ${cmakeArgs}
                    ${configureType}
    
                DOWNLOAD_OPTIONS
                    PACKAGE_TYPE url
                    LINKS ${links}
    
        ${protobufConfig}

        DEPEND_PACKAGES_PATH ${zlibRootDir}

        PROTOBUF_FIND_PACKAGE_ARGUMENTS
            ${_CONCRETE_PROTOBUF_PROTOBUF_FIND_PACKAGE_ARGUMENTS}
    )

    set(Protobuf_FOUND ${Protobuf_FOUND} PARENT_SCOPE)

    concrete_export_package_manager_path(protobuf)
endfunction(concrete_package_protobuf)
