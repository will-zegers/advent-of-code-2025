cmake_minimum_required(VERSION 3.22)
project(CallingBird VERSION 1.0 LANGUAGES CXX)

add_executable(callingBird src/main.cpp)

set(PREPARED_INPUT_FILE ${CMAKE_BINARY_DIR}/input.txt)

add_custom_command(
  OUTPUT ${PREPARED_INPUT_FILE}
  COMMAND bash -c "${CMAKE_SOURCE_DIR}/prepare_input.sh ${PREPARED_INPUT_FILE}"
  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
  COMMENT "Preparing the input.txt..."
)

add_custom_target(
  input_ready ALL
  DEPENDS ${PREPARED_INPUT_FILE}
)
