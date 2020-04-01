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

FUNCTION(CONCRETE_METHOD_STRING_POP_LAST VALUE POP_COUNT OUTPUT)
    STRING(LENGTH "${${VALUE}}" length)
    MATH(EXPR length "${length} - ${POP_COUNT}")

    IF(${length} LESS 0)
        MESSAGE(FATAL_ERROR "Pop too many char")
    ELSE()
        STRING(SUBSTRING "${${VALUE}}" 0 ${length} ${OUTPUT})

        SET(${OUTPUT} ${${OUTPUT}} PARENT_SCOPE)
    ENDIF(${length} LESS 0)
ENDFUNCTION(CONCRETE_METHOD_STRING_POP_LAST)

FUNCTION(CONCRETE_METHOD_UUID UUID)
    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "UPPER"
        ""
        ""
        ${ARGN}
    )

    SET(namespace "6ba7b810-9dad-11d1-80b4-00c04fd430c8")

    STRING(RANDOM LENGTH 5 name)

    IF(${_CONCRETE_UPPER})
        SET(upper UPPER)
    ENDIF()

    STRING(UUID uuid NAMESPACE ${namespace} NAME ${name} TYPE MD5 ${upper})

    SET(${UUID} ${uuid} PARENT_SCOPE)
ENDFUNCTION(CONCRETE_METHOD_UUID)

FUNCTION(CONCRETE_METHOD_SEPARATE_ARGUMENTS VALUE OUTPUT)
    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        ""
        "COMMAND_MODE"
        ""
        ${ARGN}
    )

    IF (_CONCRETE_COMMAND_MODE)
        SET(commandModeStr ${_CONCRETE_COMMAND_MODE})
        IF (${commandModeStr} STREQUAL "Windows")
            SET(commandMode WINDOWS_COMMAND)
        ELSEIF(${commandModeStr} STREQUAL "UNIX")
            SET(commandMode UNIX_COMMAND)
        ELSE()
            MESSAGE(FATAL_MESSAGE "unknown command mode")
        ENDIF()
    ELSE()
        SET(commandMode NATIVE_COMMAND)
    ENDIF()

    SEPARATE_ARGUMENTS(list ${commandMode} ${VALUE})

    SET(index 0)
    SET(listArguments)

    SET(start FALSE)
    FOREACH(var ${list})
        IF (NOT ${start})
            STRING(FIND ${var} "'" pos)

            IF (${pos} EQUAL 0)
                SET(start TRUE)

                SET(stringCat)

                STRING(SUBSTRING ${var} 1 -1 var)
            ENDIF()
        ENDIF()

        IF (${start})
            STRING(FIND ${var} "'" pos REVERSE)

            STRING(LENGTH ${var} length)
            MATH(EXPR length "${length} - 1")

            IF (${pos} EQUAL ${length})
                SET(start FLASE)                

                STRING(SUBSTRING ${var} 0 ${length} var)

                STRING(APPEND stringCat "${var}")

                LIST(APPEND listArguments ${stringCat})

                CONTINUE()
            ENDIF()
        ENDIF()

        IF (${start})
            STRING(APPEND stringCat "${var} ")
        ELSE()
            LIST(APPEND listArguments ${var})
        ENDIF()
    ENDFOREACH()

    SET(${OUTPUT} ${listArguments} PARENT_SCOPE)
ENDFUNCTION(CONCRETE_METHOD_SEPARATE_ARGUMENTS)
