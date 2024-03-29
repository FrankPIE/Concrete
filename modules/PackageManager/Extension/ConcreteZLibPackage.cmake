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

function(concrete_package_zip)
    set(options)

    set(singleValueKey
        VERSION NAME
        )

    set(mulitValueKey ZLIB_FIND_PACKAGE_ARGUMENTS CONFIGURE_TYPE)

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE_ZLIB
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    if (_CONCRETE_ZLIB_NAME)
        set(name ${_CONCRETE_ZLIB_NAME})
    else()
        set(name zip)
    endif()

    if (_CONCRETE_ZLIB_CONFIGURE_TYPE)
        set(buildOptions CMAKE_STANDARD_BUILD_OPTIONS)
        set(configureType CMAKE_CONFIGURE_TYPES ${_CONCRETE_ZLIB_CONFIGURE_TYPE})
    endif()

    if(_CONCRETE_ZLIB_VERSION)
        set(targetPackageVersion ${_CONCRETE_ZLIB_VERSION})
    else()
        set(targetPackageVersion "1.2.11")
    endif()

    set(cmakeBuildOptions ${buildOptions} ${configureType})

    concrete_package(
        ${name}

        VERSION ${targetPackageVersion}

        PACKAGES "ZLIB"

        FETCH_PACKAGE_ARGUMENTS
            DOWNLOAD_BUILD_STEP_OPTIONS
                BUILD_TOOLSET "CMake"

                ${cmakeBuildOptions}

                DOWNLOAD_OPTIONS
                    PACKAGE_TYPE git
                    REPOSITORY  "https://github.com/madler/zlib.git"
                                "https://gitee.com/mirrors/zlib.git" 
                               
                    COMMIT_TAG "v${targetPackageVersion}"

        ZLIB_FIND_PACKAGE_ARGUMENTS
            ${_CONCRETE_ZLIB_ZLIB_FIND_PACKAGE_ARGUMENTS}
    )

    concrete_clear_moudule_cache(ZLIB_INCLUDE_DIR ZLIB_LIBRARY_DEBUG ZLIB_LIBRARY_RELEASE)

    set(ZLIB_FOUND ${ZLIB_FOUND} PARENT_SCOPE)

    concrete_export_package_manager_path(zip)
endfunction(concrete_package_zip)