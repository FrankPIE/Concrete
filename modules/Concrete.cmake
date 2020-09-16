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

cmake_minimum_required(VERSION 3.10.3)

include_guard(GLOBAL)

include(Extension/cotire/CMake/cotire)

# Concrete modules
include( ConcreteVariables )
include( ConcreteProperties )

# Concrete Unitity modules
include( Unitity/ConcreteDebug )
include( Unitity/ConcreteFileHelper )
include( Unitity/ConcreteStringHelper )
include( Unitity/ConcreteNet )
include( Unitity/ConcreteMessage )
include( Unitity/ConcreteOption )

# Concrete Envionment modules
include( Environment/ConcreteDetectSystemInfo )

# Concrete Project modules
include( Project/ConcreteSource )
include( Project/ConcreteExtensionUnityBuild )
include( Project/ConcreteTarget )
include( Project/ConcreteDirectory )
include( Project/ConcreteInstall )
include( Project/ConcreteProject )
include( Project/ConcreteBuildType )

# Concrete Package Manager
include( PackageManager/ConcretePackageManager )
include( PackageManager/Extention/ConcreteBoostPackage )
include( PackageManager/Extention/ConcreteGTestPackage )
include( PackageManager/Extention/ConcreteZLibPackage )
include( PackageManager/Extention/ConcreteProtobufPackage )
include( PackageManager/Extention/ConcreteOpenBLASPackage )
include( PackageManager/Extention/ConcreteOpenCVPackage )