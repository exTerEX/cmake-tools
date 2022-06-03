# ----------------------------------
# MIT License
#
# Copyright (c) 2022 Andreas Sagen
# ----------------------------------

CMAKE_MINIMUM_REQUIRED(VERSION 3.0.0)

INCLUDE(CMakeParseArguments)

# .rst: .. command:: VERSION_FROM_GIT
#
# Check the current last tag in the local git repository.
#
# You can then use:
#
# * **GIT_TAG**: Return raw git tag
# * **SEMVER**: Return a SemVer with metadata changes.
# * **VERSION**: Return SemVer version string without metadata changes.
# * **VERSION_MAJOR**: Return major version.
# * **VERSION_MINOR**: Return minor verson.
# * **VERSION_PATCH**: Return patch version.
#
# If no tag is found, returns version 0.0.0.
FUNCTION(version_from_git)
  SET(options OPTIONAL FAST)

  SET(oneValueArgs GIT_EXECUTABLE INCLUDE_HASH LOG TIMESTAMP)

  SET(multiValueArgs)
  CMAKE_PARSE_ARGUMENTS(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  # Defaults
  IF(NOT DEFINED ARG_INCLUDE_HASH)
    SET(ARG_INCLUDE_HASH ON)
  ENDIF()

  IF(DEFINED ARG_GIT_EXECUTABLE)
    SET(GIT_EXECUTABLE "${ARG_GIT_EXECUTABLE}")
  ELSE()
    # Find Git or bail out
    FIND_PACKAGE(Git)

    IF(NOT GIT_FOUND)
      MESSAGE(FATAL_ERROR "[ToolsVersionFromGit] Git not found")
    ENDIF()
  ENDIF()

  # Git describe
  EXECUTE_PROCESS(
    COMMAND "${GIT_EXECUTABLE}" describe --tags
    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
    RESULT_VARIABLE git_result
    OUTPUT_VARIABLE git_describe
    ERROR_VARIABLE git_error
    OUTPUT_STRIP_TRAILING_WHITESPACE ERROR_STRIP_TRAILING_WHITESPACE)

  IF(NOT git_result EQUAL 0)
    SET(git_describe "v0.0.0")
  ENDIF()

  # Get Git tag
  EXECUTE_PROCESS(
    COMMAND "${GIT_EXECUTABLE}" describe --tags --abbrev=0
    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
    RESULT_VARIABLE git_result
    OUTPUT_VARIABLE git_tag
    ERROR_VARIABLE git_error
    OUTPUT_STRIP_TRAILING_WHITESPACE ERROR_STRIP_TRAILING_WHITESPACE)

  IF(NOT git_result EQUAL 0)
    SET(git_tag "v0.0.0")
  ENDIF()

  IF(git_tag MATCHES
     "^v(0|[1-9][0-9]*)[.](0|[1-9][0-9]*)[.](0|[1-9][0-9]*)(-[.0-9A-Za-z-]+)?([+][.0-9A-Za-z-]+)?$")
    SET(version_major "${CMAKE_MATCH_1}")
    SET(version_minor "${CMAKE_MATCH_2}")
    SET(version_patch "${CMAKE_MATCH_3}")
    SET(identifiers "${CMAKE_MATCH_4}")
    SET(metadata "${CMAKE_MATCH_5}")
  ELSE()
    MESSAGE(FATAL_ERROR "[ToolsVersionFromGit] Git tag isn't valid semantic version: [${git_tag}]")
  ENDIF()

  IF("${git_tag}" STREQUAL "${git_describe}")
    SET(git_at_a_tag ON)
  ENDIF()

  IF(NOT git_at_a_tag)
    # Extract the Git hash (if one exists)
    STRING(REGEX MATCH "g[0-9a-f]+$" git_hash "${git_describe}")
  ENDIF()

  # Construct the version variables
  SET(version ${version_major}.${version_minor}.${version_patch})
  SET(semver ${version})

  # Identifiers
  IF(identifiers MATCHES ".+")
    STRING(SUBSTRING "${identifiers}" 1 -1 identifiers)
    SET(semver "${semver}-${identifiers}")
  ENDIF()

  # Metadata
  IF(metadata MATCHES ".+")
    STRING(SUBSTRING "${metadata}" 1 -1 metadata)
    # Split
    STRING(REPLACE "." ";" metadata "${metadata}")
  ENDIF()

  IF(NOT git_at_a_tag)
    IF(ARG_INCLUDE_HASH)
      LIST(APPEND metadata "${git_hash}")
    ENDIF()

    # Timestamp
    IF(DEFINED ARG_TIMESTAMP)
      STRING(TIMESTAMP TIMESTAMP "${ARG_TIMESTAMP}" ${ARG_UTC})
      LIST(APPEND metadata "${timestamp}")
    ENDIF()
  ENDIF()

  # Join
  STRING(REPLACE ";" "." metadata "${metadata}")

  IF(metadata MATCHES ".+")
    SET(semver "${semver}+${metadata}")
  ENDIF()

  # Log the results
  IF(ARG_LOG)
    MESSAGE(
      STATUS
        "[ToolsVersionFromGit] Version: ${version}
       Git tag:     [${git_tag}]
       Git hash:    [${git_hash}]
       Decorated:   [${git_describe}]
       Identifiers: [${identifiers}]
       Metadata:    [${metadata}]
       SemVer:      [${semver}]")
  ENDIF()

  # Set parent scope variables
  SET(GIT_TAG
      ${git_tag}
      PARENT_SCOPE)
  SET(SEMVER
      ${semver}
      PARENT_SCOPE)
  SET(VERSION
      ${version}
      PARENT_SCOPE)
  SET(VERSION_MAJOR
      ${version_major}
      PARENT_SCOPE)
  SET(VERSION_MINOR
      ${version_minor}
      PARENT_SCOPE)
  SET(VERSION_PATCH
      ${version_patch}
      PARENT_SCOPE)

ENDFUNCTION()
