%{
#include "token.h"
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
}

"//".* {
#ifdef FFF_LEXER
  printf("0x%x COMMENT\n", COMMENT);
#endif
}

{FLOAT} {
#ifdef FFF_LEXER
  printf("0x%x FLOAT %s\n", FLOAT, yytext);
#endif
}

{INT} {
#ifdef FFF_LEXER
  printf("0x%x INT %s\n", INT, yytext);
#endif
}

{ASSIGN} {
#ifdef FFF_LEXER
  printf("0x%x ASSIGN %s\n", ASSIGN, yytext);
#endif
}

{COND} {
#ifdef FFF_LEXER
  printf("0x%x COND %s\n", COND, yytext);
#endif
}

{BOOLOR} {
#ifdef FFF_LEXER
  printf("0x%x BOOLOR %s\n", BOOLOR, yytext);
#endif
}

{BOOLAND} {
#ifdef FFF_LEXER
  printf("0x%x BOOLAND %s\n", BOOLAND, yytext);
#endif
}

{BITOR} {
#ifdef FFF_LEXER
  printf("0x%x BITOR %s\n", BITOR, yytext);
#endif
}

{BITXOR} {
#ifdef FFF_LEXER
  printf("0x%x BITXOR %s\n", BITXOR, yytext);
#endif
}

{BITAND} {
#ifdef FFF_LEXER
  printf("0x%x BITAND %s\n", BITAND, yytext);
#endif
}

{EQUAL} {
#ifdef FFF_LEXER
  printf("0x%x EQUAL %s\n", EQUAL, yytext);
#endif
}

{ORDER} {
#ifdef FFF_LEXER
  printf("0x%x ORDER %s\n", ORDER, yytext);
#endif
}

{BITSHIFT} {
#ifdef FFF_LEXER
  printf("0x%x BITSHIFT %s\n", BITSHIFT, yytext);
#endif
}

{ARITH1} {
#ifdef FFF_LEXER
  printf("0x%x ARITH1 %s\n", ARITH1, yytext);
#endif
}

{ARITH2} {
#ifdef FFF_LEXER
  printf("0x%x ARITH2 %s\n", ARITH2, yytext);
#endif
}

{MONOARG} {
#ifdef FFF_LEXER
  printf("0x%x MONOARG %s\n", MONOARG, yytext);
#endif
}

{EDGE} {
#ifdef FFF_LEXER
  printf("0x%x EDGE %s\n", EDGE, yytext);
#endif
}

{COMMA} {
#ifdef FFF_LEXER
  printf("0x%x COMMA %s\n", COMMA, yytext);
#endif
}

{BRACE} {
#ifdef FFF_LEXER
  printf("0x%x BRACE %s\n", BRACE, yytext);
#endif
}

{SEMICOLON} {
#ifdef FFF_LEXER
  printf("0x%x SEMICOLON %s\n", SEMICOLON, yytext);
#endif
}

'{CHAR}' {
#ifdef FFF_LEXER
  printf("0x%x CHAR %s\n", CHAR, yytext);
#endif
}

\"{CHAR}*\" {
#ifdef FFF_LEXER
  printf("0x%x STRING %s\n", STRING, yytext);
#endif
}

{BOOL} {
#ifdef FFF_LEXER
  printf("0x%x BOOL %s\n", BOOL, yytext);
#endif
}

{KEYWORD} {
#ifdef FFF_LEXER
  printf("0x%x KEYWORD %s\n", KEYWORD, yytext);
#endif
}

{IDENTIFIER} {
#ifdef FFF_LEXER
  printf("0x%x IDENTIFIER %s\n", IDENTIFIER, yytext);
#endif
}

[\n ]* {
#ifdef FFF_LEXER
  printf("0x%x BLANK\n", BLANK);
#endif
}

. {
#ifdef FFF_LEXER
  printf("0x%x BADTOKEN at line:%d %s\n", BADTOKEN, yylineno, yytext);
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
