# MIT License
# 
# Copyright (c) 2020 MadStrawberry
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

function(concrete_status)
    message(STATUS ${ARGN})
endfunction(concrete_status)

function(concrete_notice)
    message(NOTICE ${ARGN})
endfunction(concrete_notice)

function(concrete_error)
    message(FATAL_ERROR ${ARGN})
endfunction(concrete_error)

function(concrete_error_tip)
    message(SEND_ERROR ${ARGN})    
endfunction(concrete_error_tip)

function(concrete_warning)
    message(WARNING ${ARGN})    
endfunction(concrete_warning)

function(concrete_debug)
    message(DEBUG ${ARGN})
endfunction(concrete_debug)

function(concrete_trace)
    message(TRACE ${ARGN})
endfunction(concrete_trace)

function(concrete_verbose)
    message(VERBOSE ${ARGN})
endfunction(concrete_verbose)



