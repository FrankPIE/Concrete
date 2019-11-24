# REQUIRE LEAST CMAKE 3.0.2
cmake_minimum_required(VERSION 3.0.2)

project(ConcreteUnitTest C CXX)

set (CONCRETE_SORUCE_DIR ${CMAKE_SOURCE_DIR}/../..)

include(${CONCRETE_SORUCE_DIR}/Concrete/lib/Configure.cmake)
include(${CONCRETE_SORUCE_DIR}/Concrete/lib/FileOperator.cmake)

# unit test framework
include(${CONCRETE_SORUCE_DIR}/Concrete/lib/UnitTest.cmake)

# init
