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

function(concrete_package_opencv)
    set(options 
        WITHOUT_TEST 
        WITHOUT_PERF_TESTS
        WITHOUT_APP
        WITHOUT_JAVA
        WITHOUT_PYTHON
        WITHOUT_FFMPEG
        WITHOUT_IPPICV
        WITHOUT_VTK
        DISABLE_CXX11
        )

    set(singleValueKey
        VERSION BLAS_ROOT
        )

    set(mulitValueKey OPENCV_FIND_PACKAGE_ARGUMENTS CONFIGURE_TYPE )

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE_CV
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    if (_CONCRETE_CV_CONFIGURE_TYPE)
        set(buildOptions CMAKE_STANDARD_BUILD_OPTIONS)
        set(configureType CMAKE_CONFIGURE_TYPES ${_CONCRETE_CV_CONFIGURE_TYPE})
    endif()

    if(_CONCRETE_CV_VERSION)
        set(targetPackageVersion ${_CONCRETE_CV_VERSION})
    else()
        set(targetPackageVersion "3.4.9")
    endif()

    if (${_CONCRETE_CV_WITHOUT_TEST})
        list(APPEND cmakeArgs "-DBUILD_TESTS=OFF")
    endif()

    if (${_CONCRETE_CV_WITHOUT_PERF_TESTS})
        list(APPEND cmakeArgs "-DBUILD_PERF_TESTS=OFF")
    endif()

    if (${_CONCRETE_CV_WITHOUT_APP})
        list(APPEND cmakeArgs "-DBUILD_opencv_apps=OFF")
    endif()

    if (${_CONCRETE_CV_WITHOUT_JAVA})
        list(APPEND cmakeArgs "-DBUILD_opencv_java_bindings_generator=OFF")
        list(APPEND cmakeArgs "-DBUILD_JAVA=OFF")
    endif()

    if (${_CONCRETE_CV_WITHOUT_PYTHON})
        list(APPEND cmakeArgs "-DBUILD_opencv_python2=OFF")
        list(APPEND cmakeArgs "-DBUILD_opencv_python3=OFF")
        list(APPEND cmakeArgs "-DBUILD_opencv_python_bindings_generator=OFF")
        list(APPEND cmakeArgs "-DBUILD_opencv_python_tests=OFF")
    endif()

    if (${_CONCRETE_CV_WITHOUT_FFMPEG})
        list(APPEND cmakeArgs "-DWITH_FFMPEG=OFF")
    endif()

    if (${_CONCRETE_CV_WITHOUT_IPPICV})
        list(APPEND cmakeArgs "-DWITH_IPP=OFF")
    endif()

    if (${_CONCRETE_CV_DISABLE_CXX11})
        list(APPEND cmakeArgs "-DENABLE_CXX11=OFF")
    else()
        list(APPEND cmakeArgs "-DENABLE_CXX11=ON")
    endif()

    if(${_CONCRETE_CV_WITHOUT_VTK})
        list(APPEND cmakeArgs "-DWITH_VTK=OFF")
    endif()

    concrete_package(
        opencv

        VERSION "${targetPackageVersion}"

        PACKAGES OpenCV

        FETCH_PACKAGE_ARGUMENTS
            DOWNLOAD_BUILD_STEP_OPTIONS
                BUILD_TOOLSET "CMake"

                CMAKE_STANDARD_BUILD_OPTIONS
                    CMAKE_ARGS 
                        ${cmakeArgs}
                
                DOWNLOAD_OPTIONS
                    PACKAGE_TYPE git
                    REPOSITORY "https://github.com/opencv/opencv.git"
                    COMMIT_TAG "${targetPackageVersion}"

        DEPEND_PACKAGES_PATH 
            ${_CONCRETE_CV_BLAS_ROOT}
    )

    set(OpenCV_FOUND ${OpenCV_FOUND} PARENT_SCOPE)

    concrete_export_package_manager_path(opencv)
endfunction(concrete_package_opencv)
