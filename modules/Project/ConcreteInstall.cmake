# MIT License
# 
# Copyright (c) 2020 MadStrawberry
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

include(CMakePackageConfigHelpers)

function(__concrete_targets_install_arguments_parse TARGETS)
    set(options OPTIONAL EXCLUDE_FROM_ALL NAMELINK_ONLY NAMELINK_SKIP)

    set(singleValueKey ARCHIVE LIBRARY RUNTIME OBJECTS FRAMEWORK BUNDLE PRIVATE_HEADER PUBLIC_HEADER RESOURCE DESTINATION "INCLUDES DESTINATION")

    set(mulitValueKey TARGETS PERMISSIONS CONFIGURATIONS COMPONENT NAMELINK_COMPONENT )

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    if (_CONCRETE_TARGETS)
        set(${TARGETS} ${_CONCRETE_TARGETS} PARENT_SCOPE)
    endif()
endfunction(__concrete_targets_install_arguments_parse)

function(concrete_install)
    set(options DEFAULT_EXPORT)

    set(singleValueKey CONDITION)

    set(mulitValueKey TARGETS)

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    if (_CONCRETE_TARGETS)
        if (${_CONCRETE_DEFAULT_EXPORT})
            set(defaultExport EXPORT ${CONCRETE_EXPORT_NAME})
        endif()

        __concrete_targets_install_arguments_parse(targets TARGETS ${_CONCRETE_TARGETS})

        set(installArguments TARGETS ${targets} ${defaultExport} ${_CONCRETE_UNPARSED_ARGUMENTS})

        concrete_debug("${installArguments}")
    else()
        set(installArguments ${_CONCRETE_UNPARSED_ARGUMENTS})
    endif()

    if (_CONCRETE_CONDITION)
        if (${_CONCRETE_CONDITION})
            install(${installArguments})
        endif()
    else()
        install(${installArguments})
    endif()    
endfunction(concrete_install)

function(__concrete_version_file PACKAGE_NAME)
    set(options AnyNewerVersion SameMajorVersion SameMinorVersion ExactVersion)

    set(singleValueKey VERSION_FILE)

    set(mulitValueKey)

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    if(${_CONCRETE_AnyNewerVersion})
        set(compatibility COMPATIBILITY AnyNewerVersion)
    endif()

    if(${_CONCRETE_SameMajorVersion})
        set(compatibility COMPATIBILITY SameMajorVersion)
    endif()

    if(${_CONCRETE_SameMinorVersion})
        set(compatibility COMPATIBILITY SameMinorVersion)
    endif()

    if(${_CONCRETE_ExactVersion})
        set(compatibility COMPATIBILITY ExactVersion)
    endif()

    if (_CONCRETE_VERSION_FILE)
        set(versionFile ${_CONCRETE_VERSION_FILE})
    else()
        set(versionFile ${CMAKE_CURRENT_BINARY_DIR}/${PACKAGE_NAME}ConfigVersion.cmake)
    endif()

    write_basic_package_version_file(${versionFile} VERSION ${CONCRETE_PROJECT_SOFTWARE_VERSION} ${compatibility})    
endfunction(__concrete_version_file)

function(__concrete_export)
    set(options)

    set(singleValueKey DESTINATION)

    set(mulitValueKey)

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    if (_CONCRETE_DESTINATION)
        set(destination DESTINATION ${_CONCRETE_DESTINATION})
    else()
        concrete_error("install EXPORT given no DESTINATION!")
    endif()

    install(EXPORT ${CONCRETE_EXPORT_NAME} NAMESPACE ${CONCRETE_EXPORT_NAMESPACE} ${destination})
endfunction(__concrete_export)

function(concrete_package_config CONFIG_FILE_TEMPLATE)
    set(options)

    set(singleValueKey DESTINATION)

    set(mulitValueKey VERSION)

    CMAKE_PARSE_ARGUMENTS(
        _CONCRETE
        "${options}"
        "${singleValueKey}"
        "${mulitValueKey}"
        ${ARGN}
    )

    if (NOT EXISTS ${CONFIG_FILE_TEMPLATE})
        concrete_error("config template file not exists")
    endif()

    if (_CONCRETE_DESTINATION)
        set(destination ${_CONCRETE_DESTINATION})
    else()
        set(destination ".")
    endif()

    configure_package_config_file(${CONFIG_FILE_TEMPLATE} ${CMAKE_CURRENT_BINARY_DIR}/${CONCRETE_PACKAGE_NAME}Config.cmake INSTALL_DESTINATION ${destination})    

    list(APPEND configFiles ${CMAKE_CURRENT_BINARY_DIR}/${CONCRETE_PACKAGE_NAME}Config.cmake)
    
    if (_CONCRETE_VERSION)
        __concrete_version_file(${CONCRETE_PACKAGE_NAME} ${_CONCRETE_VERSION})

        list(APPEND configFiles ${CMAKE_CURRENT_BINARY_DIR}/${CONCRETE_PACKAGE_NAME}ConfigVersion.cmake)
    endif()

    __concrete_export(DESTINATION ${destination})

    concrete_install( FILES ${configFiles} DESTINATION "${destination}")
endfunction(concrete_package_config)
