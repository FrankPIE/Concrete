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

# CMake standard module
INCLUDE( CMakeParseArguments )

FUNCTION(CONCRETE_METHOD_COLLECT_SYSTEM_INFORMATION)
    # Query logical cpu core number
    CMAKE_HOST_SYSTEM_INFORMATION(RESULT CONCRETE_ENVIONMENT_SYSTEM_INFO_NUMBER_OF_LOGICAL_CORES QUERY NUMBER_OF_LOGICAL_CORES)
    SET(CONCRETE_ENVIONMENT_SYSTEM_INFO_NUMBER_OF_LOGICAL_CORES ${CONCRETE_ENVIONMENT_SYSTEM_INFO_NUMBER_OF_LOGICAL_CORES} CACHE INTERNAL "CPU logical cores" FORCE)

    CMAKE_HOST_SYSTEM_INFORMATION(RESULT CONCRETE_ENVIONMENT_SYSTEM_INFO_NUMBER_OF_PHYSICAL_CORES QUERY NUMBER_OF_PHYSICAL_CORES)
    SET(CONCRETE_ENVIONMENT_SYSTEM_INFO_NUMBER_OF_PHYSICAL_CORES ${CONCRETE_ENVIONMENT_SYSTEM_INFO_NUMBER_OF_PHYSICAL_CORES} CACHE INTERNAL "CPU physical cores" FORCE)

    CMAKE_HOST_SYSTEM_INFORMATION(RESULT CONCRETE_ENVIONMENT_SYSTEM_INFO_HOSTNAME QUERY HOSTNAME)
    SET(CONCRETE_ENVIONMENT_SYSTEM_INFO_HOSTNAME ${CONCRETE_ENVIONMENT_SYSTEM_INFO_HOSTNAME} CACHE INTERNAL "Computer hostname" FORCE)

    CMAKE_HOST_SYSTEM_INFORMATION(RESULT CONCRETE_ENVIONMENT_SYSTEM_INFO_FQDN QUERY FQDN)
    SET(CONCRETE_ENVIONMENT_SYSTEM_INFO_FQDN ${CONCRETE_ENVIONMENT_SYSTEM_INFO_FQDN} CACHE INTERNAL "Computer fully qualified domain name" FORCE)

    CMAKE_HOST_SYSTEM_INFORMATION(RESULT CONCRETE_ENVIONMENT_SYSTEM_INFO_TOTAL_VIRTUAL_MEMORY QUERY TOTAL_VIRTUAL_MEMORY)
    SET(CONCRETE_ENVIONMENT_SYSTEM_INFO_TOTAL_VIRTUAL_MEMORY ${CONCRETE_ENVIONMENT_SYSTEM_INFO_TOTAL_VIRTUAL_MEMORY} CACHE INTERNAL "Total virtual memory in MiB" FORCE)

    CMAKE_HOST_SYSTEM_INFORMATION(RESULT CONCRETE_ENVIONMENT_SYSTEM_INFO_AVAILABLE_VIRTUAL_MEMORY QUERY AVAILABLE_VIRTUAL_MEMORY)
    SET(CONCRETE_ENVIONMENT_SYSTEM_INFO_AVAILABLE_VIRTUAL_MEMORY ${CONCRETE_ENVIONMENT_SYSTEM_INFO_AVAILABLE_VIRTUAL_MEMORY} CACHE INTERNAL	"Available virtual memory in MB" FORCE)

    CMAKE_HOST_SYSTEM_INFORMATION(RESULT CONCRETE_ENVIONMENT_SYSTEM_INFO_TOTAL_PHYSICAL_MEMORY QUERY TOTAL_PHYSICAL_MEMORY)
    SET(CONCRETE_ENVIONMENT_SYSTEM_INFO_TOTAL_PHYSICAL_MEMORY ${CONCRETE_ENVIONMENT_SYSTEM_INFO_TOTAL_PHYSICAL_MEMORY} CACHE INTERNAL "Total physical memory in MB" FORCE)

    CMAKE_HOST_SYSTEM_INFORMATION(RESULT CONCRETE_ENVIONMENT_SYSTEM_INFO_AVAILABLE_PHYSICAL_MEMORY QUERY AVAILABLE_PHYSICAL_MEMORY)
    SET(CONCRETE_ENVIONMENT_SYSTEM_INFO_AVAILABLE_PHYSICAL_MEMORY ${CONCRETE_ENVIONMENT_SYSTEM_INFO_AVAILABLE_PHYSICAL_MEMORY} CACHE INTERNAL "Available physical memory in MB" FORCE)

    CMAKE_HOST_SYSTEM_INFORMATION(RESULT CONCRETE_ENVIONMENT_SYSTEM_INFO_IS_64BIT QUERY IS_64BIT)
    SET(CONCRETE_ENVIONMENT_SYSTEM_INFO_IS_64BIT ${CONCRETE_ENVIONMENT_SYSTEM_INFO_IS_64BIT} CACHE INTERNAL	"One if processor is 64Bit" FORCE)

    CMAKE_HOST_SYSTEM_INFORMATION(RESULT CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_FPU QUERY HAS_FPU)
    SET(CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_FPU ${CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_FPU} CACHE INTERNAL "One if processor has floating point unit" FORCE)

    CMAKE_HOST_SYSTEM_INFORMATION(RESULT CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_MMX QUERY HAS_MMX)
    SET(CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_MMX ${CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_MMX} CACHE INTERNAL "One if processor supports MMX instructions" FORCE)

    CMAKE_HOST_SYSTEM_INFORMATION(RESULT CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_MMX_PLUS QUERY HAS_MMX_PLUS)
    SET(CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_MMX_PLUS ${CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_MMX_PLUS} CACHE INTERNAL	"One if processor supports Ext. MMX instructions" FORCE)

    CMAKE_HOST_SYSTEM_INFORMATION(RESULT CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_SSE QUERY HAS_SSE)
    SET(CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_SSE ${CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_SSE} CACHE INTERNAL "One if processor supports SSE instructions" FORCE)

    CMAKE_HOST_SYSTEM_INFORMATION(RESULT CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_SSE2 QUERY HAS_SSE2)
    SET(CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_SSE2 ${CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_SSE2} CACHE INTERNAL "One if processor supports SSE2 instructions" FORCE)

    CMAKE_HOST_SYSTEM_INFORMATION(RESULT CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_SSE_FP QUERY HAS_SSE_FP)
    SET(CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_SSE_FP ${CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_SSE_FP} CACHE INTERNAL "One if processor supports SSE FP instructions" FORCE)

    CMAKE_HOST_SYSTEM_INFORMATION(RESULT CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_SSE_MMX QUERY HAS_SSE_MMX)
    SET(CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_SSE_MMX ${CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_SSE_MMX} CACHE INTERNAL "One if processor supports SSE MMX instructions" FORCE)

    CMAKE_HOST_SYSTEM_INFORMATION(RESULT CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_AMD_3DNOW QUERY HAS_AMD_3DNOW)
    SET(CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_AMD_3DNOW ${CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_AMD_3DNOW} CACHE INTERNAL "One if processor supports 3DNow instructions" FORCE)

    CMAKE_HOST_SYSTEM_INFORMATION(RESULT CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_AMD_3DNOW_PLUS QUERY HAS_AMD_3DNOW_PLUS)
    SET(CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_AMD_3DNOW_PLUS ${CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_AMD_3DNOW_PLUS} CACHE INTERNAL "One if processor supports 3DNow+ instructions" FORCE)

    CMAKE_HOST_SYSTEM_INFORMATION(RESULT CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_IA64 QUERY HAS_IA64)
    SET(CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_IA64 ${CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_IA64} CACHE INTERNAL	"One if IA64 processor emulating x86" FORCE)

    CMAKE_HOST_SYSTEM_INFORMATION(RESULT CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_SERIAL_NUMBER QUERY HAS_SERIAL_NUMBER)
    SET(CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_SERIAL_NUMBER ${CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_SERIAL_NUMBER} CACHE INTERNAL "One if processor has serial number" FORCE)

    CMAKE_HOST_SYSTEM_INFORMATION(RESULT CONCRETE_ENVIONMENT_SYSTEM_INFO_PROCESSOR_SERIAL_NUMBER QUERY PROCESSOR_SERIAL_NUMBER)
    SET(CONCRETE_ENVIONMENT_SYSTEM_INFO_PROCESSOR_SERIAL_NUMBER ${CONCRETE_ENVIONMENT_SYSTEM_INFO_PROCESSOR_SERIAL_NUMBER} CACHE INTERNAL "Processor serial number" FORCE)

    CMAKE_HOST_SYSTEM_INFORMATION(RESULT CONCRETE_ENVIONMENT_SYSTEM_INFO_PROCESSOR_NAME QUERY PROCESSOR_NAME)
    SET(CONCRETE_ENVIONMENT_SYSTEM_INFO_PROCESSOR_NAME ${CONCRETE_ENVIONMENT_SYSTEM_INFO_PROCESSOR_NAME} CACHE INTERNAL "Human readable processor name" FORCE)

    CMAKE_HOST_SYSTEM_INFORMATION(RESULT CONCRETE_ENVIONMENT_SYSTEM_INFO_PROCESSOR_DESCRIPTION QUERY PROCESSOR_DESCRIPTION)
    SET(CONCRETE_ENVIONMENT_SYSTEM_INFO_PROCESSOR_DESCRIPTION ${CONCRETE_ENVIONMENT_SYSTEM_INFO_PROCESSOR_DESCRIPTION} CACHE INTERNAL "Human readable full processor description" FORCE)

    CMAKE_HOST_SYSTEM_INFORMATION(RESULT CONCRETE_ENVIONMENT_SYSTEM_INFO_OS_NAME QUERY OS_NAME)
    SET(CONCRETE_ENVIONMENT_SYSTEM_INFO_OS_NAME ${CONCRETE_ENVIONMENT_SYSTEM_INFO_OS_NAME} CACHE INTERNAL "See CMAKE_HOST_SYSTEM_NAME" FORCE)

    CMAKE_HOST_SYSTEM_INFORMATION(RESULT CONCRETE_ENVIONMENT_SYSTEM_INFO_OS_RELEASE QUERY OS_RELEASE)
    SET(CONCRETE_ENVIONMENT_SYSTEM_INFO_OS_RELEASE ${CONCRETE_ENVIONMENT_SYSTEM_INFO_OS_RELEASE} CACHE INTERNAL "The OS sub-type e.g. on Windows Professional" FORCE)

    CMAKE_HOST_SYSTEM_INFORMATION(RESULT CONCRETE_ENVIONMENT_SYSTEM_INFO_OS_VERSION QUERY OS_VERSION)
    SET(CONCRETE_ENVIONMENT_SYSTEM_INFO_OS_VERSION ${CONCRETE_ENVIONMENT_SYSTEM_INFO_OS_VERSION} CACHE INTERNAL "The OS build ID" FORCE)

    CMAKE_HOST_SYSTEM_INFORMATION(RESULT CONCRETE_ENVIONMENT_SYSTEM_INFO_OS_PLATFORM QUERY OS_PLATFORM)
    SET(CONCRETE_ENVIONMENT_SYSTEM_INFO_OS_PLATFORM ${CONCRETE_ENVIONMENT_SYSTEM_INFO_OS_PLATFORM} CACHE INTERNAL "See CMAKE_HOST_SYSTEM_PROCESSOR" FORCE)

ENDFUNCTION(CONCRETE_METHOD_COLLECT_SYSTEM_INFORMATION)

FUNCTION(CONCRETE_METHOD_PRINT_SYSTEM_INFORMATION)

ENDFUNCTION(CONCRETE_METHOD_PRINT_SYSTEM_INFORMATION)