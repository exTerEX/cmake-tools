# ----------------------------------
# MIT License
#
# Copyright (c) 2022 Andreas Sagen
# ----------------------------------

CMAKE_MINIMUM_REQUIRED(VERSION 3.0.0)

FIND_PACKAGE(Git QUIET)

# .rst: .. command:: UPDATE_SUBMODULES
#
# Download and update local submodule selection.
FUNCTION(update_submodules)
  IF(GIT_FOUND AND EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/.git")
    EXECUTE_PROCESS(
      COMMAND ${GIT_EXECUTABLE} submodule update --init --remote --recursive
      WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
      RESULT_VARIABLE GIT_SUBMOD_RESULT)

    IF(NOT GIT_SUBMOD_RESULT EQUAL "0")
      MESSAGE(FATAL_ERROR "[ToolsUpdateSubmodules] git failed with ${GIT_SUBMOD_RESULT}")
    ENDIF(NOT GIT_SUBMOD_RESULT EQUAL "0")
  ELSE()
    MESSAGE(FATAL_ERROR "[ToolsUpdateSubmodules] Cannot find git on system")
  ENDIF()
ENDFUNCTION()
