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

function(concrete_sources_list list)
    set(options)

    set(macros "MSVC")

    foreach(macro ${macros})
        list(APPEND singleValueKey "${macro}_SOURCES_FOLDER")
        list(APPEND mulitValueKey "${macro}_SOURCES")
    endforeach(macro ${macros})

    list(APPEND singleValueKey "SOURCES_FOLDER")
    list(APPEND mulitValueKey "SOURCES")

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    if (_CONCRETE_SOURCES)
        list(APPEND ${list} ${_CONCRETE_SOURCES})

        if (_CONCRETE_SOURCES_FOLDER)
            source_group(${_CONCRETE_SOURCES_FOLDER} FILES ${_CONCRETE_SOURCES})
        endif(_CONCRETE_SOURCES_FOLDER)

    endif(_CONCRETE_SOURCES)    

    if(MSVC)
        if(_CONCRETE_MSVC_SOURCES)
            list(APPEND ${list} ${_CONCRETE_MSVC_SOURCES})
            set(${list}_MSVC ${_CONCRETE_MSVC_SOURCES} PARENT_SCOPE)

            if (_CONCRETE_MSVC_SOURCES_FOLDER)
                source_group(${_CONCRETE_MSVC_SOURCES_FOLDER} FILES ${_CONCRETE_MSVC_SOURCES})
            endif(_CONCRETE_MSVC_SOURCES_FOLDER)
        endif(_CONCRETE_MSVC_SOURCES)
    endif(MSVC)

    set(${list} ${${list}} PARENT_SCOPE)
endfunction(concrete_sources_list)

function(concrete_source_directory_analyse PREFIX DIRECTORY)
    set(options)
    set(singleValueKey)
    set(mulitValueKey EXT)     

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    if(_CONCRETE_EXT)
        foreach(var ${_CONCRETE_EXT})
            list(APPEND expressions "${DIRECTORY}/*.${var}")
        endforeach(var ${_CONCRETE_EXT})

        set(exts ${_CONCRETE_EXT})
    else()
        list(APPEND expressions "${DIRECTORY}/*.*")
    endif(_CONCRETE_EXT)

    file(GLOB_RECURSE children LIST_DIRECTORIES false RELATIVE ${DIRECTORY} ${expressions})

    concrete_debug("Directory: ${DIRECTORY}")

    concrete_debug("Children: ${children}")

    foreach(child ${children})
        get_filename_component(dir  ${child} DIRECTORY)
        get_filename_component(file ${child} NAME)
        get_filename_component(ext  ${child} LAST_EXT)

        if ("${dir}" STREQUAL "")
            set(dir "root")
            set(dirName "ROOT")

            set("${PREFIX}_${dirName}_DIR" "${DIRECTORY}" PARENT_SCOPE)
            set("${PREFIX}_${dirName}_DIR_NAME" "" PARENT_SCOPE)

            set(sourceFile "${DIRECTORY}/${file}")
        else()
            string(REPLACE "/" "_" dirName "${dir}")
            string(REPLACE "/" "\\" dirGroup "${dir}")
            string(TOUPPER ${dirName} dirName)

            set("${PREFIX}_${dirName}_DIR" "${DIRECTORY}/${dir}" PARENT_SCOPE)
            set("${PREFIX}_${dirName}_DIR_NAME" "${dirGroup}" PARENT_SCOPE)

            set(sourceFile "${DIRECTORY}/${dir}/${file}")
        endif("${dir}" STREQUAL "")

        list(APPEND "${PREFIX}_${dirName}_SOURCES" "${sourceFile}")
        set("${PREFIX}_${dirName}_SOURCES" "${${PREFIX}_${dirName}_SOURCES}" PARENT_SCOPE)

        list(APPEND "${PREFIX}_ALL_SOURCES" "${sourceFile}")

        if (NOT "_${exts}" STREQUAL "_")
            string(SUBSTRING ${ext} 1 -1 extName)
            string(TOUPPER ${extName} extName)

            list(APPEND "${PREFIX}_${dirName}_SOURCES_${extName}" "${sourceFile}")

            list(APPEND "${PREFIX}_ALL_SOURCES_${extName}" "${sourceFile}")

            set("${PREFIX}_${dirName}_SOURCES_${extName}" "${${PREFIX}_${dirName}_SOURCES_${extName}}" PARENT_SCOPE)
        endif()
    endforeach(child ${children})

    set("${PREFIX}_ALL_SOURCES" "${${PREFIX}_ALL_SOURCES}" PARENT_SCOPE)

    if (NOT "_${exts}" STREQUAL "_")
        foreach(var ${exts})
            string(TOUPPER ${var} extName)        
            set("${PREFIX}_ALL_SOURCES_${extName}" "${${PREFIX}_ALL_SOURCES_${extName}}" PARENT_SCOPE)
        endforeach()
    endif()
endfunction(concrete_source_directory_analyse)