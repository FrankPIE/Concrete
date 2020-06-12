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

# include once
INCLUDE_GUARD(GLOBAL)

############################# [[ Envionment Variables ]] ###########################
# [[ INTERNAL ]]
# [[ System Information Variables ]]
set(CONCRETE_ENVIONMENT_SYSTEM_INFO_NUMBER_OF_LOGICAL_CORES CACHE INTERNAL "CPU logical cores" FORCE)

set(CONCRETE_ENVIONMENT_SYSTEM_INFO_NUMBER_OF_PHYSICAL_CORES CACHE INTERNAL "CPU physical cores" FORCE)

set(CONCRETE_ENVIONMENT_SYSTEM_INFO_HOSTNAME CACHE INTERNAL "Computer hostname" FORCE)

set(CONCRETE_ENVIONMENT_SYSTEM_INFO_FQDN CACHE INTERNAL "Computer fully qualified domain name" FORCE)

set(CONCRETE_ENVIONMENT_SYSTEM_INFO_TOTAL_VIRTUAL_MEMORY CACHE INTERNAL "Total virtual memory in MiB" FORCE)

set(CONCRETE_ENVIONMENT_SYSTEM_INFO_AVAILABLE_VIRTUAL_MEMORY CACHE INTERNAL	"Available virtual memory in MB" FORCE)

set(CONCRETE_ENVIONMENT_SYSTEM_INFO_TOTAL_PHYSICAL_MEMORY CACHE INTERNAL "Total physical memory in MB" FORCE)

set(CONCRETE_ENVIONMENT_SYSTEM_INFO_AVAILABLE_PHYSICAL_MEMORY CACHE INTERNAL "Available physical memory in MB" FORCE)

set(CONCRETE_ENVIONMENT_SYSTEM_INFO_IS_64BIT CACHE INTERNAL	"One if processor is 64Bit" FORCE)

set(CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_FPU CACHE INTERNAL "One if processor has floating point unit" FORCE)

set(CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_MMX CACHE INTERNAL "One if processor supports MMX instructions" FORCE)

set(CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_MMX_PLUS CACHE INTERNAL	"One if processor supports Ext. MMX instructions" FORCE)

set(CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_SSE CACHE INTERNAL "One if processor supports SSE instructions" FORCE)

set(CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_SSE2 CACHE INTERNAL "One if processor supports SSE2 instructions" FORCE)

set(CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_SSE_FP CACHE INTERNAL "One if processor supports SSE FP instructions" FORCE)

set(CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_SSE_MMX CACHE INTERNAL "One if processor supports SSE MMX instructions" FORCE)

set(CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_AMD_3DNOW CACHE INTERNAL "One if processor supports 3DNow instructions" FORCE)

set(CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_AMD_3DNOW_PLUS CACHE INTERNAL "One if processor supports 3DNow+ instructions" FORCE)

set(CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_IA64 CACHE INTERNAL	"One if IA64 processor emulating x86" FORCE)

set(CONCRETE_ENVIONMENT_SYSTEM_INFO_HAS_SERIAL_NUMBER CACHE INTERNAL "One if processor has serial number" FORCE)

set(CONCRETE_ENVIONMENT_SYSTEM_INFO_PROCESSOR_SERIAL_NUMBER CACHE INTERNAL "Processor serial number" FORCE)

set(CONCRETE_ENVIONMENT_SYSTEM_INFO_PROCESSOR_NAME CACHE INTERNAL "Human readable processor name" FORCE)

set(CONCRETE_ENVIONMENT_SYSTEM_INFO_PROCESSOR_DESCRIPTION CACHE INTERNAL "Human readable full processor description" FORCE)

set(CONCRETE_ENVIONMENT_SYSTEM_INFO_OS_NAME CACHE INTERNAL "See CMAKE_HOST_SYSTEM_NAME" FORCE)

set(CONCRETE_ENVIONMENT_SYSTEM_INFO_OS_RELEASE CACHE INTERNAL "The OS sub-type e.g. on Windows Professional" FORCE)

set(CONCRETE_ENVIONMENT_SYSTEM_INFO_OS_VERSION CACHE INTERNAL "The OS build ID" FORCE)

set(CONCRETE_ENVIONMENT_SYSTEM_INFO_OS_PLATFORM CACHE INTERNAL "See CMAKE_HOST_SYSTEM_PROCESSOR" FORCE)

############################# [[ Project Variables ]] ##############################

# [[ PATH ]]
set(CONCRETE_PROJECT_DEFAULT_PARAMETER "__;LANGUAGES;NONE" CACHE INTERNAL "project default parameter" FORCE)

# project root dir default as ${CMAKE_SOURCE_DIR}
set(CONCRETE_PROJECT_ROOT_DIRECTORY CACHE PATH "prject root dir default as ${CMAKE_HOME_DIRECTORY}" FORCE)

# project binary files generate directory
set(CONCRETE_PROJECT_BINARY_OUTPUT_DIRECTORY  CACHE PATH "global binary files generate directory" FORCE)

# project library files generate directory
set(CONCRETE_PROJECT_LIBRARY_OUTPUT_DIRECTORY CACHE PATH "global library files generate directory" FORCE)

# [[ INTERNAL ]]
# project name
set(CONCRETE_PROJECT_NAME CACHE INTERNAL "project name" FORCE)

# project decription
set(CONCRETE_PROJECT_DESCRIPTION CACHE INTERNAL "project description" FORCE)

# project homepage url cmake >= 3.12.4 
set(CONCRETE_PROJECT_HOMEPAGE_URL CACHE INTERNAL "project homepage url" FORCE)

# compiler target
set(CONCRETE_PROJECT_COMPILER_TARGET CACHE INTERNAL "project compiler target" FORCE)

# compiler toolset
set(CONCRETE_GENERATOR_TOOLSET CACHE INTERNAL "porject generator toolset" FORCE)

# project version
set(CONCRETE_PROJECT_SOFTWARE_VERSION CACHE INTERNAL "software version" FORCE)

# project version major
set(CONCRETE_PROJECT_SOFTWARE_VERSION_MAJOR CACHE INTERNAL "software version major" FORCE)

# project version minor
set(CONCRETE_PROJECT_SOFTWARE_VERSION_MINOR CACHE INTERNAL "software version minor" FORCE)

# project version patch
set(CONCRETE_PROJECT_SOFTWARE_VERSION_PATCH CACHE INTERNAL "software version patch" FORCE)

# project version tweak
set(CONCRETE_PROJECT_SOFTWARE_VERSION_TWEAK CACHE INTERNAL "software version tweak" FORCE)
