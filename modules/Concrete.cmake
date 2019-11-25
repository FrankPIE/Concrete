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

INCLUDE_GUARD(GLOBAL)

# CMake standard module
INCLUDE( CMakeParseArguments )

# INCLUDE( CheckCCompilerFlag )
# INCLUDE( CheckCXXCompilerFlag )

# INCLUDE( CheckIncludeFile )
# INCLUDE( CheckIncludeFileCXX )
# INCLUDE( CheckIncludeFiles )

# Concrete modules
INCLUDE( ConcreteVariables )
INCLUDE( ConcreteProperties )
INCLUDE( ConcreteDebug )

# Concrete Envionment modules
INCLUDE( Environment/DetectSystemInfo )

FUNCTION(CONCRETE_METHOD_INITIALIZATION)
    SET(options ADD_COMPILER_TARGET_DIR)

    SET(singleValueKey PROJECT_ROOT_DIR BINARY_OUTPUT_DIR LIBRARY_OUTPUT_DIR)
    
    SET(mulitValueKey)

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    CONCRETE_METHOD_COLLECT_SYSTEM_INFORMATION()

    SET(CONCRETE_PROJECT_NAME ${CMAKE_PROJECT_NAME} CACHE INTERNAL "project name" FORCE)

    IF(_CONCRETE_PROJECT_ROOT_DIR)
        SET(CONCRETE_PROJECT_ROOT_DIRECTORY ${_CONCRETE_PROJECT_ROOT_DIR} CACHE PATH "prject root dir default as ${CMAKE_HOME_DIRECTORY}" FORCE)
    ELSE(_CONCRETE_PROJECT_ROOT_DIR)
        SET(CONCRETE_PROJECT_ROOT_DIRECTORY "${${CMAKE_PROJECT_NAME}_BINARY_DIR}" CACHE PATH "prject root dir default as ${CMAKE_HOME_DIRECTORY}" FORCE)
    ENDIF(_CONCRETE_PROJECT_ROOT_DIR)

    # begin set compiler target
    # set platform compiler target x86 or x64 or arm(not supported yet)
    IF (CMAKE_CL_64)
        SET(CONCRETE_PROJECT_COMPILER_TARGET x64 CACHE INTERNAL "project compiler target" FORCE)
    ELSE()
        SET(CONCRETE_PROJECT_COMPILER_TARGET x86 CACHE INTERNAL "project compiler target" FORCE)
    ENDIF(CMAKE_CL_64)
    # end set compiler target

    #[[ begin set output dir ]] ########################################
    SET(runtimeOutputDir)

    IF(_CONCRETE_BINARY_OUTPUT_DIR)
        SET(runtimeOutputDir ${_CONCRETE_BINARY_OUTPUT_DIR})
    ELSE(_CONCRETE_BINARY_OUTPUT_DIR)
        SET(runtimeOutputDir ${CONCRETE_PROJECT_ROOT_DIRECTORY}/bin)
    ENDIF(_CONCRETE_BINARY_OUTPUT_DIR)

    IF (${_CONCRETE_ADD_COMPILER_TARGET_DIR})
        SET(runtimeOutputDir ${runtimeOutputDir}/${CONCRETE_PROJECT_COMPILER_TARGET})
    ENDIF(${_CONCRETE_ADD_COMPILER_TARGET_DIR})

    SET(CONCRETE_PROJECT_BINARY_OUTPUT_DIRECTORY ${runtimeOutputDir} CACHE PATH "global binary files generate directory" FORCE)

    SET(libraryOutputDir)

    IF(_CONCRETE_LIBRARY_OUTPUT_DIR)
        SET(libraryOutputDir ${_CONCRETE_LIBRARY_OUTPUT_DIR})
    ELSE(_CONCRETE_LIBRARY_OUTPUT_DIR)
        SET(libraryOutputDir ${CONCRETE_PROJECT_ROOT_DIRECTORY}/lib)
    ENDIF(_CONCRETE_LIBRARY_OUTPUT_DIR)

    IF (${_CONCRETE_ADD_COMPILER_TARGET_DIR})
        SET(libraryOutputDir ${libraryOutputDir}/${CONCRETE_PROJECT_COMPILER_TARGET})
    ENDIF(${_CONCRETE_ADD_COMPILER_TARGET_DIR})

    SET(CONCRETE_PROJECT_LIBRARY_OUTPUT_DIRECTORY ${libraryOutputDir} CACHE PATH "global binary files generate directory" FORCE)

    SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CONCRETE_PROJECT_BINARY_OUTPUT_DIRECTORY})        
    SET(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CONCRETE_PROJECT_LIBRARY_OUTPUT_DIRECTORY})
    SET(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CONCRETE_PROJECT_LIBRARY_OUTPUT_DIRECTORY})
    #[[ end set output dir ]] ########################################

ENDFUNCTION(CONCRETE_METHOD_INITIALIZATION)

FUNCTION(CONCRETE_METHOD_SET_VERSION)

ENDFUNCTION(CONCRETE_METHOD_SET_VERSION)