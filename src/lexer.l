%{
#include "token.h"
#ifdef FFF_PARSER
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
  printf("0x%x COMMENT\n", COMMENT);
#endif
#ifdef FFF_PARSER
return COMMENT;
#endif
}

"//".* {
#ifdef FFF_LEXER
  printf("0x%x COMMENT\n", COMMENT);
#endif
#ifdef FFF_PARSER
return COMMENT;
#endif
}

{FLOAT} {
#ifdef FFF_LEXER
  printf("0x%x FLOAT %s\n", FLOAT, yytext);
#endif
#ifdef FFF_PARSER
return FLOAT;
#endif
}

{INT} {
#ifdef FFF_LEXER
  printf("0x%x INT %s\n", INT, yytext);
#endif
#ifdef FFF_PARSER
yylval=atoi(yytext);
return INT;
#endif
}

{ASSIGN} {
#ifdef FFF_LEXER
  printf("0x%x ASSIGN %s\n", ASSIGN, yytext);
#endif
#ifdef FFF_PARSER
MATCH("=", ASSIGN_NORMAL)
#endif
}

{COND} {
#ifdef FFF_LEXER
  printf("0x%x COND %s\n", COND, yytext);
#endif
#ifdef FFF_PARSER
return COND;
#endif
}

{BOOLOR} {
#ifdef FFF_LEXER
  printf("0x%x BOOLOR %s\n", BOOLOR, yytext);
#endif
#ifdef FFF_PARSER
return BOOLOR;
#endif
}

{BOOLAND} {
#ifdef FFF_LEXER
  printf("0x%x BOOLAND %s\n", BOOLAND, yytext);
#endif
#ifdef FFF_PARSER
return BOOLAND;
#endif
}

{BITOR} {
#ifdef FFF_LEXER
  printf("0x%x BITOR %s\n", BITOR, yytext);
#endif
#ifdef FFF_PARSER
return BITOR;
#endif
}

{BITXOR} {
#ifdef FFF_LEXER
  printf("0x%x BITXOR %s\n", BITXOR, yytext);
#endif
#ifdef FFF_PARSER
return BITXOR;
#endif
}

{BITAND} {
#ifdef FFF_LEXER
  printf("0x%x BITAND %s\n", BITAND, yytext);
#endif
#ifdef FFF_PARSER
return BITAND;
#endif
}

{EQUAL} {
#ifdef FFF_LEXER
  printf("0x%x EQUAL %s\n", EQUAL, yytext);
#endif
#ifdef FFF_PARSER
return EQUAL;
#endif
}

{ORDER} {
#ifdef FFF_LEXER
  printf("0x%x ORDER %s\n", ORDER, yytext);
#endif
#ifdef FFF_PARSER
MATCH(">", ORDER_BT)
MATCH("<", ORDER_LT)
#endif
}

{BITSHIFT} {
#ifdef FFF_LEXER
  printf("0x%x BITSHIFT %s\n", BITSHIFT, yytext);
#endif
#ifdef FFF_PARSER
return BITSHIFT;
#endif
}

{ARITH1} {
#ifdef FFF_LEXER
  printf("0x%x ARITH1 %s\n", ARITH1, yytext);
#endif
#ifdef FFF_PARSER
MATCH("+", ARITH1_PLUS)
MATCH("-", ARITH1_MINUS)
#endif
}

{ARITH2} {
#ifdef FFF_LEXER
  printf("0x%x ARITH2 %s\n", ARITH2, yytext);
#endif
#ifdef FFF_PARSER
MATCH("*", ARITH2_MUL)
MATCH("/", ARITH2_DIV)
#endif
}

{MONOARG} {
#ifdef FFF_LEXER
  printf("0x%x MONOARG %s\n", MONOARG, yytext);
#endif
#ifdef FFF_PARSER
return MONOARG;
#endif
}

{EDGE} {
#ifdef FFF_LEXER
  printf("0x%x EDGE %s\n", EDGE, yytext);
#endif
#ifdef FFF_PARSER
MATCH("(", EDGE_OPAREN)
MATCH(")", EDGE_EPAREN)
#endif
}

{COMMA} {
#ifdef FFF_LEXER
  printf("0x%x COMMA %s\n", COMMA, yytext);
#endif
#ifdef FFF_PARSER
return COMMA;
#endif
}

{BRACE} {
#ifdef FFF_LEXER
  printf("0x%x BRACE %s\n", BRACE, yytext);
#endif
#ifdef FFF_PARSER
return BRACE;
#endif
}

{SEMICOLON} {
#ifdef FFF_LEXER
  printf("0x%x SEMICOLON %s\n", SEMICOLON, yytext);
#endif
#ifdef FFF_PARSER
return SEMICOLON;
#endif
}

'{CHAR}' {
#ifdef FFF_LEXER
  printf("0x%x CHAR %s\n", CHAR, yytext);
#endif
#ifdef FFF_PARSER
return CHAR;
#endif
}

\"{CHAR}*\" {
#ifdef FFF_LEXER
  printf("0x%x STRING %s\n", STRING, yytext);
#endif
#ifdef FFF_PARSER
return STRING;
#endif
}

{BOOL} {
#ifdef FFF_LEXER
  printf("0x%x BOOL %s\n", BOOL, yytext);
#endif
#ifdef FFF_PARSER
return BOOL;
#endif
}

{KEYWORD} {
#ifdef FFF_LEXER
  printf("0x%x KEYWORD %s\n", KEYWORD, yytext);
#endif
#ifdef FFF_PARSER
MATCH("while", KEYWORD_WHILE)
#endif
}

{IDENTIFIER} {
#ifdef FFF_LEXER
  printf("0x%x IDENTIFIER %s\n", IDENTIFIER, yytext);
#endif
#ifdef FFF_PARSER
yyval=strdup(yytext);
return IDENTIFIER;
#endif
}

[\n ]* {
#ifdef FFF_LEXER
  printf("0x%x BLANK\n", BLANK);
#endif
#ifdef FFF_PARSER
return BLANK;
#endif
}

. {
#ifdef FFF_LEXER
  printf("0x%x BADTOKEN at line:%d %s\n", BADTOKEN, yylineno, yytext);
#endif
#ifdef FFF_PARSER
yyval=strdup(yytext);
return BADTOKEN;
#endif
}
%%

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
