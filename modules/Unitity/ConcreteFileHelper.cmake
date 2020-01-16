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

# create a new directory
FUNCTION(CONCRETE_METHOD_CREATE_DIRECTORY DIRECTORY_PATH)
    set(target ${DIRECTORY_PATH})

    IF (EXISTS ${target})
        MESSAGE(WARNING "${target} has created!")
    ELSE()
        FILE(MAKE_DIRECTORY ${target})

        IF (NOT EXISTS ${target})
            MESSAGE(WARNING "Create ${target} failed!")
        ELSE()
            MESSAGE(STATUS "Create ${target} OK!")
        ENDIF()
    ENDIF()
ENDFUNCTION(CONCRETE_METHOD_CREATE_DIRECTORY)

FUNCTION(CONCRETE_METHOD_HASH FILE_PATH HASH_TYPE HASH_VALUE)
    IF (EXISTS ${FILE_PATH})
        FILE(${HASH_TYPE} ${FILE_PATH} ${HASH_VALUE})
        SET(${HASH_VALUE} ${${${HASH_VALUE}}} PARENT_SCOPE)
    ELSE()
        SET(${HASH_VALUE} "" PARENT_SCOPE)
    ENDIF(EXISTS ${FILE_PATH})
ENDFUNCTION(CONCRETE_METHOD_HASH)