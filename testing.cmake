include(CMakeParseArguments)

macro(setup_test)
  set(_OPTIONS_ARGS ONLY_SOURCES)
  set(_ONE_VALUE_ARGS NAME)
  set(_MULTI_VALUE_ARGS SOURCES LIBS INCLUDE_DIRS)
  cmake_parse_arguments(_SETUPTEST "${_OPTIONS_ARGS}" "${_ONE_VALUE_ARGS}" "${_MULTI_VALUE_ARGS}" ${ARGN})

  if(NOT _SETUPTEST_NAME)
    message(FATAL_ERROR "setup_test: 'NAME' argument required.")
  endif()

  set(TEST_TARGET "${_SETUPTEST_NAME}_test")
  add_executable(${TEST_TARGET})

  if(_SETUPTEST_ONLY_SOURCES)
    target_sources(${TEST_TARGET} PRIVATE ${_SETUPTEST_SOURCES})
  else()
    target_sources(${TEST_TARGET} PRIVATE ${TEST_TARGET}.c ${_SETUPTEST_SOURCES})
  endif()

  target_compile_options(${TEST_TARGET} PRIVATE "-g" "-Wall")
  target_link_libraries(${TEST_TARGET} PRIVATE cmocka ${_SETUPTEST_LIBS})
  target_include_directories(${TEST_TARGET} PRIVATE ${INCLUDE_DIRS})
  add_test(NAME ${TEST_TARGET} COMMAND ${TEST_TARGET})
  unset(TEST_TARGET)
endmacro()

