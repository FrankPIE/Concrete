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

FUNCTION(CONCRETE_METHOD_DOWNLOAD_FILE URI DEST_PATH HASH)
    SET(options)
    SET(singleValueKey HASH_TYPE)
    SET(mulitValueKey)

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    IF (_CONCRETE_HASH_TYPE)
        SET(hashType ${_CONCRETE_HASH_TYPE})
    ELSE()
        SET(hashType SHA1)
    ENDIF(_CONCRETE_HASH_TYPE)

    SET(target ${CONCRETE_PROJECT_ROOT_DIRECTORY}/${DEST_PATH})

    IF (EXISTS ${target})
        CONCRETE_METHOD_HASH(${target} ${hashType} value)

        IF (${value} STREQUAL ${HASH})
            RETURN()
        ENDIF(${value} STREQUAL ${HASH})

        CONCRETE_METHOD_REMOVE_FILE(FILES ${target})
    ENDIF(EXISTS ${target})

    SET(inactivityTimeout 5)
    SET(timeout 15)

    FILE(DOWNLOAD ${URI} ${target} 
        INACTIVITY_TIMEOUT ${inactivityTimeout}
        SHOW_PROGRESS
        TIMEOUT ${timeout}
        EXPECTED_HASH ${hashType}=${HASH}
    )
ENDFUNCTION(CONCRETE_METHOD_DOWNLOAD_FILE)
