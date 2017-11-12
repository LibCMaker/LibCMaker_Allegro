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

if(NOT LIBCMAKER_SRC_DIR)
  message(FATAL_ERROR
    "Please set LIBCMAKER_SRC_DIR with path to LibCMaker root")
endif()
# TODO: prevent multiply includes for CMAKE_MODULE_PATH
list(APPEND CMAKE_MODULE_PATH "${LIBCMAKER_SRC_DIR}/cmake/modules")


include(CMakeParseArguments) # cmake_parse_arguments

include(cmr_lib_cmaker)
include(cmr_print_debug_message)
include(cmr_print_var_value)


# To find library CMaker source dir.
set(lcm_LibCMaker_Allegro_SRC_DIR ${CMAKE_CURRENT_LIST_DIR})
# TODO: prevent multiply includes for CMAKE_MODULE_PATH
list(APPEND CMAKE_MODULE_PATH "${lcm_LibCMaker_Allegro_SRC_DIR}/cmake/modules")


function(lib_cmaker_allegro)
  cmake_minimum_required(VERSION 3.2)

  set(options
    # optional args
  )
  
  set(oneValueArgs
    # required args
    VERSION BUILD_DIR
    # optional args
    DOWNLOAD_DIR UNPACKED_SRC_DIR
  )

  set(multiValueArgs
    # optional args
  )

  cmake_parse_arguments(arg
      "${options}" "${oneValueArgs}" "${multiValueArgs}" "${ARGN}")
  # -> lib_VERSION
  # -> lib_BUILD_DIR
  # -> lib_* ...

  cmr_print_var_value(LIBCMAKER_SRC_DIR)

  cmr_print_var_value(arg_VERSION)
  cmr_print_var_value(arg_BUILD_DIR)

  cmr_print_var_value(arg_DOWNLOAD_DIR)
  cmr_print_var_value(arg_UNPACKED_SRC_DIR)

  # Required args
  if(NOT arg_VERSION)
    cmr_print_fatal_error("Argument VERSION is not defined.")
  endif()
  if(NOT arg_BUILD_DIR)
    cmr_print_fatal_error("Argument BUILD_DIR is not defined.")
  endif()
  if(arg_UNPARSED_ARGUMENTS)
    cmr_print_fatal_error(
      "There are unparsed arguments: ${arg_UNPARSED_ARGUMENTS}")
  endif()


  #-----------------------------------------------------------------------
  # Library specific build arguments.
  #-----------------------------------------------------------------------

  set(lcm_CMAKE_ARGS)

  if(NOT IPHONE)
    if(BUILD_SHARED_LIBS)
      set(build_shared_al_lib ON)
    else()
      set(build_shared_al_lib OFF)
    endif()
    option(SHARED "Build shared libraries" ${build_shared_al_lib})
  endif()

  if(DEFINED SKIP_BUILD_GRADLE_PROJECT)
    list(APPEND lcm_CMAKE_ARGS
      -DSKIP_BUILD_GRADLE_PROJECT=${SKIP_BUILD_GRADLE_PROJECT}
    )
  endif()

  if(DEFINED ANDROID_HOME)
    list(APPEND lcm_CMAKE_ARGS
      -DANDROID_HOME=${ANDROID_HOME}
    )
  endif()
  if(DEFINED ANDROID_ABI)
    list(APPEND lcm_CMAKE_ARGS
      -DARM_TARGETS=${ANDROID_ABI}
    )
  endif()
  if(DEFINED ANDROID_NATIVE_API_LEVEL)
    list(APPEND lcm_CMAKE_ARGS
      -DANDROID_TARGET="android-${ANDROID_NATIVE_API_LEVEL}"
    )
  endif()

  set(LIB_VARS
    WANT_ANDROID_LEGACY
    WANT_GLES2
    WANT_GLES3
    ALLEGRO_SDL
    WANT_STATIC_RUNTIME
    SHARED
    WANT_FRAMEWORKS
    WANT_EMBED
    PREFER_STATIC_DEPS
    
    WANT_X11
    WANT_X11_XF86VIDMODE
    WANT_X11_XINERAMA
    WANT_X11_XRANDR
    WANT_D3D
    WANT_D3D9EX
    WANT_OPENGL
    WANT_SHADERS_GL
    WANT_SHADERS_D3D
    
    WANT_FONT
    WANT_AUDIO
    WANT_IMAGE
    WANT_IMAGE_JPG
    WANT_IMAGE_PNG
    WANT_IMAGE_WEBP
    
    WANT_TTF
    WANT_COLOR
    WANT_MEMFILE
    WANT_PHYSFS
    WANT_PRIMITIVES
    WANT_NATIVE_DIALOG
    WANT_VIDEO
    
    WANT_MONOLITH
    
    WANT_PYTHON_WRAPPER
    
    WANT_DOCS
    WANT_DOCS_HTML
    WANT_DOCS_MAN
    WANT_DOCS_INFO
    WANT_DOCS_PDF
    WANT_DOCS_PDF_PAPER
    
    STRICT_WARN
    WANT_MUDFLAP
    WANT_RELEASE_LOGGING
    
    WANT_ALLOW_SSE
    
    NO_FPU
    WANT_DLL_TLS
    WANT_DEMO
    WANT_EXAMPLES
    WANT_POPUP_EXAMPLES
    WANT_TESTS
  )

  foreach(d ${LIB_VARS})
    if(DEFINED ${d})
      list(APPEND lcm_CMAKE_ARGS
        -D${d}=${${d}}
      )
    endif()
  endforeach()

  
  #-----------------------------------------------------------------------
  # BUILDING
  #-----------------------------------------------------------------------

  cmr_lib_cmaker(
    VERSION ${arg_VERSION}
    PROJECT_DIR ${lcm_LibCMaker_Allegro_SRC_DIR}
    DOWNLOAD_DIR ${arg_DOWNLOAD_DIR}
    UNPACKED_SRC_DIR ${arg_UNPACKED_SRC_DIR}
    BUILD_DIR ${arg_BUILD_DIR}
    CMAKE_ARGS ${lcm_CMAKE_ARGS}
    INSTALL
  )

endfunction()
