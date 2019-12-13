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

CMAKE_MINIMUM_REQUIRED(VERSION 3.10.3)

INCLUDE_GUARD(GLOBAL)

INCLUDE(Extension/cotire/CMake/cotire)

# Concrete modules
INCLUDE( ConcreteVariables )
INCLUDE( ConcreteProperties )

# Concrete Unitity modules
INCLUDE( Unitity/ConcreteDebug )
INCLUDE( Unitity/ConcreteFileHelper )
INCLUDE( Unitity/ConcreteStringHelper )

# Concrete Envionment modules
INCLUDE( Environment/ConcreteDetectSystemInfo )

# Concrete Project modules
INCLUDE( Project/ConcreteExtensionUnityBuild)
INCLUDE( Project/ConcreteTarget )
INCLUDE( Project/ConcreteDirectory )
INCLUDE( Project/ConcreteProject )
