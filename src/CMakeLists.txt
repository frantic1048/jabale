cmake_minimum_required(VERSION 2.8)
project(jabale)
find_package(FLEX)

FILE(GLOB LEXER_FILES
  lexer.l
)

FLEX_TARGET(JabaleLexer ${LEXER_FILES} ${CMAKE_CURRENT_BINARY_DIR}/lexer.c)

add_executable(JabaleLexer
  ${FLEX_JabaleLexer_OUTPUTS}
)
