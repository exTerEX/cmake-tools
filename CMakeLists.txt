cmake_minimum_required(VERSION 3.0 FATAL_ERROR)

project(CMake-Tools LANGUAGES)

enable_testing()

file(GLOB FILES
    LIST_DIRECTORIES true
    "${CMAKE_SOURCE_DIR}/modules/*.cmake"
)

foreach(FILE IN LISTS FILES)
    include("${FILE}")
endforeach()
