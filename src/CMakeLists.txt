cmake_minimum_required(VERSION 2.8)
project(jabale)
# find_package(BISON)
find_package(FLEX)

include_directories(${CMAKE_CURRENT_SOURCE_DIR})

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
  token.h
  ${FLEX_Lexer_OUTPUTS}
)
set_target_properties(Lexer PROPERTIES
  COMPILE_FLAGS -DFFF_LEXER)

# add_executable(Parser
#   ${FLEX_Lexer_OUTPUTS}
#   ${BISON_Parser_OUTPUTS}
# )
# set_target_properties(Parser PROPERTIES
# COMPILE_FLAGS -DFFF_PARSER)
