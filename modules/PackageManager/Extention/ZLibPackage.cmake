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

FUNCTION(CONCRETE_METHOD_FIND_ZLIB_PACKAGE)
    SET(options)

    SET(singleValueKey
        VERSION
        )

    SET(mulitValueKey ZLIB_FIND_PACKAGE_ARGUMENTS CONFIGURE_TYPE)

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE_ZLIB
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    IF (_CONCRETE_ZLIB_CONFIGURE_TYPE)
        SET(buildOptions CMAKE_STANDARD_BUILD_OPTIONS)
        SET(configureType CMAKE_CONFIGURE_TYPES ${_CONCRETE_ZLIB_CONFIGURE_TYPE})
    ENDIF()

    IF(_CONCRETE_ZLIB_VERSION)
        SET(targetPackageVersion ${_CONCRETE_ZLIB_VERSION})
    ELSE()
        SET(targetPackageVersion "1.2.11")
    ENDIF()

    SET(cmakeBuildOptions ${buildOptions} ${configureType})

    CONCRETE_METHOD_FIND_PACKAGE(
        zip

        VERSION ${targetPackageVersion}

        PACKAGES "ZLib"

        FETCH_PACKAGE_ARGUMENTS
            DOWNLOAD_BUILD_STEP_OPTIONS
                BUILD_TOOLSET "CMake"

                ${cmakeBuildOptions}

                DOWNLOAD_OPTIONS
                    PACKAGE_TYPE GIT
                    REPOSITORY https://github.com/madler/zlib.git
                    COMMIT_TAG "v${targetPackageVersion}"

        ZLIB_FIND_PACKAGE_ARGUMENTS
            ${_CONCRETE_ZLIB_ZLIB_FIND_PACKAGE_ARGUMENTS}
    )
ENDFUNCTION(CONCRETE_METHOD_FIND_ZLIB_PACKAGE)