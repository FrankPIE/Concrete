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

function(concrete_download URI DEST_PATH HASH)
    set(options)
    set(singleValueKey HASH_TYPE)
    set(mulitValueKey)

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    if (_CONCRETE_HASH_TYPE)
        set(hashType ${_CONCRETE_HASH_TYPE})
    else()
        set(hashType SHA1)
    endif(_CONCRETE_HASH_TYPE)

    set(target ${CONCRETE_PROJECT_ROOT_DIRECTORY}/${DEST_PATH})

    if (EXISTS ${target})
        concrete_hash(${target} ${hashType} value)

        if (${value} STREQUAL ${HASH})
            return()
        endif(${value} STREQUAL ${HASH})

        concrete_remove_file(FILES ${target})
    endif(EXISTS ${target})

    set(inactivityTimeout 5)
    set(timeout 15)

    file(DOWNLOAD ${URI} ${target} 
        INACTIVITY_TIMEOUT ${inactivityTimeout}
        SHOW_PROGRESS
        TIMEOUT ${timeout}
        EXPECTED_HASH ${hashType}=${HASH}
    )
endfunction(concrete_download)
