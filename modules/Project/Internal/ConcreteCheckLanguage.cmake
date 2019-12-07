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

INCLUDE(CheckLanguage)

FUNCTION(CONCRETE_INTERNAL_METHOD_CHECK_LANGUAGE LANG OUTPUT)
    CHECK_LANGUAGE(${LANG})

    IF(CMAKE_${LANG}_COMPILER)
        SET(${OUTPUT} 1 PARENT_SCOPE)
    ELSE()
        SET(${OUTPUT} 0 PARENT_SCOPE)
    ENDIF(CMAKE_${LANG}_COMPILER)
ENDFUNCTION(CONCRETE_INTERNAL_METHOD_CHECK_LANGUAGE)

FUNCTION(CONCRETE_INTERNAL_METHOD_ENABLE_LANGUAGE LANG)
    CONCRETE_INTERNAL_METHOD_CHECK_LANGUAGE(${LANG} found)

    IF (${found} EQUAL 1)
        ENABLE_LANGUAGE(${LANG})
    ELSE()
        MESSAGE(SEND_ERROR "${LANG} language compiler is not found")
    ENDIF(${found} EQUAL 1)
ENDFUNCTION(CONCRETE_INTERNAL_METHOD_ENABLE_LANGUAGE)