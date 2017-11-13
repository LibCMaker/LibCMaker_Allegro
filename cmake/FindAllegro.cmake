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


# - Try to find Allegro include dirs and libraries
# Usage of this module as follows:
#
#   find_package(Allegro COMPONENTS main image primitives color)
#
#   if(Allegro_FOUND)
#      include_directories(${Allegro_INCLUDE_DIRS})
#
#      add_executable(foo foo.cc)
#      target_link_libraries(foo ${Allegro_LIBRARIES})
#
#      add_executable(bar bar.cc)
#      target_link_libraries(bar ${Allegro_main_LIBRARIES})
#   endif()
#
# Variables defined by this module:
#
#   Allegro_FOUND                       System has Allegro, this means the
#                                       include dir was found, as well as all
#                                       the libraries specified in the
#                                       COMPONENTS list.
#
#   Allegro_INCLUDE_DIRS                Where to find Allegro headers and
#                                       components headers (if specified).
#
#   Allegro_LIBRARIES                   Link to these to use the Allegro
#                                       libraries that you specified.
#
# For each component you specify in find_package(), the following (lower-case)
# variables are set.  You can use these variables if you would like to pick and
# choose components for your targets instead of just using Allegro_INCLUDE_DIRS
# and Allegro_LIBRARIES.
#
#   Allegro_${COMPONENT}_FOUND          True IF the Allegro library
#                                       "component" was found.
#
#   Allegro_${COMPONENT}_INCLUDE_DIR    Where to find headers for the
#                                       specified Allegro "component".
#
#   Allegro_${COMPONENT}_LIBRARY        Contains the libraries for the
#                                       specified Allegro "component".
#
# Useful variables:
#
#   Allegro_BUILD_TYPE                  Set to "debug" or "profile" in any case
#                                       to get the library of the appropriate
#                                       type. Default is empty which means
#                                       release type.
#
#   Allegro_USE_STATIC_LIBS             Set to ON to force the use of the static
#                                       libraries. Default is OFF.
#


macro(_allegro_msg msg)
  if(NOT Allegro_FIND_QUIETLY)
    message(STATUS "Allegro: ${msg}")
  endif()
endmacro()


function(_allegro_append_lib_type_suffix var)
  string(TOLOWER "${Allegro_BUILD_TYPE}" Allegro_BUILD_TYPE_TOLOWER)
  if(Allegro_BUILD_TYPE_TOLOWER STREQUAL "debug")
    set(${var} "${${var}}-debug" PARENT_SCOPE)
  endif()
  if(Allegro_BUILD_TYPE_TOLOWER STREQUAL "profile")
    set(${var} "${${var}}-profile" PARENT_SCOPE)
  endif()
endfunction()


function(_allegro_append_lib_linkage_suffix var)
  if(Allegro_USE_STATIC_LIBS)
    set(${var} "${${var}}-static" PARENT_SCOPE)
  endif()
endfunction()


macro(_allegro_add_component component only_includes)
  if(${component} STREQUAL "main")
    set(component_include_name "allegro5/allegro.h")
  else()
    set(component_include_name "allegro5/allegro_${component}.h")
  endif()

  find_path(Allegro_${component}_INCLUDE_DIR
    NAMES ${component_include_name}
    PATH_SUFFIXES "include"
    HINTS ENV ALLEGRO_DIR
  )

  if(Allegro_${component}_INCLUDE_DIR)
    if(NOT ${only_includes})
      set(component_lib_name "allegro_${component}")
      _allegro_append_lib_type_suffix(component_lib_name)
      _allegro_append_lib_linkage_suffix(component_lib_name)
    
      find_library(Allegro_${component}_LIBRARY
        NAMES ${component_lib_name}
        PATH_SUFFIXES "lib"
        HINTS ENV ALLEGRO_DIR
      )

      if(Allegro_USE_STATIC_LIBS)
        find_file(Allegro_${component}_LINK_WITH_FILE
          NAMES "cmake/Allegro/allegro_${component}_link_with.cmake"
          PATH_SUFFIXES "lib"
          HINTS ENV ALLEGRO_DIR
        )
      endif()
    endif()

    if(Allegro_${component}_LIBRARY)
      list(APPEND Allegro_LIBRARIES ${Allegro_${component}_LIBRARY})
      if(Allegro_${component}_LINK_WITH_FILE)
        include(${Allegro_${component}_LINK_WITH_FILE})
        list(APPEND Allegro_LIBRARIES ${allegro_${component}_LINK_WITH})
      endif()
    endif()
    if(Allegro_${component}_LIBRARY OR ${only_includes})
      list(APPEND Allegro_INCLUDE_DIRS ${Allegro_${component}_INCLUDE_DIR})
      set(Allegro_${component}_FOUND true)
      _allegro_msg("Found Allegro_${component}")
    endif()
  endif()
  
  if(NOT Allegro_${component}_FOUND)
    set(Allegro_${component}_FOUND false)
    _allegro_msg("Could not find Allegro_${component}")
    set(Allegro_FOUND false)
  endif()

  mark_as_advanced(
    Allegro_${component}_INCLUDE_DIR
    Allegro_${component}_LIBRARY
    Allegro_${component}_LINK_WITH_FILE
  )
endmacro()


macro(_find_allegro)
  if(WANT_MONOLITH)
    set(name "Allegro_monolith")
  else()
    set(name "Allegro")
  endif()
  
  string(TOLOWER ${name} name_tolower)
  set(lib_name ${name_tolower})

  _allegro_append_lib_type_suffix(lib_name)
  _allegro_append_lib_linkage_suffix(lib_name)

  find_path(Allegro_INCLUDE_DIR
    NAMES "allegro5/allegro.h"
    PATH_SUFFIXES "include"
    HINTS ENV ALLEGRO_DIR
  )

  find_library(Allegro_LIBRARY
    NAMES ${lib_name}
    PATH_SUFFIXES "lib"
    HINTS ENV ALLEGRO_DIR
  )
  
  if(Allegro_USE_STATIC_LIBS)
    find_file(Allegro_LINK_WITH_FILE
      NAMES "cmake/Allegro/${name_tolower}_link_with.cmake"
      PATH_SUFFIXES "lib"
      HINTS ENV ALLEGRO_DIR
    )
  endif()

  if(Allegro_INCLUDE_DIR AND Allegro_LIBRARY)
    list(APPEND Allegro_INCLUDE_DIRS ${Allegro_INCLUDE_DIR})
    list(APPEND Allegro_LIBRARIES ${Allegro_LIBRARY})
    if(Allegro_LINK_WITH_FILE)
      include(${Allegro_LINK_WITH_FILE})
      list(APPEND Allegro_LIBRARIES ${${name_tolower}_LINK_WITH})
    endif()
    set(Allegro_FOUND true)
    _allegro_msg("Found ${name}")
  else()
    set(Allegro_FOUND false)
    _allegro_msg("Could not find ${name}")
  endif()

  mark_as_advanced(
    Allegro_INCLUDE_DIR
    Allegro_LIBRARY
    Allegro_LINK_WITH_FILE
  )
endmacro()


_find_allegro()

if(Allegro_FIND_REQUIRED AND NOT Allegro_FOUND)
  message(FATAL_ERROR "Could not find Allegro")
endif()

if(Allegro_FOUND AND Allegro_FIND_COMPONENTS)
  if(WANT_MONOLITH)
    set(ONLY_COMPONENT_HEADERS true)
  else()
    set(ONLY_COMPONENT_HEADERS false)
  endif()

  foreach(COMPONENT ${Allegro_FIND_COMPONENTS})
    string(TOLOWER ${COMPONENT} COMPONENT)
    _allegro_add_component(${COMPONENT} ${ONLY_COMPONENT_HEADERS})
    if(Allegro_FIND_REQUIRED AND NOT Allegro_FOUND)
      message(FATAL_ERROR "Could not find Allegro_${COMPONENT}")
    endif()
  endforeach()
endif()

list(REMOVE_DUPLICATES Allegro_INCLUDE_DIRS)
list(REMOVE_DUPLICATES Allegro_LIBRARIES)

mark_as_advanced(
  Allegro_INCLUDE_DIRS
  Allegro_LIBRARIES
)
