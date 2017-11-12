# ****************************************************************************
#  Project:  LibCMaker_Allegro
#  Purpose:  A CMake build script for Allegro Library
#  Author:   NikitaFeodonit, nfeodonit@yandex.com
# ****************************************************************************
#    Copyright (c) 2017 NikitaFeodonit
#
#    This file is part of the LibCMaker_Allegro project.
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published
#    by the Free Software Foundation, either version 3 of the License,
#    or (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#    See the GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program. If not, see <http://www.gnu.org/licenses/>.
# ****************************************************************************

cmake_minimum_required(VERSION 3.2 FATAL_ERROR)

project(LibCMaker_Allegro_Compile_Test C)

list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")


#-----------------------------------------------------------------------
# Set path to LibCMaker root
#-----------------------------------------------------------------------

set(LIBCMAKER_SRC_DIR "${PROJECT_SOURCE_DIR}/cmake/LibCMaker")
# Uncomment it if need functions from LibCMaker
#list(APPEND CMAKE_MODULE_PATH "${LIBCMAKER_SRC_DIR}/cmake/modules")


#-----------------------------------------------------------------------
# Set vars for LibCMaker_Allegro.
#-----------------------------------------------------------------------

# Standard CMake vars.
#set(BUILD_SHARED_LIBS ON)

#set(SKIP_INSTALL_HEADERS ON)
#set(SKIP_INSTALL_LIBRARIES ON)
#set(SKIP_INSTALL_ALL ON)

# Set useful vars for lib_cmaker_allegro().
set(cmr_PRINT_DEBUG ON)

set(lib_VERSION "5.2.3.0")

set(DOWNLOAD_DIR "${PROJECT_BINARY_DIR}")
set(UNPACKED_SRC_DIR "${PROJECT_BINARY_DIR}")
set(BUILD_DIR "${PROJECT_BINARY_DIR}/build")

set(ENV{ALLEGRO_DIR} "${CMAKE_INSTALL_PREFIX}")

if(ANDROID)
  set(SKIP_BUILD_GRADLE_PROJECT ON)
endif()

# Library specific vars and options.

# To build for Android the ANDROID_HOME must be set to Android SDK path:
# set(ANDROID_HOME "/path/to/android/sdk")
# or cmake -DANDROID_HOME=/path/to/android/sdk
# or export ANDROID_HOME=/path/to/android/sdk
# ARM_TARGETS is set from ${ANDROID_ABI} in lib_cmaker_allegro
# ANDROID_TARGET is set as "android-${ANDROID_NATIVE_API_LEVEL}" in lib_cmaker_allegro

if(ANDROID)
  option(WANT_ANDROID_LEGACY "Build for Android 4 (1.6)" off)
endif()
option(WANT_GLES2 "Compile with GLES2 support" on)
option(WANT_GLES3 "Compile with GLES3 support" off)
option(ALLEGRO_SDL "Build using the SDL backend (experimental)" off)
option(WANT_STATIC_RUNTIME
  "Whether or not to link the C and C++ runtimes statically (currently only implemented for MSVC)"
  off
)

# Option SHARED is set as ${BUILD_SHARED_LIBS} in lib_cmaker_allegro
#option(SHARED "Build shared libraries" on)

option(WANT_FRAMEWORKS "Want frameworks on Mac OS X" off)
option(WANT_EMBED
  "Make frameworks embeddable in application bundles (Mac OS X)"
  on
)

option(PREFER_STATIC_DEPS "Whether to prefer static dependencies." off)

option(WANT_X11 "X11 support" on)
option(WANT_X11_XF86VIDMODE "X11 XF86VidMode Extension support" on)
option(WANT_X11_XINERAMA "X11 Xinerama Extension support" on)
option(WANT_X11_XRANDR "X11 XRandR Extension support" on)
option(WANT_D3D "Enable Direct3D graphics driver (Windows)" on)
option(WANT_D3D9EX "Enable Direct3D 9Ex extensions (Vista)" off)
option(WANT_OPENGL "Enable OpenGL graphics driver (Windows, X11, OS X))" on)
option(WANT_SHADERS_GL "Build GLSL shader support (OpenGL)" on)
option(WANT_SHADERS_D3D "Build HLSL shader support (Direct3D)" on)

option(WANT_FONT "Enable bitmap font add-on" off)
option(WANT_AUDIO "Enable allegro_audio engine" off)
option(WANT_IMAGE "Enable image load/save addon" off)
if(NOT IPHONE)
  option(WANT_IMAGE_JPG "Enable JPEG support in image addon" off)
  option(WANT_IMAGE_PNG "Enable PNG support in image addon" off)
endif()
option(WANT_IMAGE_WEBP "Enable WebP support in image addon" off)

option(WANT_TTF "Enable TTF addon" off)
option(WANT_COLOR "Enable color addon" off)
option(WANT_MEMFILE "Enable memfile addon" off)
option(WANT_PHYSFS "Enable PhysicsFS addon" off)
option(WANT_PRIMITIVES "Enable primitives addon" on)
option(WANT_NATIVE_DIALOG "Enable native dialog addon" off)
option(WANT_VIDEO "Enable video player addon" off)

option(WANT_MONOLITH "Include all addons in the main library" off)

option(WANT_PYTHON_WRAPPER "Enable generation of the Python wrapper" off)

option(WANT_DOCS "Generate documentation" off)
option(WANT_DOCS_HTML "Generate HTML documentation" off)
option(WANT_DOCS_MAN "Generate man pages" off)
option(WANT_DOCS_INFO "Generate Info document" off)
option(WANT_DOCS_PDF "Generate PDF document (requires pdflatex)" off)
option(WANT_DOCS_PDF_PAPER "Whether PDF output is destined for paper" off)

option(STRICT_WARN "Halt at warnings" off)
option(WANT_MUDFLAP "Enable gcc mudflap (requires gcc 4.0+)" off)
option(WANT_RELEASE_LOGGING "Enable logging even in release mode" on)

if(NOT IPHONE)
  option(WANT_ALLOW_SSE "Allow compiler to use SSE instructions (x86)" on)
endif()

option(NO_FPU "No floating point unit" off)
option(WANT_DLL_TLS "Force use of DllMain for TLS (Windows)" off)
option(WANT_DEMO "Build demo programs" off)
option(WANT_EXAMPLES "Build example programs" off)
option(WANT_POPUP_EXAMPLES "Use popups instead of printf for fatal errors" off)
option(WANT_TESTS "Build test programs" off)


#-----------------------------------------------------------------------
# Build and install the Allegro.
#-----------------------------------------------------------------------

include(
  ${PROJECT_SOURCE_DIR}/cmake/LibCMaker_Allegro/lib_cmaker_allegro.cmake)

# Make compile, build and install the library at a config CMake phase,
# generate the CMake config files.

# Install specified library version.
lib_cmaker_allegro(
  VERSION ${lib_VERSION}
  DOWNLOAD_DIR ${DOWNLOAD_DIR}
  UNPACKED_SRC_DIR ${UNPACKED_SRC_DIR}
  BUILD_DIR ${BUILD_DIR}
)


#-----------------------------------------------------------------------
# Configure for find_package.
#-----------------------------------------------------------------------

if(ANDROID)
  list(APPEND CMAKE_FIND_ROOT_PATH "${CMAKE_INSTALL_PREFIX}")
endif()


#-----------------------------------------------------------------------
# find_package
#-----------------------------------------------------------------------

set(Allegro_BUILD_TYPE "release")
if(BUILD_SHARED_LIBS)
  set(Allegro_USE_STATIC_LIBS OFF)
else()
  set(Allegro_USE_STATIC_LIBS ON)
endif()

# Use newly got library.
#find_package(Allegro REQUIRED)
find_package(Allegro REQUIRED primitives)


#-----------------------------------------------------------------------
# Link to the library
#-----------------------------------------------------------------------

if(ANDROID AND ANDROID_TOOLCHAIN STREQUAL "clang")
  # Workaround to compile for Android with clang
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wno-error=format-security")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-error=format-security")
endif()


# Build test executables
add_executable(${PROJECT_NAME}
  ${UNPACKED_SRC_DIR}/allegro-${lib_VERSION}/examples/ex_drawpixels.c
)
target_include_directories(${PROJECT_NAME} PRIVATE ${Allegro_INCLUDE_DIRS})
target_link_libraries(${PROJECT_NAME} ${Allegro_LIBRARIES})


add_executable(${PROJECT_NAME}_2
  ${UNPACKED_SRC_DIR}/allegro-${lib_VERSION}/examples/ex_resize.c
)
target_include_directories(${PROJECT_NAME}_2 PRIVATE ${Allegro_INCLUDE_DIRS})
target_link_libraries(${PROJECT_NAME}_2 ${Allegro_LIBRARIES})
