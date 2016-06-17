cmake_minimum_required(VERSION 2.8)
project(jabale)
find_package(FLEX)

FILE(GLOB LEXER_FILES
  lexer.l
)

FLEX_TARGET(Lexer ${LEXER_FILES} ${CMAKE_CURRENT_BINARY_DIR}/lexer.c)

add_executable(Lexer
  ${FLEX_Lexer_OUTPUTS}
)
