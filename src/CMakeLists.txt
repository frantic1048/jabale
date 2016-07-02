cmake_minimum_required(VERSION 2.8)
project(jabale)
find_package(BISON)
find_package(FLEX)

FILE(GLOB LEXER_FILES
  lexer.l
)

# FILE(GLOB PARSER_FILES
#   parser.y
# )

# BISON_TARGET(Parser parser.y ${PARSER_FILES} ${CMAKE_CURRENT_BINARY_DIR}/parser.c)
FLEX_TARGET(Lexer ${LEXER_FILES} ${CMAKE_CURRENT_BINARY_DIR}/lexer.c)

# ADD_FLEX_BISON_DEPENDENCY(Lexer Parser)

add_executable(Lexer
  ${FLEX_Lexer_OUTPUTS}
)

# add_executable(Parser
#   ${BISON_Parser_OUTPUTS}
#   ${FLEX_Lexer_OUTPUTS}
# )
