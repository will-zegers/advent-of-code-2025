cmake_minimum_required(VERSION 3.22)
project(CallingBird VERSION 1.0 LANGUAGES CXX)

add_executable(callingBird src/main.cpp)

add_custom_command(
  OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/input_ready.stamp
  COMMAND bash -c "./prepare_input.sh"
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  COMMENT "Preparing the input.txt..."
)

add_custom_target(
  input_ready ALL
  DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/input_ready.stamp
)
