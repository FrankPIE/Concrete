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

INCLUDE( CMakeParseArguments )

MACRO(CONCRETE_METHOD_INITIALIZATION)     
    SET(options PROJECT_GEN_COMPILER_TARGET_DIR PROJECT_LANGUAGE_C PROJECT_LANGUAGE_CXX PROJECT_LANGUAGE_CUDA PROJECT_LANGUAGE_OBJC PROJECT_LANGUAGE_OBJCXX PROJECT_LANGUAGE_FORTRAN PROJECT_LANGUAGE_ASM)

    SET(singleValueKey PROJECT_NAME PROJECT_DESCRIPTION PROJECT_HOMEPAGE_URL PROJECT_ROOT_DIR PROJECT_ PROJECT_BINARY_OUTPUT_DIR PROJECT_LIBRARY_OUTPUT_DIR)
    
    SET(mulitValueKey PROJECT_VERSION)

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    UNSET(options)
    UNSET(singleValueKey)
    UNSET(mulitValueKey)

    # begin set project
    IF(_CONCRETE_PROJECT_NAME)
        SET(CONCRETE_PROJECT_NAME ${_CONCRETE_PROJECT_NAME} CACHE INTERNAL "project name" FORCE)
    ELSE()
        MESSAGE(FATAL_ERROR "Project name must be set")
    ENDIF(_CONCRETE_PROJECT_NAME)

    SET(languages)

    # C
    IF(${_CONCRETE_PROJECT_LANGUAGE_C})
        SET(languages ${languages} C)
    ENDIF(${_CONCRETE_PROJECT_LANGUAGE_C})

    # CXX
    IF(${_CONCRETE_PROJECT_LANGUAGE_CXX})
        SET(languages ${languages} CXX)
    ENDIF(${_CONCRETE_PROJECT_LANGUAGE_CXX})

    # CUDA
    IF(${_CONCRETE_PROJECT_LANGUAGE_CUDA})
        SET(languages ${languages} CUDA)
    ENDIF(${_CONCRETE_PROJECT_LANGUAGE_CUDA})

    # OBJC
    IF(${_CONCRETE_PROJECT_LANGUAGE_OBJC})
        SET(languages ${languages} OBJC)
    ENDIF(${_CONCRETE_PROJECT_LANGUAGE_OBJC})

    # OBJCXX
    IF(${_CONCRETE_PROJECT_LANGUAGE_OBJCXX})
        SET(languages ${languages} OBJCXX)
    ENDIF(${_CONCRETE_PROJECT_LANGUAGE_OBJC})

    # Fortran
    IF(${_CONCRETE_PROJECT_LANGUAGE_FORTRAN})
        SET(languages ${languages} Fortran)
    ENDIF(${_CONCRETE_PROJECT_LANGUAGE_FORTRAN})

    # ASM
    IF(${_CONCRETE_PROJECT_LANGUAGE_ASM})
        SET(languages ${languages} ASM)
    ENDIF(${_CONCRETE_PROJECT_LANGUAGE_ASM})

    SET(languagesListLenght)
    LIST(LENGTH languages languagesListLenght)

    ####################################################################
    IF(_CONCRETE_PROJECT_VERSION)
        SET(versionListLength)

        LIST(LENGTH _CONCRETE_PROJECT_VERSION versionListLength)

        IF (${versionListLength} GREATER 0)
            SET(major)
            LIST(GET _CONCRETE_PROJECT_VERSION 0 major)
            SET(CONCRETE_PROJECT_SOFTWARE_VERSION_MAJOR ${major} CACHE INTERNAL "software version major" FORCE)
            UNSET(major)
            SET(CONCRETE_PROJECT_SOFTWARE_VERSION "${CONCRETE_PROJECT_SOFTWARE_VERSION_MAJOR}" CACHE INTERNAL "software version" FORCE)
        ENDIF(${versionListLength} GREATER 0)

        IF (${versionListLength} GREATER 1)
            SET(minor)
            LIST(GET _CONCRETE_PROJECT_VERSION 1 minor)
            SET(CONCRETE_PROJECT_SOFTWARE_VERSION_MINOR ${minor} CACHE INTERNAL "software version minor" FORCE)
            UNSET(minor)
            SET(CONCRETE_PROJECT_SOFTWARE_VERSION "${CONCRETE_PROJECT_SOFTWARE_VERSION_MAJOR}.${CONCRETE_PROJECT_SOFTWARE_VERSION_MINOR}" CACHE INTERNAL "software version" FORCE)
        ENDIF(${versionListLength} GREATER 1)

        IF (${versionListLength} GREATER 2)
            SET(patch)
            LIST(GET _CONCRETE_PROJECT_VERSION 2 patch)
            SET(CONCRETE_PROJECT_SOFTWARE_VERSION_PATCH ${patch} CACHE INTERNAL "software version patch" FORCE)
            UNSET(patch)
            SET(CONCRETE_PROJECT_SOFTWARE_VERSION "${CONCRETE_PROJECT_SOFTWARE_VERSION_MAJOR}.${CONCRETE_PROJECT_SOFTWARE_VERSION_MINOR}.${CONCRETE_PROJECT_SOFTWARE_VERSION_PATCH}" CACHE INTERNAL "software version" FORCE)
        ENDIF(${versionListLength} GREATER 2)

        IF (${versionListLength} GREATER 3)
            SET(tweak)
            LIST(GET _CONCRETE_PROJECT_VERSION 3 tweak)
            SET(CONCRETE_PROJECT_SOFTWARE_VERSION_TWEAK ${tweak} CACHE INTERNAL "software version tweak" FORCE)
            UNSET(tweak)
            SET(CONCRETE_PROJECT_SOFTWARE_VERSION "${CONCRETE_PROJECT_SOFTWARE_VERSION_MAJOR}.${CONCRETE_PROJECT_SOFTWARE_VERSION_MINOR}.${CONCRETE_PROJECT_SOFTWARE_VERSION_PATCH}.${CONCRETE_PROJECT_SOFTWARE_VERSION_TWEAK}" CACHE INTERNAL "software version" FORCE)
        ENDIF(${versionListLength} GREATER 3)

        UNSET(versionListLength)
    ENDIF(_CONCRETE_PROJECT_VERSION)

    IF (_CONCRETE_PROJECT_DESCRIPTION)
        SET(CONCRETE_PROJECT_DESCRIPTION ${_CONCRETE_PROJECT_DESCRIPTION} CACHE INTERNAL "project description" FORCE)
    ENDIF(_CONCRETE_PROJECT_DESCRIPTION)

    IF (_CONCRETE_PROJECT_HOMEPAGE_URL)
        SET(CONCRETE_PROJECT_HOMEPAGE_URL ${_CONCRETE_PROJECT_HOMEPAGE_URL} CACHE INTERNAL "project homepage url" FORCE)
    ENDIF(_CONCRETE_PROJECT_HOMEPAGE_URL)

    SET(cmakeVersion "$CACHE{CMAKE_CACHE_MAJOR_VERSION}.$CACHE{CMAKE_CACHE_MINOR_VERSION}.$CACHE{CMAKE_CACHE_PATCH_VERSION}")

    IF ( ${cmakeVersion} VERSION_GREATER_EQUAL "3.12.4")
        IF (${languagesListLenght} GREATER 0)
            IF (_CONCRETE_PROJECT_VERSION)

                PROJECT(${CONCRETE_PROJECT_NAME} 
                        LANGUAGES ${languages} 
                        VERSION ${CONCRETE_PROJECT_SOFTWARE_VERSION} 
                        DESCRIPTION ${CONCRETE_PROJECT_DESCRIPTION} 
                        HOMEPAGE_URL ${CONCRETE_PROJECT_HOMEPAGE_URL}
                        )
            ELSE()

                PROJECT(${CONCRETE_PROJECT_NAME}
                        LANGUAGES ${languages} 
                        DESCRIPTION ${CONCRETE_PROJECT_DESCRIPTION}
                        HOMEPAGE_URL ${CONCRETE_PROJECT_HOMEPAGE_URL}
                        )
            ENDIF(_CONCRETE_PROJECT_VERSION)
        ELSE()
            IF (_CONCRETE_PROJECT_VERSION)

                PROJECT(${CONCRETE_PROJECT_NAME}
                        VERSION ${CONCRETE_PROJECT_SOFTWARE_VERSION} 
                        DESCRIPTION ${CONCRETE_PROJECT_DESCRIPTION}
                        HOMEPAGE_URL ${CONCRETE_PROJECT_HOMEPAGE_URL}
                        )
            ELSE()

                PROJECT(${CONCRETE_PROJECT_NAME} 
                        DESCRIPTION ${CONCRETE_PROJECT_DESCRIPTION}
                        HOMEPAGE_URL ${CONCRETE_PROJECT_HOMEPAGE_URL}
                        )

            ENDIF(_CONCRETE_PROJECT_VERSION)
        ENDIF(${languagesListLenght} GREATER 0)
    ELSE()
        IF (${languagesListLenght} GREATER 0)
            IF (_CONCRETE_PROJECT_VERSION)

                PROJECT(${CONCRETE_PROJECT_NAME}
                        LANGUAGES ${languages} 
                        VERSION ${CONCRETE_PROJECT_SOFTWARE_VERSION} 
                        DESCRIPTION ${CONCRETE_PROJECT_DESCRIPTION}
                        )

            ELSE()

                PROJECT(${CONCRETE_PROJECT_NAME} 
                        LANGUAGES ${languages} 
                        DESCRIPTION ${CONCRETE_PROJECT_DESCRIPTION}
                        )

            ENDIF(_CONCRETE_PROJECT_VERSION)
        ELSE()
            IF (_CONCRETE_PROJECT_VERSION)

                PROJECT(${CONCRETE_PROJECT_NAME} 
                        VERSION ${CONCRETE_PROJECT_SOFTWARE_VERSION} 
                        DESCRIPTION ${CONCRETE_PROJECT_DESCRIPTION}
                        )
                        
            ELSE()

                PROJECT(${CONCRETE_PROJECT_NAME} 
                        DESCRIPTION ${CONCRETE_PROJECT_DESCRIPTION}
                        )

            ENDIF(_CONCRETE_PROJECT_VERSION)
        ENDIF(${languagesListLenght} GREATER 0)
    ENDIF($<VERSION_GREATER_EQUAL:"$CACHE{CMAKE_CACHE_MAJOR_VERSION}.$CACHE{CMAKE_CACHE_MINOR_VERSION}.$CACHE{CMAKE_CACHE_PATCH_VERSION}""3.12.4">)

    UNSET(cmakeVersion)
    UNSET(languagesListLenght)
    UNSET(languages)

    # end set project 

    CONCRETE_METHOD_COLLECT_SYSTEM_INFORMATION()

    SET(CONCRETE_PROJECT_NAME ${CMAKE_PROJECT_NAME} CACHE INTERNAL "project name" FORCE)

    IF(_CONCRETE_PROJECT_ROOT_DIR)
        SET(CONCRETE_PROJECT_ROOT_DIRECTORY ${_CONCRETE_PROJECT_ROOT_DIR} CACHE PATH "prject root dir default as ${CMAKE_HOME_DIRECTORY}" FORCE)
    ELSE(_CONCRETE_PROJECT_ROOT_DIR)
        SET(CONCRETE_PROJECT_ROOT_DIRECTORY "${${CMAKE_PROJECT_NAME}_BINARY_DIR}" CACHE PATH "prject root dir default as ${CMAKE_HOME_DIRECTORY}" FORCE)
    ENDIF(_CONCRETE_PROJECT_ROOT_DIR)

    # begin set compiler target
    # set platform compiler target x86 or x64 or arm(not supported yet)
    IF (CMAKE_CL_64)
        SET(CONCRETE_PROJECT_COMPILER_TARGET x64 CACHE INTERNAL "project compiler target" FORCE)
    ELSE()
        SET(CONCRETE_PROJECT_COMPILER_TARGET x86 CACHE INTERNAL "project compiler target" FORCE)
    ENDIF(CMAKE_CL_64)
    # end set compiler target

    #[[ begin set output dir ]] ########################################
    SET(runtimeOutputDir)

    IF(_CONCRETE_PROJECT_BINARY_OUTPUT_DIR)
        SET(runtimeOutputDir ${_CONCRETE_PROJECT_BINARY_OUTPUT_DIR})
    ELSE(_CONCRETE_PROJECT_BINARY_OUTPUT_DIR)
        SET(runtimeOutputDir ${CONCRETE_PROJECT_ROOT_DIRECTORY}/bin)
    ENDIF(_CONCRETE_PROJECT_BINARY_OUTPUT_DIR)

    IF (${_CONCRETE_PROJECT_GEN_COMPILER_TARGET_DIR})
        SET(runtimeOutputDir ${runtimeOutputDir}/${CONCRETE_PROJECT_COMPILER_TARGET})
    ENDIF(${_CONCRETE_PROJECT_GEN_COMPILER_TARGET_DIR})

    SET(CONCRETE_PROJECT_BINARY_OUTPUT_DIRECTORY ${runtimeOutputDir} CACHE PATH "global binary files generate directory" FORCE)

    UNSET(runtimeOutputDir)

    SET(libraryOutputDir)

    IF(_CONCRETE_PROJECT_LIBRARY_OUTPUT_DIR)
        SET(libraryOutputDir ${_CONCRETE_PROJECT_LIBRARY_OUTPUT_DIR})
    ELSE(_CONCRETE_PROJECT_LIBRARY_OUTPUT_DIR)
        SET(libraryOutputDir ${CONCRETE_PROJECT_ROOT_DIRECTORY}/lib)
    ENDIF(_CONCRETE_PROJECT_LIBRARY_OUTPUT_DIR)

    IF (${_CONCRETE_PROJECT_GEN_COMPILER_TARGET_DIR})
        SET(libraryOutputDir ${libraryOutputDir}/${CONCRETE_PROJECT_COMPILER_TARGET})
    ENDIF(${_CONCRETE_PROJECT_GEN_COMPILER_TARGET_DIR})

    SET(CONCRETE_PROJECT_LIBRARY_OUTPUT_DIRECTORY ${libraryOutputDir} CACHE PATH "global binary files generate directory" FORCE)

    UNSET(libraryOutputDir)

    SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CONCRETE_PROJECT_BINARY_OUTPUT_DIRECTORY})        
    SET(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CONCRETE_PROJECT_LIBRARY_OUTPUT_DIRECTORY})
    SET(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CONCRETE_PROJECT_LIBRARY_OUTPUT_DIRECTORY})
    #[[ end set output dir ]] ########################################

ENDMACRO(CONCRETE_METHOD_INITIALIZATION)