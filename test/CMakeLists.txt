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

CONCRETE_METHOD_INITIALIZATION(
    PROJECT_NAME         Concrete
    PROJECT_VERSION      1 0 0 0
    PROJECT_DESCRIPTION  "Concrete CMake Library"
    PROJECT_HOMEPAGE_URL "https://github.com/FrankPIE/Concrete.git"
    PROJECT_ROOT_DIR     ${CMAKE_HOME_DIRECTORY}/../

    PROJECT_LANGUAGE_C PROJECT_LANGUAGE_CXX PROJECT_LANGUAGE_ASM 

    PROJECT_GEN_COMPILER_TARGET_DIR 
)