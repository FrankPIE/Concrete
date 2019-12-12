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

INCLUDE_GUARD(GLOBAL)

FUNCTION(CONCRETE_METHOD_ADD_SUBDIRECTORYS)
    SET(options NEW_PROJECT_AS_SUBDIRECTORY)
    SET(singleValueKey BINARY_ROOT_DIRECTORY)
    SET(mulitValueKey SOURCE_DIRECTORYS BINARY_DIRECTORIES FOLDERS)

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    IF(_CONCRETE_BINARY_ROOT_DIRECTORY)
        SET(binaryRootDir ${_CONCRETE_BINARY_ROOT_DIRECTORY})
    ELSE()
        SET(binaryRootDir ${CMAKE_BINARY_DIR})
    ENDIF(_CONCRETE_BINARY_ROOT_DIRECTORY)

    IF (_CONCRETE_SOURCE_DIRECTORYS)
        SET(index 0)

        LIST(LENGTH _CONCRETE_SOURCE_DIRECTORYS length)
        WHILE(${index} LESS ${length})
            SET(paramList)

            LIST(GET _CONCRETE_SOURCE_DIRECTORYS ${index} sourceDir)

            LIST(APPEND paramList ${sourceDir})

            IF(_CONCRETE_BINARY_DIRECTORIES)
                LIST(GET _CONCRETE_BINARY_DIRECTORIES ${index} binaryDir)

                IF (NOT ${binaryDir} STREQUAL "")
                    LIST(APPEND paramList ${binaryRootDir}/${binaryDir})
                ENDIF(NOT ${binaryDir} STREQUAL "")
            ENDIF(_CONCRETE_BINARY_DIRECTORIES)

            IF(${_CONCRETE_NEW_PROJECT_AS_SUBDIRECTORY})
                LIST(APPEND paramList EXCLUDE_FROM_ALL)
            ENDIF(${_CONCRETE_NEW_PROJECT_AS_SUBDIRECTORY})

            ADD_SUBDIRECTORY(${paramList})

            IF (_CONCRETE_FOLDERS)
                LIST(GET _CONCRETE_FOLDERS ${index} folderName)

                IF(NOT ${folderName} STREQUAL "")
                    SET_PROPERTY(DIRECTORY "${sourceDir}" PROPERTY FOLDER "${folderName}")
                ENDIF(NOT ${folderName} STREQUAL "")
            ENDIF(_CONCRETE_FOLDERS)
    
            MATH(EXPR index "${index} + 1")
        ENDWHILE(${index} LESS ${length})
    ENDIF(_CONCRETE_SOURCE_DIRECTORYS)
ENDFUNCTION(CONCRETE_METHOD_ADD_SUBDIRECTORYS)
