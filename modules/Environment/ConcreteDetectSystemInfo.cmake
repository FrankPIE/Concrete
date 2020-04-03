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

# CMake standard module
include( CMakeParseArguments )

function(__concrete_system_info_query_and_set KEY VARIABLE)
    cmake_host_system_information(RESULT result QUERY ${KEY})
    set_property(CACHE ${VARIABLE} PROPERTY VALUE ${result})
endfunction(__concrete_system_info_query_and_set)

function(concrete_collect_system_information)
    __concrete_system_info_query_and_set(NUMBER_OF_LOGICAL_CORES CONCRETE_ENVIONMENT_SYSTEM_INFO_NUMBER_OF_LOGICAL_CORES)

    __concrete_system_info_query_and_set(NUMBER_OF_PHYSICAL_CORES CONCRETE_ENVIONMENT_SYSTEM_INFO_NUMBER_OF_PHYSICAL_CORES)

    __concrete_system_info_query_and_set(HOSTNAME CONCRETE_ENVIONMENT_SYSTEM_INFO_HOSTNAME)

    __concrete_system_info_query_and_set(FQDN CONCRETE_ENVIONMENT_SYSTEM_INFO_FQDN)

    __concrete_system_info_query_and_set(TOTAL_VIRTUAL_MEMORY CONCRETE_ENVIONMENT_SYSTEM_INFO_TOTAL_VIRTUAL_MEMORY)

    __concrete_system_info_query_and_set(AVAILABLE_VIRTUAL_MEMORY CONCRETE_ENVIONMENT_SYSTEM_INFO_AVAILABLE_VIRTUAL_MEMORY)

    __concrete_system_info_query_and_set(TOTAL_PHYSICAL_MEMORY CONCRETE_ENVIONMENT_SYSTEM_INFO_TOTAL_PHYSICAL_MEMORY)

    __concrete_system_info_query_and_set(AVAILABLE_PHYSICAL_MEMORY CONCRETE_ENVIONMENT_SYSTEM_INFO_AVAILABLE_PHYSICAL_MEMORY)

    __concrete_system_info_query_and_set(IS_64BIT CONCRETE_ENVIONMENT_SYSTEM_INFO_IS_64BIT)

    __concrete_system_info_query_and_set(HAS_FPU CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_FPU)

    __concrete_system_info_query_and_set(HAS_MMX CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_MMX)

    __concrete_system_info_query_and_set(HAS_MMX_PLUS CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_MMX_PLUS)

    __concrete_system_info_query_and_set(HAS_SSE CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_SSE)

    __concrete_system_info_query_and_set(HAS_SSE2 CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_SSE2)

    __concrete_system_info_query_and_set(HAS_SSE_FP CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_SSE_FP)

    __concrete_system_info_query_and_set(HAS_SSE_MMX CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_SSE_MMX)

    __concrete_system_info_query_and_set(HAS_AMD_3DNOW CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_AMD_3DNOW)

    __concrete_system_info_query_and_set(HAS_AMD_3DNOW_PLUS CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_AMD_3DNOW_PLUS)

    __concrete_system_info_query_and_set(HAS_IA64 CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_IA64)

    __concrete_system_info_query_and_set(HAS_SERIAL_NUMBER CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_SERIAL_NUMBER)

    __concrete_system_info_query_and_set(PROCESSOR_SERIAL_NUMBER CONCRETE_ENVIONMENT_SYSTEM_INFO_PROCESSOR_SERIAL_NUMBER)

    __concrete_system_info_query_and_set(PROCESSOR_NAME CONCRETE_ENVIONMENT_SYSTEM_INFO_PROCESSOR_NAME)

    __concrete_system_info_query_and_set(PROCESSOR_DESCRIPTION CONCRETE_ENVIONMENT_SYSTEM_INFO_PROCESSOR_DESCRIPTION)

    __concrete_system_info_query_and_set(OS_NAME CONCRETE_ENVIONMENT_SYSTEM_INFO_OS_NAME)

    __concrete_system_info_query_and_set(OS_RELEASE CONCRETE_ENVIONMENT_SYSTEM_INFO_OS_RELEASE)

    __concrete_system_info_query_and_set(OS_VERSION CONCRETE_ENVIONMENT_SYSTEM_INFO_OS_VERSION)

    __concrete_system_info_query_and_set(OS_PLATFORM CONCRETE_ENVIONMENT_SYSTEM_INFO_OS_PLATFORM)
endfunction(concrete_collect_system_information)