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

include(cmr_print_fatal_error)

function(cmr_allegro_get_download_params
    version
    out_url out_sha out_src_dir_name out_tar_file_name)

  set(lib_base_url "https://github.com/liballeg/allegro5/releases/download")

  # TODO: get url and sha256 for all Allegro version
  if(version VERSION_EQUAL "5.2.3.0")
    set(lib_sha
      "5a4d40601899492b697ad5cfdf11d8265fe554036a2c912c86a6e6d23001f905")
  endif()

  if(NOT DEFINED lib_sha)
    cmr_print_fatal_error("Library version ${version} is not supported.")
  endif()

  set(lib_src_name "allegro-${version}")
  set(lib_tar_file_name "${lib_src_name}.tar.gz")
  set(lib_url "${lib_base_url}/${version}/${lib_tar_file_name}")

  set(${out_url} "${lib_url}" PARENT_SCOPE)
  set(${out_sha} "${lib_sha}" PARENT_SCOPE)
  set(${out_src_dir_name} "${lib_src_name}" PARENT_SCOPE)
  set(${out_tar_file_name} "${lib_tar_file_name}" PARENT_SCOPE)
endfunction()
