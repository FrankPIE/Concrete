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
INCLUDE_GUARD(GLOBAL)

INCLUDE( CMakeParseArguments )

# create new directorys
FUNCTION(CONCRETE_METHOD_CREATE_DIRECTORYS)
    SET(options ABSOULT_PATH)
    SET(singleValueKey)
    SET(mulitValueKey DIRECTORYS)

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    IF (_CONCRETE_DIRECTORYS)
        FOREACH(directory ${_CONCRETE_DIRECTORYS})
            IF (_CONCRETE_ABSOULT_PATH)
                SET(target ${directory})
            ELSE()
                SET(target ${CONCRETE_PROJECT_ROOT_DIRECTORY}/${directory})
            ENDIF()

            IF (NOT EXISTS ${target})
                FILE(MAKE_DIRECTORY ${target})

                IF (NOT EXISTS ${target})
                    MESSAGE(WARNING "CREATE ${target} FAILED!")
                ELSE()
                    MESSAGE(STATUS "CREATE ${target} OK!")
                ENDIF(NOT EXISTS ${target})    
            ENDIF()
        ENDFOREACH(directory ${_CONCRETE_DIRECTORYS})
    ENDIF(_CONCRETE_DIRECTORYS)
ENDFUNCTION(CONCRETE_METHOD_CREATE_DIRECTORYS)

FUNCTION(CONCRETE_METHOD_HASH FILE_PATH HASH_TYPE HASH_VALUE)
    SET(target ${CONCRETE_PROJECT_ROOT_DIRECTORY}/${FILE_PATH})

    IF (EXISTS ${target})
        FILE(${HASH_TYPE} ${target} ${HASH_VALUE})
        SET(${HASH_VALUE} ${${${HASH_VALUE}}} PARENT_SCOPE)
    ELSE()
        SET(${HASH_VALUE} "" PARENT_SCOPE)
    ENDIF(EXISTS ${target})
ENDFUNCTION(CONCRETE_METHOD_HASH)

FUNCTION(CONCRETE_METHOD_REMOVE_FILE FILE_PATH)
    SET(options)
    SET(singleValueKey)
    SET(mulitValueKey FILES)

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    IF (_CONCRETE_FILES)
        FOREACH(file ${_CONCRETE_FILES})
            SET(target ${CONCRETE_PROJECT_ROOT_DIRECTORY}/${file})

            IF (NOT EXISTS ${target})
                MESSAGE(WARNING "${target} has been removed")
            ELSE()
                FILE(REMOVE_RECURSE ${target})
            ENDIF(EXISTS ${target})
        ENDFOREACH(file ${_CONCRETE_FILES})
    ENDIF(_CONCRETE_FILES)
ENDFUNCTION(CONCRETE_METHOD_REMOVE_FILE)