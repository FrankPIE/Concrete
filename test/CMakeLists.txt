# REQUIRE LEAST CMAKE 3.0.2
cmake_minimum_required(VERSION 3.0.2)

project(ConcreteUnitTest C CXX)

set (CONCRETE_SORUCE_DIR ${CMAKE_SOURCE_DIR}/../..)

include(${CONCRETE_SORUCE_DIR}/Concrete/lib/Configure.cmake)
include(${CONCRETE_SORUCE_DIR}/Concrete/lib/FileOperator.cmake)

# unit test framework
include(${CONCRETE_SORUCE_DIR}/Concrete/lib/UnitTest.cmake)

# init
concrete_init(${CMAKE_SOURCE_DIR}/../)

concrete_file_download("https://github.com/Kitware/CMake/releases/download/v3.15.3/cmake-3.15.3-win64-x64.zip" "./cmake.zip")

concrete_utest_str_equal(${CMAKE_ARCHIVE_OUTPUT_DIRECTORY} ${CONCRETE_LIBRARY_DIR})
