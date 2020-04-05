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

function(concrete_string_pop_last VALUE POP_COUNT OUTPUT)
    string(LENGTH "${${VALUE}}" length)
    math(EXPR length "${length} - ${POP_COUNT}")

    if(${length} LESS 0)
        concrete_error("pop too many char")
    else()
        string(SUBSTRING "${${VALUE}}" 0 ${length} ${OUTPUT})

        set(${OUTPUT} ${${OUTPUT}} PARENT_SCOPE)
    endif(${length} LESS 0)
endfunction(concrete_string_pop_last)

function(concrete_uuid UUID)
    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "UPPER"
        ""
        ""
        ${ARGN}
    )

    set(namespace "6ba7b810-9dad-11d1-80b4-00c04fd430c8")

    string(RANDOM LENGTH 5 name)

    if(${_CONCRETE_UPPER})
        set(upper UPPER)
    endif()

    string(UUID uuid NAMESPACE ${namespace} NAME ${name} TYPE MD5 ${upper})

    set(${UUID} ${uuid} PARENT_SCOPE)
endfunction(concrete_uuid)

function(concrete_separate_arguments VALUE OUTPUT)
    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        ""
        "COMMAND_MODE"
        ""
        ${ARGN}
    )

    if (_CONCRETE_COMMAND_MODE)
        set(commandModeStr ${_CONCRETE_COMMAND_MODE})
        if (${commandModeStr} STREQUAL "Windows")
            set(commandMode WINDOWS_COMMAND)
        elseif(${commandModeStr} STREQUAL "UNIX")
            set(commandMode UNIX_COMMAND)
        else()
            concrete_error("unknown command mode")
        endif()
    else()
        set(commandMode NATIVE_COMMAND)
    endif()

    separate_arguments(list ${commandMode} ${VALUE})

    set(index 0)
    set(listArguments)

    set(start FALSE)
    foreach(var ${list})
        if (NOT ${start})
            string(FIND ${var} "'" pos)

            if (${pos} EQUAL 0)
                set(start TRUE)

                set(stringCat)

                string(SUBSTRING ${var} 1 -1 var)
            endif()
        endif()

        if (${start})
            string(FIND ${var} "'" pos REVERSE)

            string(LENGTH ${var} length)
            math(EXPR length "${length} - 1")

            if (${pos} EQUAL ${length})
                set(start FLASE)                

                string(SUBSTRING ${var} 0 ${length} var)

                string(APPEND stringCat "${var}")

                LIST(APPEND listArguments ${stringCat})

                CONTINUE()
            endif()
        endif()

        if (${start})
            string(APPEND stringCat "${var} ")
        else()
            LIST(APPEND listArguments ${var})
        endif()
    endforeach()

    set(${OUTPUT} ${listArguments} PARENT_SCOPE)
endfunction(concrete_separate_arguments)
