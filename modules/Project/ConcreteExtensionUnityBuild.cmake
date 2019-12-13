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

# TODO::For Directory Scope
FUNCTION(CONCRETE_INTERNAL_METHOD_IS_USE_UNITY_BUILD TARGET OUTPUT)
    GET_PROPERTY(globalUnityBuildSet GLOBAL PROPERTY USE_UNITY_BUILD_FOR_ALL_TARGETS SET)

    IF (${globalUnityBuildSet})
        GET_PROPERTY(globalUnityBuild GLOBAL PROPERTY USE_UNITY_BUILD_FOR_ALL_TARGETS)
    ELSE()
        SET(globalUnityBuild 0)
    ENDIF(${globalUnityBuildSet})

    GET_PROPERTY(unityBuildSet TARGET ${TARGET} PROPERTY USE_UNITY_BUILD SET)

    IF (${unityBuildSet})
        GET_PROPERTY(unityBuild TARGET ${TARGET} PROPERTY USE_UNITY_BUILD)
    ELSE()
        SET(unityBuild 0)
    ENDIF(${unityBuildSet})

    # the target is use unity build
    # globalFlagSet globalFlag targetFlagSet targetFlag Result
    # 0             0          1             1          1
    # 1             /          1             1          1
    # 1             1          0             0          1
    # other                                             0
    IF(NOT ${globalUnityBuildSet})
        IF(${unityBuild})
            SET(${OUTPUT} 1 PARENT_SCOPE)
            RETURN()
        ENDIF(${unityBuild})
    ELSE()
        IF(${unityBuild})
            SET(${OUTPUT} 1 PARENT_SCOPE)
            RETURN()                
        ENDIF(${unityBuild})

        IF(${globalUnityBuild})
            IF(NOT ${unityBuildSet})
                SET(${OUTPUT} 1 PARENT_SCOPE)
                RETURN()                
            ENDIF(NOT ${unityBuildSet})
        ENDIF(${globalUnityBuild})        
    ENDIF(NOT ${globalUnityBuildSet})    

    SET(${OUTPUT} 0 PARENT_SCOPE)
ENDFUNCTION(CONCRETE_INTERNAL_METHOD_IS_USE_UNITY_BUILD)