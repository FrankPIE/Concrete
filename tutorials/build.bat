@title Build CMake Script
@echo off

if not exist build (
    md build
) 

cd ./build

if "%1" == "-r" (
    del CMakeCache.txt
)

cmake -G "Visual Studio 16" -A Win32 ./../ -DCMAKE_GENERATOR_TOOLSET=v142 -DCMAKE_SYSTEM_VERSION=10.0.16299.0 -Wno-dev

cd ..

REM -DCMAKE_GENERATOR_TOOLSET=v140 -DCMAKE_SYSTEM_VERSION=10.0.16299.0