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

function(concrete_build_type_copy TO FROM)    
    if(CMAKE_CONFIGURATION_TYPES)
        set(buildTypes ${CMAKE_CONFIGURATION_TYPES})
    else()
        set(buildTypes ${CMAKE_BUILD_TYPE})
    endif()

    # upper
    foreach(var ${buildTypes})
        string(TOUPPER "${var}" upperValue)

        list(APPEND _buildTypes ${upperValue})
    endforeach()

    string(TOUPPER "${TO}" toUpperValue)
    list(FIND _buildTypes ${toUpperValue} index)

    if ("${index}" STREQUAL "-1")
        concrete_debug("can't find ${TO} build type")
        return()
    endif()

    string(TOUPPER "${FROM}" fromUpperValue)
    list(FIND _buildTypes ${fromUpperValue} index)

    if ("${index}" STREQUAL "-1")
        concrete_debug("can't find ${FROM} build type")
        return()
    endif()

    set_property(CACHE CMAKE_EXE_LINKER_FLAGS_${toUpperValue} PROPERTY VALUE "${CMAKE_EXE_LINKER_FLAGS_${fromUpperValue}}")
    set_property(CACHE CMAKE_RC_FLAGS_${toUpperValue} PROPERTY VALUE "${CMAKE_RC_FLAGS_${fromUpperValue}}")    
    set_property(CACHE CMAKE_SHARED_LINKER_FLAGS_${toUpperValue} PROPERTY VALUE "${CMAKE_SHARED_LINKER_FLAGS_${fromUpperValue}}")    

    get_property(languages GLOBAL PROPERTY ENABLED_LANGUAGES)

    foreach(lang ${languages})
        string(TOUPPER "${lang}" langUpperValue)

        if ("${langUpperValue}" STREQUAL "NONE")
            continue()
        endif()

        set_property(CACHE CMAKE_${langUpperValue}_FLAGS_${toUpperValue} PROPERTY VALUE "${CMAKE_${langUpperValue}_FLAGS_${fromUpperValue}}")
    endforeach(lang ${languages})    
endfunction(concrete_build_type_copy)