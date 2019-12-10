@title Build CMake Script
@echo off

set debug_out=

if not exist build (
    md build
) 

cd ./build

for  %%I in (%*) do (
    if "%%I" == "-r" (
        del CMakeCache.txt
    )

    if "%%I" == "-d" (
        set debug_out="--loglevel=DEBUG"
    )
)

cmake -G "Visual Studio 16" -A Win32 ./../  -DCMAKE_GENERATOR_TOOLSET=v142 -DCMAKE_SYSTEM_VERSION=10.0.16299.0 %debug_out%

cd ..

REM -DCMAKE_GENERATOR_TOOLSET=v140 -DCMAKE_SYSTEM_VERSION=10.0.16299.0