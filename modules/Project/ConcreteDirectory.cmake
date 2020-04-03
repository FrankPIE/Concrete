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

include_guard(GLOBAL)

function(concrete_add_subdirectory)
    set(options NEW_PROJECT_AS_SUBDIRECTORY)
    set(singleValueKey BINARY_ROOT_DIRECTORY)
    set(mulitValueKey SOURCE_DIRECTORYS BINARY_DIRECTORIES FOLDERS)

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    if(_CONCRETE_BINARY_ROOT_DIRECTORY)
        set(binaryRootDir ${_CONCRETE_BINARY_ROOT_DIRECTORY})
    else()
        set(binaryRootDir ${CMAKE_BINARY_DIR})
    endif(_CONCRETE_BINARY_ROOT_DIRECTORY)

    if (_CONCRETE_SOURCE_DIRECTORYS)
        set(index 0)

        list(LENGTH _CONCRETE_SOURCE_DIRECTORYS length)
        while(${index} LESS ${length})
            set(paramList)

            list(GET _CONCRETE_SOURCE_DIRECTORYS ${index} sourceDir)

            list(APPEND paramList ${sourceDir})

            if(_CONCRETE_BINARY_DIRECTORIES)
                list(GET _CONCRETE_BINARY_DIRECTORIES ${index} binaryDir)

                if (NOT ${binaryDir} STREQUAL "")
                    list(APPEND paramList ${binaryRootDir}/${binaryDir})
                endif(NOT ${binaryDir} STREQUAL "")
            endif(_CONCRETE_BINARY_DIRECTORIES)

            if(${_CONCRETE_NEW_PROJECT_AS_SUBDIRECTORY})
                list(APPEND paramList EXCLUDE_FROM_ALL)
            endif(${_CONCRETE_NEW_PROJECT_AS_SUBDIRECTORY})

            add_subdirectory(${paramList})

            if (_CONCRETE_FOLDERS)
                list(GET _CONCRETE_FOLDERS ${index} folderName)

                if(NOT ${folderName} STREQUAL "")
                    set_property(DIRECTORY "${sourceDir}" PROPERTY FOLDER "${folderName}")
                endif(NOT ${folderName} STREQUAL "")
            endif(_CONCRETE_FOLDERS)
    
            math(EXPR index "${index} + 1")
        endwhile(${index} LESS ${length})
    endif(_CONCRETE_SOURCE_DIRECTORYS)
endfunction(concrete_add_subdirectory)
