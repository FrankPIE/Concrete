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

include(CheckLanguage)

################## function start ############################
### check specify language is supported or not
### LANG : specify language name
### OUTPUT : out bool variable, if the value is 1 mean support, 0 mean not support 
function(concrete_check_language_supported LANG OUTPUT)
    set(languageSet
        C CXX CUDA OBJC OBJCXX Fortran ASM ASM_MASM ASM_NASM ASM_ATT 
    )

    # find from language set
    list(FIND languageSet ${LANG} output)

    # use PARENT_SCOPE make output into directory scope, not at function scope,
    # make a return value
    if (${output} EQUAL -1)
        set(${OUTPUT} 0 PARENT_SCOPE)
    else()
        set(${OUTPUT} 1 PARENT_SCOPE)        
    endif(${output} EQUAL -1)
endfunction(concrete_check_language_supported)
################## function end ############################

################## function start ############################
function(concrete_check_language LANG OUTPUT)
    CHECK_LANGUAGE(${LANG})

    if(CMAKE_${LANG}_COMPILER)
        set(${OUTPUT} 1 PARENT_SCOPE)
    else()
        set(${OUTPUT} 0 PARENT_SCOPE)
    endif(CMAKE_${LANG}_COMPILER)
endfunction(concrete_check_language)
################## function end ############################

################## function start ############################
function(concrete_enable_language LANG)
    concrete_check_language(${LANG} found)

    if (${found} EQUAL 1)
        enable_language(${LANG})
    else()
        concrete_error_tip("${LANG} language compiler is not found")
    endif(${found} EQUAL 1)
endfunction(concrete_enable_language)
################## function end ############################
