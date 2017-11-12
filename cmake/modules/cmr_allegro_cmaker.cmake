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

include(GNUInstallDirs)

include(cmr_print_debug_message)
include(cmr_print_fatal_error)
include(cmr_print_message)
include(cmr_print_var_value)

include(cmr_allegro_get_download_params)

# TODO: make docs
function(cmr_allegro_cmaker)
  cmake_minimum_required(VERSION 3.2)

  # Required vars
  if(NOT lib_VERSION)
    cmr_print_fatal_error("Variable lib_VERSION is not defined.")
  endif()
  if(NOT lib_BUILD_DIR)
    cmr_print_fatal_error("Variable lib_BUILD_DIR is not defined.")
  endif()

  # Optional vars
  if(NOT lib_DOWNLOAD_DIR)
    set(lib_DOWNLOAD_DIR ${CMAKE_CURRENT_BINARY_DIR})
  endif()
  if(NOT lib_UNPACKED_SRC_DIR)
    set(lib_UNPACKED_SRC_DIR "${lib_DOWNLOAD_DIR}/sources")
  endif()
  
  cmr_allegro_get_download_params(${lib_VERSION}
    lib_URL lib_SHA lib_SRC_DIR_NAME lib_ARCH_FILE_NAME)

  set(lib_ARCH_FILE "${lib_DOWNLOAD_DIR}/${lib_ARCH_FILE_NAME}")
  set(lib_SRC_DIR "${lib_UNPACKED_SRC_DIR}/${lib_SRC_DIR_NAME}")
  set(lib_BUILD_SRC_DIR "${lib_BUILD_DIR}/${lib_SRC_DIR_NAME}")

  if(DEFINED ANDROID_HOME)
    set(ENV{ANDROID_HOME} ${ANDROID_HOME})
  endif()

  if(ANDROID AND ANDROID_TOOLCHAIN STREQUAL "clang")
    # Workaround to compile for Android with clang
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wno-error=format-security")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-error=format-security")
  endif()


  #-----------------------------------------------------------------------
  # Build library.
  #-----------------------------------------------------------------------

  #-----------------------------------------------------------------------
  # Download tar file.
  #
  if(NOT EXISTS "${lib_ARCH_FILE}")
    cmr_print_message("Download ${lib_URL}")
    file(
      DOWNLOAD "${lib_URL}" "${lib_ARCH_FILE}"
      EXPECTED_HASH SHA256=${lib_SHA}
      SHOW_PROGRESS
    )
  endif()
  
  #-----------------------------------------------------------------------
  # Extract tar file.
  #
  if(NOT EXISTS "${lib_SRC_DIR}")
    cmr_print_message("Extract ${lib_ARCH_FILE}")
    file(MAKE_DIRECTORY ${lib_UNPACKED_SRC_DIR})
    execute_process(
      COMMAND ${CMAKE_COMMAND} -E tar xjf ${lib_ARCH_FILE}
      WORKING_DIRECTORY ${lib_UNPACKED_SRC_DIR}
    )
  endif()


  #-----------------------------------------------------------------------
  # Overwrite <src>/android/CMakeLists.txt with empty file
  # to exclude gradle project building.
  #
  if(ANDROID AND SKIP_BUILD_GRADLE_PROJECT)
    cmr_print_message(
      "Overwrite <src>/android/CMakeLists.txt with empty file in unpacked sources.")
    execute_process(
      COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${PROJECT_SOURCE_DIR}/cmake/modules/empty_CMakeLists.txt
        ${lib_SRC_DIR}/android/CMakeLists.txt
    )
  endif()


  #-----------------------------------------------------------------------
  # Configure library.
  #
  add_subdirectory(${lib_SRC_DIR} ${lib_BUILD_SRC_DIR})

endfunction()
