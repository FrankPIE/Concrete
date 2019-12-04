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

MACRO(CONCRETE_INTERNAL_METHOD_FIND_STRING FLAGS FLAG OUTPUT)
    SET(pos)
    
    STRING(FIND "${${FLAGS}}" "${FLAG}" pos)

    IF(NOT ${pos} EQUAL -1)
        SET(${OUTPUT} TRUE)
    ELSE()
        SET(${OUTPUT} FALSE)
    ENDIF(NOT ${pos} EQUAL -1)

    UNSET(pos)
ENDMACRO(CONCRETE_INTERNAL_METHOD_FIND_STRING)

MACRO(CONCRETE_INTERNAL_METHOD_APPEND_FLAG FLAGS FLAG)
    SET(haveFlag)
    
    CONCRETE_INTERNAL_METHOD_FIND_STRING(${FLAGS} ${FLAG} haveFlag)

    IF(NOT haveFlag)
        STRING(APPEND ${FLAGS} "${FLAG} ")
    ENDIF(NOT haveFlag)

    UNSET(haveFlag)
ENDMACRO(CONCRETE_INTERNAL_METHOD_APPEND_FLAG)

MACRO(CONCRETE_INTERNAL_METHOD_ADD_NDEBUG_FLAG FLAGS)
    CONCRETE_INTERNAL_METHOD_APPEND_FLAG(${FLAGS} "/DNDEBUG")
ENDMACRO(CONCRETE_INTERNAL_METHOD_ADD_NDEBUG_FLAG)

MACRO(CONCRETE_INTERNAL_METHOD_ADD_UNICODE_FLAG FLAGS)
    CONCRETE_INTERNAL_METHOD_APPEND_FLAG(${FLAGS} "/DUNICODE")

    CONCRETE_INTERNAL_METHOD_APPEND_FLAG(${FLAGS} "/D_UNICODE")
ENDMACRO(CONCRETE_INTERNAL_METHOD_ADD_NDEBUG_FLAG)
