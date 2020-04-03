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

# include once
include_guard(GLOBAL)

include( CMakeParseArguments )

# create new directorys
function(concrete_create_directorys)
    set(options ABSOULT_PATH)
    set(singleValueKey)
    set(mulitValueKey DIRECTORYS)

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    if (_CONCRETE_DIRECTORYS)
        foreach(directory ${_CONCRETE_DIRECTORYS})
            if (_CONCRETE_ABSOULT_PATH)
                set(target ${directory})
            else()
                set(target ${CONCRETE_PROJECT_ROOT_DIRECTORY}/${directory})
            endif()

            if (NOT EXISTS ${target})
                file(MAKE_DIRECTORY ${target})

                if (NOT EXISTS ${target})
                    MESSAGE(WARNING "CREATE ${target} FAILED!")
                else()
                    MESSAGE(STATUS "CREATE ${target} OK!")
                endif(NOT EXISTS ${target})    
            endif()
        endforeach(directory ${_CONCRETE_DIRECTORYS})
    endif(_CONCRETE_DIRECTORYS)
endfunction(concrete_create_directorys)

function(concrete_hash FILE_PATH HASH_TYPE HASH_VALUE)
    set(target ${CONCRETE_PROJECT_ROOT_DIRECTORY}/${FILE_PATH})

    if (EXISTS ${target})
        file(${HASH_TYPE} ${target} ${HASH_VALUE})
        set(${HASH_VALUE} ${${${HASH_VALUE}}} PARENT_SCOPE)
    else()
        set(${HASH_VALUE} "" PARENT_SCOPE)
    endif(EXISTS ${target})
endfunction(concrete_hash)

function(concrete_remove_file FILE_PATH)
    set(options)
    set(singleValueKey)
    set(mulitValueKey FILES)

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    if (_CONCRETE_FILES)
        foreach(file ${_CONCRETE_FILES})
            set(target ${CONCRETE_PROJECT_ROOT_DIRECTORY}/${file})

            if (NOT EXISTS ${target})
                MESSAGE(WARNING "${target} has been removed")
            else()
                file(REMOVE_RECURSE ${target})
            endif(EXISTS ${target})
        endforeach(file ${_CONCRETE_FILES})
    endif(_CONCRETE_FILES)
endfunction(concrete_remove_file)