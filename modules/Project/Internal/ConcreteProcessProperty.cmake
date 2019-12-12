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

# FUNCTION(CONCRETE_INTERNAL_METHOD_FIND_STRING FLAGS OUTPUT FLAG)
#     STRING(FIND "${${FLAGS}}" "${FLAG}" pos)

#     IF(NOT ${pos} EQUAL -1)
#         SET(${OUTPUT} TRUE PARENT_SCOPE)
#     ELSE()
#         SET(${OUTPUT} FALSE PARENT_SCOPE)
#     ENDIF(NOT ${pos} EQUAL -1)
# ENDFUNCTION(CONCRETE_INTERNAL_METHOD_FIND_STRING)

# FUNCTION(CONCRETE_INTERNAL_METHOD_FIND_ONE_OF_STRING FLAGS OUTPUT VALUE)
#     SET(${OUTPUT} FALSE PARENT_SCOPE)
#     SET(${VALUE} "" PARENT_SCOPE)

#     SET(index 3)
#     WHILE(${index} LESS_EQUAL ${ARGC})
#         STRING(FIND "${${FLAGS}}" "${ARGV${index}}" findPos)

#         IF(NOT ${findPos} EQUAL -1)
#             IF(${${OUTPUT}})
#                 MESSAGE(FATAL_ERROR "Too many match value")
#             ENDIF(${${OUTPUT}})

#             SET(${OUTPUT} TRUE PARENT_SCOPE)
#             SET(${VALUE} "${ARGV${index}}" PARENT_SCOPE)

#             RETURN()
#         ENDIF(NOT ${findPos} EQUAL -1)

#         MATH(EXPR index "${index} + 1")
#     ENDWHILE(${index} LESS_EQUAL ${ARGC})
# ENDFUNCTION(CONCRETE_INTERNAL_METHOD_FIND_ONE_OF_STRING)

# FUNCTION(CONCRETE_INTERNAL_METHOD_APPEND_FLAG FLAGS FLAG)
#     CONCRETE_INTERNAL_METHOD_FIND_STRING(${FLAGS} haveFlag ${FLAG})

#     IF(NOT haveFlag)
#         STRING(APPEND ${FLAGS} "${FLAG} ")

#         SET(${FLAGS} ${${FLAGS}} PARENT_SCOPE)
#     ENDIF(NOT haveFlag)
# ENDFUNCTION(CONCRETE_INTERNAL_METHOD_APPEND_FLAG)

# FUNCTION(CONCRETE_INTERNAL_METHOD_ADD_NDEBUG_FLAG FLAGS)
#     IF(MSVC)
#         CONCRETE_INTERNAL_METHOD_APPEND_FLAG(${FLAGS} "/DNDEBUG")

#         SET(${FLAGS} ${${FLAGS}} PARENT_SCOPE)
#     ENDIF(MSVC)
# ENDFUNCTION(CONCRETE_INTERNAL_METHOD_ADD_NDEBUG_FLAG)

# FUNCTION(CONCRETE_INTERNAL_METHOD_ADD_UNICODE_FLAG FLAGS)
#     IF(MSVC)
#         CONCRETE_INTERNAL_METHOD_APPEND_FLAG(${FLAGS} "/DUNICODE")
#         CONCRETE_INTERNAL_METHOD_APPEND_FLAG(${FLAGS} "/D_UNICODE")

#         SET(${FLAGS} ${${FLAGS}} PARENT_SCOPE)
#     ENDIF(MSVC)
# ENDFUNCTION(CONCRETE_INTERNAL_METHOD_ADD_UNICODE_FLAG)

# FUNCTION(CONCRETE_INTERNAL_METHOD_ADD_WARNING_LEVEL_FLAG FLAGS LEVEL)
#     IF(MSVC)
#         IF(${LEVEL} LESS 0 OR ${LEVEL} GREATER 4)
#             MESSAGE(FATAL_ERROR "Not supported warning level, range [0, 4]")
#         ENDIF(${LEVEL} LESS 0 OR ${LEVEL} GREATER 4)

#         CONCRETE_INTERNAL_METHOD_FIND_ONE_OF_STRING(${FLAGS} exist match "/W0" "/W1" "/W2" "/W3" "/W4")

#         IF(NOT ${exist})
#             STRING(APPEND ${FLAGS} "/W${LEVEL} ")
#         ELSE()
#             STRING(REPLACE ${match} "/W${LEVEL}" ${FLAGS} "${${FLAGS}}")
#         ENDIF(NOT ${exist})

#         SET(${FLAGS} ${${FLAGS}} PARENT_SCOPE)
#     ENDIF(MSVC)
# ENDFUNCTION(CONCRETE_INTERNAL_METHOD_ADD_WARNING_LEVEL_FLAG)

# FUNCTION(CONCRETE_INTERNAL_METHOD_ADD_DEBUG_INFO_FORMAT FLAGS FORMAT)
#     IF(MSVC)
#         IF (${FORMAT} STREQUAL "DEBUG_INFO_WRITE_IN_OBJ")
#             SET(format "/Z7")
#         ENDIF(${FORMAT} STREQUAL "DEBUG_INFO_WRITE_IN_OBJ")

#         IF (${FORMAT} STREQUAL "DEBUG_INFO_WRITE_IN_PDB")
#             SET(format "/Zi")
#         ENDIF(${FORMAT} STREQUAL "DEBUG_INFO_WRITE_IN_PDB")

#         IF (${FORMAT} STREQUAL "EDIT_AND_CONTINUE_MODE")
#             SET(format "/ZI")
#         ENDIF(${FORMAT} STREQUAL "EDIT_AND_CONTINUE_MODE")

#         IF (NOT DEFINED format)
#             MESSAGE(FATAL_ERROR "format should not be null")
#         ENDIF(NOT DEFINED format)

#         CONCRETE_INTERNAL_METHOD_FIND_ONE_OF_STRING(${FLAGS} exist match "/Z7" "/Zi" "/ZI")

#         IF(NOT ${exist})
#             STRING(APPEND ${FLAGS} "${format} ")
#         ELSE()
#             STRING(REPLACE ${match} "${format}" ${FLAGS} "${${FLAGS}}")
#         ENDIF(NOT ${exist})

#         SET(${FLAGS} ${${FLAGS}} PARENT_SCOPE)
#     ENDIF(MSVC)
# ENDFUNCTION(CONCRETE_INTERNAL_METHOD_ADD_DEBUG_INFO_FORMAT)

# FUNCTION(CONCRETE_INTERNAL_METHOD_ADD_WARNING_AS_ERROR_FLAG FLAGS)
#     IF(MSVC)
#         CONCRETE_INTERNAL_METHOD_APPEND_FLAG(${FLAGS} "/WX")

#         SET(${FLAGS} ${${FLAGS}} PARENT_SCOPE)
#     ENDIF(MSVC)
# ENDFUNCTION(CONCRETE_INTERNAL_METHOD_ADD_WARNING_AS_ERROR_FLAG)