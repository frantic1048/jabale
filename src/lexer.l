%{
#ifdef FFF_LEXER
#include "token.h"
#endif

#ifdef FFF_PARSER
#include "parser.h"
#define MATCH(_str, _res) if (0 == strcmp(yytext, (_str))) return (_res);
#endif
%}
DIGIT [0-9]
OCTDIGIT [0-7]
HEXDIGIT [0-9abcdef]
BOOL true|false
KEYWORD abstract|boolean|break|byte|case|catch|char|class|const|continue|default|do|double|else|extends|final|finally|float|for|goto|if|implements|import|instanceof|int|interface|long|native|new|null|package|private|protected|public|return|short|static|super|switch|synchronized|this|throw|throws|transient|try|void|volatile|while|true|false
INT -?{DIGIT}+L?|-?0x{HEXDIGIT}+L?
FLOAT -?{DIGIT}+"."{DIGIT}*[Ff]?|-?{DIGIT}*"."{DIGIT}+[Ff]?|-?{DIGIT}+[Ee]-?{DIGIT}+|-?{DIGIT}+"."{DIGIT}*[Ee]-?{DIGIT}+|-?{DIGIT}*"."{DIGIT}+[Ee]-?{DIGIT}+
CHAR [[:alnum:][:print:]]|\\{OCTDIGIT}{1,3}|\\u{HEXDIGIT}{1,4}|\\[\\'rnftb]
IDENTIFIER [[:alpha:]$_][\-$_[:alnum:]]*
ASSIGN "="|"+="|"-="|"*="|"/="|"%="|"&="|"^="|"|="|">>="|"<<="|">>>="
COND [?:]
BOOLOR "||"
BOOLAND "&&"
BITOR "|"
BITXOR "^"
BITAND "&"
EQUAL "=="|"!="
ORDER [<>]=?
BITSHIFT ">>"|"<<"|">>>"
ARITH1 [+-]
ARITH2 [*/%]
MONOARG "++"|"--"|"+"|"-"|"!"|"~"
EDGE [\[\]().]
COMMA ","
BRACE [{}]
SEMICOLON ;
%%
"/*" {
  int c;

  for ( ; ; ) {
    while ( (c = input()) != '*' &&
            c != EOF )
      ;    /* eat up text of comment */

    if ( c == '*' ) {
      while ( (c = input()) == '*' )
        ;
      if ( c == '/' )
        break;    /* found the end */
    }

    if ( c == EOF ) {
      printf( "EOF in comment!" );
      break;
    }
  }

#ifdef FFF_LEXER
  printf("0x%x COMMENT\n", TOK_COMMENT);
#endif
}

"//".* {
#ifdef FFF_LEXER
  printf("0x%x COMMENT\n", TOK_COMMENT);
#endif
}

{FLOAT} {
#ifdef FFF_LEXER
  printf("0x%x FLOAT %s\n", TOK_FLOAT, yytext);
#endif
}

{INT} {
#ifdef FFF_LEXER
  printf("0x%x INT %s\n", TOK_INT, yytext);
#endif
#ifdef FFF_PARSER
yylval.string=strdup(yytext);
return INT;
#endif
}

{ASSIGN} {
#ifdef FFF_LEXER
  printf("0x%x ASSIGN %s\n", TOK_ASSIGN, yytext);
#endif
#ifdef FFF_PARSER
MATCH("=", ASSIGN_NORMAL)
#endif
}

{COND} {
#ifdef FFF_LEXER
  printf("0x%x COND %s\n", TOK_COND, yytext);
#endif
}

{BOOLOR} {
#ifdef FFF_LEXER
  printf("0x%x BOOLOR %s\n", TOK_BOOLOR, yytext);
#endif
}

{BOOLAND} {
#ifdef FFF_LEXER
  printf("0x%x BOOLAND %s\n", TOK_BOOLAND, yytext);
#endif
}

{BITOR} {
#ifdef FFF_LEXER
  printf("0x%x BITOR %s\n", TOK_BITOR, yytext);
#endif
}

{BITXOR} {
#ifdef FFF_LEXER
  printf("0x%x BITXOR %s\n", TOK_BITXOR, yytext);
#endif
}

{BITAND} {
#ifdef FFF_LEXER
  printf("0x%x BITAND %s\n", TOK_BITAND, yytext);
#endif
}

{EQUAL} {
#ifdef FFF_LEXER
  printf("0x%x EQUAL %s\n", TOK_EQUAL, yytext);
#endif
}

{ORDER} {
#ifdef FFF_LEXER
  printf("0x%x ORDER %s\n", TOK_ORDER, yytext);
#endif
#ifdef FFF_PARSER
MATCH(">", ORDER_BT)
MATCH("<", ORDER_LT)
#endif
}

{BITSHIFT} {
#ifdef FFF_LEXER
  printf("0x%x BITSHIFT %s\n", TOK_BITSHIFT, yytext);
#endif
}

{ARITH1} {
#ifdef FFF_LEXER
  printf("0x%x ARITH1 %s\n", TOK_ARITH1, yytext);
#endif
#ifdef FFF_PARSER
MATCH("+", ARITH1_PLUS)
MATCH("-", ARITH1_MINUS)
#endif
}

{ARITH2} {
#ifdef FFF_LEXER
  printf("0x%x ARITH2 %s\n", TOK_ARITH2, yytext);
#endif
#ifdef FFF_PARSER
MATCH("*", ARITH2_MUL)
MATCH("/", ARITH2_DIV)
#endif
}

{MONOARG} {
#ifdef FFF_LEXER
  printf("0x%x MONOARG %s\n", TOK_MONOARG, yytext);
#endif
}

{EDGE} {
#ifdef FFF_LEXER
  printf("0x%x EDGE %s\n", TOK_EDGE, yytext);
#endif
#ifdef FFF_PARSER
MATCH("(", EDGE_OPAREN)
MATCH(")", EDGE_EPAREN)
#endif
}

{COMMA} {
#ifdef FFF_LEXER
  printf("0x%x COMMA %s\n", TOK_COMMA, yytext);
#endif
}

{BRACE} {
#ifdef FFF_LEXER
  printf("0x%x BRACE %s\n", TOK_BRACE, yytext);
#endif
}

{SEMICOLON} {
#ifdef FFF_LEXER
  printf("0x%x SEMICOLON %s\n", TOK_SEMICOLON, yytext);
#endif
#ifdef FFF_PARSER
return SEMICOLON;
#endif
}

'{CHAR}' {
#ifdef FFF_LEXER
  printf("0x%x CHAR %s\n", TOK_CHAR, yytext);
#endif
}

\"{CHAR}*\" {
#ifdef FFF_LEXER
  printf("0x%x STRING %s\n", TOK_STRING, yytext);
#endif
}

{BOOL} {
#ifdef FFF_LEXER
  printf("0x%x BOOL %s\n", TOK_BOOL, yytext);
#endif
}

{KEYWORD} {
#ifdef FFF_LEXER
  printf("0x%x KEYWORD %s\n", TOK_KEYWORD, yytext);
#endif
#ifdef FFF_PARSER
MATCH("while", KEYWORD_WHILE)
#endif
}

{IDENTIFIER} {
#ifdef FFF_LEXER
  printf("0x%x IDENTIFIER %s\n", TOK_IDENTIFIER, yytext);
#endif
#ifdef FFF_PARSER
yylval.string=strdup(yytext);
return IDENTIFIER;
#endif
}

[\n ]* {
#ifdef FFF_LEXER
  printf("0x%x BLANK\n", TOK_BLANK);
#endif
}

. {
#ifdef FFF_LEXER
  printf("0x%x BADTOKEN at line:%d %s\n", TOK_BADTOKEN, yylineno, yytext);
#endif
}
%%

#ifdef FFF_LEXER
void main(int argc, char **argv) {
  ++argv, --argc; /* skip program name */
  if (argc > 0) {
    yyin = fopen(argv[0], "r");
  } else {
    yyin = stdin;
  }
  yylex();
}

int yywrap(){
    return 1;
}
#endif
