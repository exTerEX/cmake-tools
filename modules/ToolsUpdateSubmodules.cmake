cmake_minimum_required(VERSION 3.0.0)

find_package(Git QUIET)

function(update_submodules)
  if(GIT_FOUND AND EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/.git")
    execute_process(
      COMMAND ${GIT_EXECUTABLE} submodule update --init --remote --recursive
      WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
      RESULT_VARIABLE GIT_SUBMOD_RESULT
    )

    if(NOT GIT_SUBMOD_RESULT EQUAL "0")
      message(
        FATAL_ERROR "[ToolsUpdateSubmodules] git failed with ${GIT_SUBMOD_RESULT}"
      )
    endif(NOT GIT_SUBMOD_RESULT EQUAL "0")
  else()
    message(
      FATAL_ERROR "[ToolsUpdateSubmodules] Cannot find git on system"
    )
  endif()
endfunction()
