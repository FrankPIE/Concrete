CMAKE_MINIMUM_REQUIRED(VERSION 3.0.2)

SET(CONCRETE_COMPILER_DEFINITIONS)

# TODO https://www.cnblogs.com/navysummer/p/10251537.html
INCLUDE(CheckCCompilerFlag)
INCLUDE(CheckCXXCompilerFlag)
INCLUDE(CheckIncludeFile)
INCLUDE(CheckIncludeFiles)
INCLUDE(CheckIncludeFileCXX)

MACRO(_CONCRETE_CHECK_INCLUDE_FILES)
    # check stdbool.h
    CHECK_INCLUDE_FILE(stdbool.h _CONCRETE_EXIST_INCUDLE_FILE_STDBOOL)

    IF(${_CONCRETE_EXIST_INCUDLE_FILE_STDBOOL} EQUAL 1)
        LIST(APPEND CONCRETE_COMPILER_DEFINITIONS -DCONCRETE_C99_BOOL_TYPE_SUPPORT) 
    ENDIF()
ENDMACRO(_CONCRETE_CHECK_INCLUDE_FILES)