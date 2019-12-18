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

FUNCTION(CONCRETE_METHOD_SOURCE_LIST LIST)
    SET(options)
    SET(singleValueKey SOURCES_FOLDER MSVC_SOURCES_FOLDER)
    SET(mulitValueKey SOURCES MSVC_SOURCES)    

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    IF (_CONCRETE_SOURCES)
        LIST(APPEND ${LIST} ${_CONCRETE_SOURCES})

        IF (_CONCRETE_SOURCES_FOLDER)
            SOURCE_GROUP(${_CONCRETE_SOURCES_FOLDER} FILES ${_CONCRETE_SOURCES})
        ENDIF(_CONCRETE_SOURCES_FOLDER)

    ENDIF(_CONCRETE_SOURCES)    

    IF(MSVC)
        IF(_CONCRETE_MSVC_SOURCES)
            LIST(APPEND ${LIST} ${_CONCRETE_MSVC_SOURCES})
            SET(${LIST}_MSVC ${_CONCRETE_MSVC_SOURCES} PARENT_SCOPE)

            IF (_CONCRETE_MSVC_SOURCES_FOLDER)
                SOURCE_GROUP(${_CONCRETE_MSVC_SOURCES_FOLDER} FILES ${_CONCRETE_MSVC_SOURCES})
            ENDIF(_CONCRETE_MSVC_SOURCES_FOLDER)
        ENDIF(_CONCRETE_MSVC_SOURCES)
    ENDIF(MSVC)

    SET(${LIST} ${${LIST}} PARENT_SCOPE)
ENDFUNCTION(CONCRETE_METHOD_SOURCE_LIST)

#TODO::SOURCE_DIRECTORY_ANALYSE
FUNCTION(CONCRETE_METHOD_SOURCE_DIRECTORY_ANALYSE DIRECTORY)

ENDFUNCTION(CONCRETE_METHOD_SOURCE_DIRECTORY_ANALYSE)