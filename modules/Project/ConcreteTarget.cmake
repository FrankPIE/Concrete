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

function(concrete_target)
    set(options CREATE_ONLY IMPORTED IMPORTED_GLOBAL EXCLUDE_FROM_ALL)
    set(singleValueKey TARGET_NAME TYPE ALIAS_TARGET UNITY_BUILD FOLDER)
    set(mulitValueKey IMPORTED_CONFIGURATIONS PROPERTIES LINK_DIRECTORIES LINK_LIBRARIES LINK_OPTIONS INCLUDE_DIRECTORIES COMPILE_OPTIONS COMPILE_DEFINITIONS SOURCES)

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    if(_CONCRETE_TARGET_NAME)
        set(targetName ${_CONCRETE_TARGET_NAME})
    else()
        concrete_error("must set target name")
    endif(_CONCRETE_TARGET_NAME)

    set(cotireBuild 1)
    set(onlyInteface OFF)
    set(isImported OFF)

    if(${_CONCRETE_IMPORTED})
        set(imported IMPORTED)
        set(isImported ON)

        if(${_CONCRETE_IMPORTED_GLOBAL})
            LIST(APPEND imported GLOBAL)
        endif(${_CONCRETE_IMPORTED_GLOBAL})

        set(onlyInteface ON)

        set(importedOrSources ${imported})
    else()
        if(_CONCRETE_SOURCES)
            set(sources ${_CONCRETE_SOURCES})
        endif(_CONCRETE_SOURCES)

        set(importedOrSources ${sources})

        if(${_CONCRETE_EXCLUDE_FROM_ALL})
            set(excludeFromAll EXCLUDE_FROM_ALL)
        endif(${_CONCRETE_EXCLUDE_FROM_ALL})
    endif(${_CONCRETE_IMPORTED})

    if(_CONCRETE_TYPE)
        if(${_CONCRETE_TYPE} STREQUAL "Interface")
            add_library(${targetName} INTERFACE ${imported})
            set(cotireBuild 0)
            set(onlyInteface ON)
        endif(${_CONCRETE_TYPE} STREQUAL "Interface")

        if(${_CONCRETE_TYPE} STREQUAL "Execute")
            add_executable(${targetName} ${sources})
        endif(${_CONCRETE_TYPE} STREQUAL "Execute")

        if(${_CONCRETE_TYPE} STREQUAL "Static")
            add_library(${targetName} STATIC ${importedOrSources} ${excludeFromAll})
        endif(${_CONCRETE_TYPE} STREQUAL "Static")

        if(${_CONCRETE_TYPE} STREQUAL "Shared")
            add_library(${targetName} SHARED ${importedOrSources} ${excludeFromAll})
        endif(${_CONCRETE_TYPE} STREQUAL "Shared")

        if(${_CONCRETE_TYPE} STREQUAL "Module")    
            add_library(${targetName} Module ${importedOrSources} ${excludeFromAll})
        endif(${_CONCRETE_TYPE} STREQUAL "Module")

        if(${_CONCRETE_TYPE} STREQUAL "Object")    
            add_library(${targetName} OBJECT ${importedOrSources})
        endif(${_CONCRETE_TYPE} STREQUAL "Object")

        if(${_CONCRETE_TYPE} STREQUAL "Unknown")    
            add_library(${targetName} UNKNOWN ${imported})
        endif(${_CONCRETE_TYPE} STREQUAL "Unknown")

        if(${_CONCRETE_TYPE} STREQUAL "Alias")
            if(_CONCRETE_ALIAS_TARGET)
                add_library(${targetName} ALIAS ${_CONCRETE_ALIAS_TARGET})
            else()
                concrete_error("must set alias target when add alias target")
            endif(_CONCRETE_ALIAS_TARGET)
        endif(${_CONCRETE_TYPE} STREQUAL "Alias")
    else()
        concrete_error("target must have type")
    endif(_CONCRETE_TYPE)

    if (${isImported})
        if (_CONCRETE_IMPORTED_CONFIGURATIONS)
            set_property(TARGET ${targetName} APPEND PROPERTY IMPORTED_CONFIGURATIONS ${_CONCRETE_IMPORTED_CONFIGURATIONS})
        endif()
    endif()

    if(DEFINED _CONCRETE_UNITY_BUILD)
        set_property(TARGET ${targetName} PROPERTY USE_UNITY_BUILD ${_CONCRETE_UNITY_BUILD})
    endif(DEFINED _CONCRETE_UNITY_BUILD)

    if(${cotireBuild})
        concrete_is_use_unity_build(${targetName} useUnityBuild)
    else()
        set(useUnityBuild 0)
    endif(${cotireBuild})

    if(${_CONCRETE_CREATE_ONLY})
        if(${cotireBuild} AND ${useUnityBuild})
            cotire(${targetName})
        endif(${cotireBuild} AND ${useUnityBuild})
        
        return()
    endif(${_CONCRETE_CREATE_ONLY})
    
    if(_CONCRETE_PROPERTIES)
        set_target_properties(${targetName} PROPERTIES ${_CONCRETE_PROPERTIES})
    endif(_CONCRETE_PROPERTIES)

    if(_CONCRETE_LINK_OPTIONS)
        target_link_options(${targetName} ${_CONCRETE_LINK_OPTIONS})
    endif(_CONCRETE_LINK_OPTIONS)

    if (_CONCRETE_LINK_DIRECTORIES)
        target_link_directories(${targetName} ${_CONCRETE_LINK_DIRECTORIES})
    endif(_CONCRETE_LINK_DIRECTORIES)

    if(${onlyInteface})
        set(concreteInterfaceKeyWord INTERFACE)
    else()
        set(concreteInterfaceKeyWord PRIVATE)
    endif(${onlyInteface})
    
    if(_CONCRETE_LINK_LIBRARIES)
        target_link_libraries(${targetName} ${concreteInterfaceKeyWord} $<$<NOT:$<BOOL:${isImported}>>:$<TARGET_NAME:ConcreteInterface>> ${_CONCRETE_LINK_LIBRARIES})
    else()
        target_link_libraries(${targetName} ${concreteInterfaceKeyWord} $<$<NOT:$<BOOL:${isImported}>>:$<TARGET_NAME:ConcreteInterface>>)
    endif(_CONCRETE_LINK_LIBRARIES)

    if(_CONCRETE_INCLUDE_DIRECTORIES)
        target_include_directories(${targetName} ${_CONCRETE_INCLUDE_DIRECTORIES})
    endif(_CONCRETE_INCLUDE_DIRECTORIES)

    if(_CONCRETE_COMPILE_OPTIONS)
        target_compile_options(${targetName} ${_CONCRETE_COMPILE_OPTIONS})
    endif(_CONCRETE_COMPILE_OPTIONS)

    if(_CONCRETE_COMPILE_DEFINITIONS)
        target_compile_definitions(${targetName} ${_CONCRETE_COMPILE_DEFINITIONS})
    endif(_CONCRETE_COMPILE_DEFINITIONS)

    if(${cotireBuild} AND ${useUnityBuild})
        cotire(${targetName})
    endif(${cotireBuild} AND ${useUnityBuild})

    if (_CONCRETE_FOLDER)
        set(folderName ${_CONCRETE_FOLDER})

        if(NOT ${folderName} STREQUAL "")
            set_property(TARGET ${targetName} PROPERTY FOLDER "${folderName}")
        endif(NOT ${folderName} STREQUAL "")
    endif(_CONCRETE_FOLDER)
endfunction(concrete_target)