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

PROJECT(${CONCRETE_PROJECT_DEFAULT_PARAMETER})

concrete_project(
    NAME         Concrete
    VERSION      1 0 0 0
    DESCRIPTION  "Concrete CMake Library"
    HOMEPAGE_URL "https://github.com/FrankPIE/Concrete.git"
    LANGUAGES     CXX

    CONFIGURATION_TYPES Debug Release Profile

    ROOT_DIR            ${CMAKE_HOME_DIRECTORY}/../
    BINARY_OUTPUT_DIR   ${CMAKE_HOME_DIRECTORY}/../bin
    LIBRARY_OUTPUT_DIR  ${CMAKE_HOME_DIRECTORY}/../lib
    WITH_COMPILER_TARGET_SUBDIR    
)

concrete_set_global_properties(
    PROPERTIES 
        USE_FOLDERS ON 
        PREDEFINED_TARGETS_FOLDER "ConcreteTargets"
        USE_UNITY_BUILD_FOR_ALL_TARGETS ON
)

# CONCRETE_METHOD_PROJECT_BUILD_CONFIG_SETTING(
#     BUILD_TYPE ALL_BUILD
#     LANGUAGE_OR_LINKER CXX
#     APPEND
#     USE_UNICODE
#     WARNING_LEVEL 4
# )

# CONCRETE_METHOD_PROJECT_BUILD_CONFIG_SETTING(
#     BUILD_TYPE Profile
#     LANGUAGE_OR_LINKER CXX
    
#     WARNING_AS_ERROR
#     WITHOUT_DEBUG
#     DEBUG_INFO_FORMAT DEBUG_INFO_WRITE_IN_PDB
# )

CONCRETE_METHOD_ADD_SUBDIRECTORYS(
    SOURCE_DIRECTORYS  ${CMAKE_HOME_DIRECTORY}/../tutorials/HelloWorld
    BINARY_DIRECTORIES HelloWorld.project
    FOLDERS            "ExecuteTargets"
)