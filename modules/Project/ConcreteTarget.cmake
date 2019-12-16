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

FUNCTION(CONCRETE_METHOD_ADD_TARGET)
    SET(options CREATE_ONLY IMPORTED IMPORTED_GLOBAL EXCLUDE_FROM_ALL)
    SET(singleValueKey TARGET_NAME TYPE ALIAS_TARGET UNITY_BUILD)
    SET(mulitValueKey PROPERTIES LINK_DIRECTORIES LINK_LIBRARIES LINK_OPTIONS INCLUDE_DIRECTORIES COMPILE_OPTIONS COMPILE_DEFINITIONS SOURCES)

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    IF(_CONCRETE_TARGET_NAME)
        SET(targetName ${_CONCRETE_TARGET_NAME})
    ElSE()
        MESSAGE(FATAL_ERROR "must set target name")
    ENDIF(_CONCRETE_TARGET_NAME)

    IF(${_CONCRETE_IMPORTED})
        SET(imported IMPORTED)

        IF(${_CONCRETE_IMPORTED_GLOBAL})
            LIST(APPEND imported GLOBAL)
        ENDIF(${_CONCRETE_IMPORTED_GLOBAL})

        SET(importedOrSources ${imported})
    ELSE()
        IF(_CONCRETE_SOURCES)
            SET(sources ${_CONCRETE_SOURCES})
        ENDIF(_CONCRETE_SOURCES)

        SET(importedOrSources ${sources})

        IF(${_CONCRETE_EXCLUDE_FROM_ALL})
            SET(excludeFromAll EXCLUDE_FROM_ALL)
        ENDIF(${_CONCRETE_EXCLUDE_FROM_ALL})
    ENDIF(${_CONCRETE_IMPORTED})

    SET(cotireBuild 1)

    IF(_CONCRETE_TYPE)
        IF(${_CONCRETE_TYPE} STREQUAL "Interface")
            ADD_LIBRARY(${targetName} INTERFACE ${imported})
            SET(cotireBuild 0)
        ENDIF(${_CONCRETE_TYPE} STREQUAL "Interface")

        IF(${_CONCRETE_TYPE} STREQUAL "Execute")
            ADD_EXECUTABLE(${targetName} ${sources})
        ENDIF(${_CONCRETE_TYPE} STREQUAL "Execute")

        IF(${_CONCRETE_TYPE} STREQUAL "Static")
            ADD_LIBRARY(${targetName} STATIC ${importedOrSources} ${excludeFromAll})
        ENDIF(${_CONCRETE_TYPE} STREQUAL "Static")

        IF(${_CONCRETE_TYPE} STREQUAL "Shared")
            ADD_LIBRARY(${targetName} SHARED ${importedOrSources} ${excludeFromAll})
        ENDIF(${_CONCRETE_TYPE} STREQUAL "Shared")

        IF(${_CONCRETE_TYPE} STREQUAL "Module")    
            ADD_LIBRARY(${targetName} Module ${importedOrSources} ${excludeFromAll})
        ENDIF(${_CONCRETE_TYPE} STREQUAL "Module")

        IF(${_CONCRETE_TYPE} STREQUAL "Object")    
            ADD_LIBRARY(${targetName} OBJECT ${importedOrSources})
        ENDIF(${_CONCRETE_TYPE} STREQUAL "Object")

        IF(${_CONCRETE_TYPE} STREQUAL "Unknown")    
            ADD_LIBRARY(${targetName} UNKNOWN ${imported})
        ENDIF(${_CONCRETE_TYPE} STREQUAL "Unknown")

        IF(${_CONCRETE_TYPE} STREQUAL "Alias")
            IF(_CONCRETE_ALIAS_TARGET)
                ADD_LIBRARY(${targetName} ALIAS ${_CONCRETE_ALIAS_TARGET})
            ELSE()
                MESSAGE(FATAL_ERROR "must set alias target when add alias target")
            ENDIF(_CONCRETE_ALIAS_TARGET)
        ENDIF(${_CONCRETE_TYPE} STREQUAL "Alias")
    ELSE()
        MESSAGE(FATAL_ERROR "target must have type")
    ENDIF(_CONCRETE_TYPE)

    IF(DEFINED _CONCRETE_UNITY_BUILD)
        SET_PROPERTY(TARGET ${targetName} PROPERTY USE_UNITY_BUILD ${_CONCRETE_UNITY_BUILD})
    ENDIF(DEFINED _CONCRETE_UNITY_BUILD)

    IF(${cotireBuild})
        CONCRETE_INTERNAL_METHOD_IS_USE_UNITY_BUILD(${targetName} useUnityBuild)
    ELSE()
        SET(useUnityBuild 0)
    ENDIF(${cotireBuild})

    IF(${_CONCRETE_CREATE_ONLY})
        IF(${cotireBuild} AND ${useUnityBuild})
            cotire(${targetName})
        ENDIF(${cotireBuild} AND ${useUnityBuild})
        
        RETURN()
    ENDIF(${_CONCRETE_CREATE_ONLY})
    
    IF(_CONCRETE_PROPERTIES)
        SET_TARGET_PROPERTIES(${targetName} PROPERTIES ${_CONCRETE_PROPERTIES})
    ENDIF(_CONCRETE_PROPERTIES)

    IF(_CONCRETE_LINK_OPTIONS)
        TARGET_LINK_OPTIONS(${targetName} ${_CONCRETE_LINK_OPTIONS})
    ENDIF(_CONCRETE_LINK_OPTIONS)

    IF (_CONCRETE_LINK_DIRECTORIES)
        TARGET_LINK_DIRECTORIES(${targetName} ${_CONCRETE_LINK_DIRECTORIES})
    ENDIF(_CONCRETE_LINK_DIRECTORIES)

    IF(_CONCRETE_LINK_LIBRARIES)
        TARGET_LINK_LIBRARIES(${targetName} PRIVATE $<TARGET_NAME:ConcreteInterface> ${_CONCRETE_LINK_LIBRARIES})
    ELSE()
        TARGET_LINK_LIBRARIES(${targetName} PRIVATE $<TARGET_NAME:ConcreteInterface>)
    ENDIF(_CONCRETE_LINK_LIBRARIES)

    IF(_CONCRETE_INCLUDE_DIRECTORIES)
        TARGET_INCLUDE_DIRECTORIES(${targetName} ${_CONCRETE_INCLUDE_DIRECTORIES})
    ENDIF(_CONCRETE_INCLUDE_DIRECTORIES)

    IF(_CONCRETE_COMPILE_OPTIONS)
        TARGET_COMPILE_OPTIONS(${targetName} ${_CONCRETE_COMPILE_OPTIONS})
    ENDIF(_CONCRETE_COMPILE_OPTIONS)

    IF(_CONCRETE_COMPILE_DEFINITIONS)
        TARGET_COMPILE_DEFINITIONS(${targetName} ${_CONCRETE_COMPILE_DEFINITIONS})
    ENDIF(_CONCRETE_COMPILE_DEFINITIONS)

    IF(${cotireBuild} AND ${useUnityBuild})
        cotire(${targetName})
    ENDIF(${cotireBuild} AND ${useUnityBuild})
ENDFUNCTION(CONCRETE_METHOD_ADD_TARGET)