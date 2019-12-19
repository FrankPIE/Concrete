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

FUNCTION(CONCRETE_METHOD_SOURCE_LIST LIST)
    SET(options)

    SET(macros "MSVC")

    FOREACH(macro ${macros})
        LIST(APPEND singleValueKey "${macro}_SOURCES_FOLDER")
        LIST(APPEND mulitValueKey "${macro}_SOURCES")
    ENDFOREACH(macro ${macros})

    LIST(APPEND singleValueKey "SOURCES_FOLDER")
    LIST(APPEND mulitValueKey "SOURCES")

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    IF (_CONCRETE_SOURCES)
        LIST(APPEND ${LIST} ${_CONCRETE_SOURCES})

        IF (_CONCRETE_SOURCES_FOLDER)
            SOURCE_GROUP(${_CONCRETE_SOURCES_FOLDER} FILES ${_CONCRETE_SOURCES})
        ENDIF(_CONCRETE_SOURCES_FOLDER)

    ENDIF(_CONCRETE_SOURCES)    

    IF(MSVC)
        IF(_CONCRETE_MSVC_SOURCES)
            LIST(APPEND ${LIST} ${_CONCRETE_MSVC_SOURCES})
            SET(${LIST}_MSVC ${_CONCRETE_MSVC_SOURCES} PARENT_SCOPE)

            IF (_CONCRETE_MSVC_SOURCES_FOLDER)
                SOURCE_GROUP(${_CONCRETE_MSVC_SOURCES_FOLDER} FILES ${_CONCRETE_MSVC_SOURCES})
            ENDIF(_CONCRETE_MSVC_SOURCES_FOLDER)
        ENDIF(_CONCRETE_MSVC_SOURCES)
    ENDIF(MSVC)

    SET(${LIST} ${${LIST}} PARENT_SCOPE)
ENDFUNCTION(CONCRETE_METHOD_SOURCE_LIST)

FUNCTION(CONCRETE_METHOD_SOURCE_DIRECTORY_ANALYSE PREFIX DIRECTORY)
    SET(options)
    SET(singleValueKey)
    SET(mulitValueKey EXT)     

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    IF(_CONCRETE_EXT)
        FOREACH(var ${_CONCRETE_EXT})
            LIST(APPEND expressions "${DIRECTORY}/*.${var}")
        ENDFOREACH(var ${_CONCRETE_EXT})

        SET(exts ${_CONCRETE_EXT})
    ELSE()
        LIST(APPEND expressions "${DIRECTORY}/*.*")
    ENDIF(_CONCRETE_EXT)

    FILE(GLOB_RECURSE children LIST_DIRECTORIES false RELATIVE ${DIRECTORY} ${expressions})

    FOREACH(child ${children})
        GET_FILENAME_COMPONENT(dir  ${child} DIRECTORY)
        GET_FILENAME_COMPONENT(file ${child} NAME)
        GET_FILENAME_COMPONENT(ext  ${child} LAST_EXT)

        IF ("${dir}" STREQUAL "")
            SET(dir "root")
            SET(dirName "ROOT")

            SET("${PREFIX}_${dirName}_DIR" "${DIRECTORY}" PARENT_SCOPE)
            SET("${PREFIX}_${dirName}_DIR_NAME" "" PARENT_SCOPE)

            SET(sourceFile "${DIRECTORY}/${file}")
        ELSE()
            STRING(REPLACE "/" "_" dirName "${dir}")
            STRING(REPLACE "/" "\\" dirGroup "${dir}")
            STRING(TOUPPER ${dirName} dirName)

            SET("${PREFIX}_${dirName}_DIR" "${DIRECTORY}/${dir}" PARENT_SCOPE)
            SET("${PREFIX}_${dirName}_DIR_NAME" "${dirGroup}" PARENT_SCOPE)

            SET(sourceFile "${DIRECTORY}/${dir}/${file}")
        ENDIF("${dir}" STREQUAL "")

        LIST(APPEND "${PREFIX}_${dirName}_SOURCES" "${sourceFile}")
        SET("${PREFIX}_${dirName}_SOURCES" "${${PREFIX}_${dirName}_SOURCES}" PARENT_SCOPE)

        LIST(APPEND "${PREFIX}_ALL_SOURCES" "${sourceFile}")

        IF (NOT "${exts}" STREQUAL "")
            STRING(SUBSTRING ${ext} 1 -1 extName)
            STRING(TOUPPER ${extName} extName)

            LIST(APPEND "${PREFIX}_${dirName}_SOURCES_${extName}" "${sourceFile}")

            LIST(APPEND "${PREFIX}_ALL_SOURCES_${extName}" "${sourceFile}")

            SET("${PREFIX}_${dirName}_SOURCES_${extName}" "${${PREFIX}_${dirName}_SOURCES_${extName}}" PARENT_SCOPE)
        ENDIF(NOT "${exts}" STREQUAL "")
    ENDFOREACH(child ${children})

    SET("${PREFIX}_ALL_SOURCES" "${${PREFIX}_ALL_SOURCES}" PARENT_SCOPE)

    IF (NOT "${exts}" STREQUAL "")
        STRING(SUBSTRING ${ext} 1 -1 extName)
        STRING(TOUPPER ${extName} extName)

        SET("${PREFIX}_ALL_SOURCES_${extName}" "${${PREFIX}_ALL_SOURCES_${extName}}" PARENT_SCOPE)
    ENDIF(NOT "${exts}" STREQUAL "")
ENDFUNCTION(CONCRETE_METHOD_SOURCE_DIRECTORY_ANALYSE)