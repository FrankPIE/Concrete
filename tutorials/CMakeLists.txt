# MIT License
# 
# Copyright (c) 2019 MadStrawberry
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

CMAKE_MINIMUM_REQUIRED(VERSION 3.10.3)

LIST(APPEND CMAKE_MODULE_PATH ${CMAKE_HOME_DIRECTORY}/../modules)

INCLUDE(Concrete)

CONCRETE_METHOD_PROJECT_INITIALIZATION(
    PROJECT_NAME         Concrete
    PROJECT_VERSION      1 0 0 0
    PROJECT_DESCRIPTION  "Concrete CMake Library"
    PROJECT_HOMEPAGE_URL "https://github.com/FrankPIE/Concrete.git"
    PROJECT_LANGUAGE_C PROJECT_LANGUAGE_CXX PROJECT_LANGUAGE_ASM 

    PROJECT_BUILD_TYPES Debug Release Profile

    PROJECT_ROOT_DIR            ${CMAKE_HOME_DIRECTORY}/../
    PROJECT_BINARY_OUTPUT_DIR   ${CMAKE_HOME_DIRECTORY}/../bin
    PROJECT_LIBRARY_OUTPUT_DIR  ${CMAKE_HOME_DIRECTORY}/../lib
    PROJECT_GEN_COMPILER_TARGET_SUBDIRECTORY    
)

CONCRETE_METHOD_PROJECT_GLOBAL_SETTING(
    USE_FOLDERS
)

CONCRETE_METHOD_PROJECT_BUILD_CONFIG_SETTING(
    BUILD_TYPE ALL_BUILD
    LANGUAGE_OR_LINKER CXX
    APPEND
    USE_UNICODE
    WARNING_LEVEL 4
)

CONCRETE_METHOD_PROJECT_BUILD_CONFIG_SETTING(
    BUILD_TYPE Profile
    LANGUAGE_OR_LINKER CXX
    
    WARNING_AS_ERROR
    WITHOUT_DEBUG
    DEBUG_INFO_FORMAT DEBUG_INFO_WRITE_IN_PDB
)

add_executable(HelloWorld ./main.cpp)