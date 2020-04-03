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

# TODO::For Directory Scope
function(concrete_is_use_unity_build TARGET OUTPUT)
    get_property(globalUnityBuildSet GLOBAL PROPERTY USE_UNITY_BUILD_FOR_ALL_TARGETS set)

    if (${globalUnityBuildSet})
        get_property(globalUnityBuild GLOBAL PROPERTY USE_UNITY_BUILD_FOR_ALL_TARGETS)
    else()
        set(globalUnityBuild 0)
    endif(${globalUnityBuildSet})

    get_property(unityBuildSet TARGET ${TARGET} PROPERTY USE_UNITY_BUILD set)

    if (${unityBuildSet})
        get_property(unityBuild TARGET ${TARGET} PROPERTY USE_UNITY_BUILD)
    else()
        set(unityBuild 0)
    endif(${unityBuildSet})

    # the target is use unity build
    # globalFlagSet globalFlag targetFlagSet targetFlag Result
    # 0             0          1             1          1
    # 1             /          1             1          1
    # 1             1          0             0          1
    # other                                             0

    if(${unityBuild})
        set(${OUTPUT} 1 PARENT_SCOPE)
        return()
    elseif(${globalUnityBuild} AND NOT ${unityBuildSet})
        set(${OUTPUT} 1 PARENT_SCOPE)
        return()
    endif(${unityBuild})

    set(${OUTPUT} 0 PARENT_SCOPE)
endfunction(concrete_is_use_unity_build)