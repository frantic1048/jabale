cmake_minimum_required(VERSION 2.8)
project(jabale)

add_executable(${PROJECT_NAME} main.c)

include(CTest)

add_test(Runs ${PROJECT_NAME})

# Failed case
add_test(Jabaleha ${PROJECT_NAME})
set_tests_properties (Jabaleha
  PROPERTIES PASS_REGULAR_EXPRESSION "Jabale!\n")
