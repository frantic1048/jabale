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
  printf("0x101 COMMENT\n");
#endif
}

"//".* {
#ifdef FFF_LEXER
  printf("0x101 COMMENT\n");
#endif
}

{FLOAT} {
#ifdef FFF_LEXER
  printf("0x108 FLOAT %s\n", yytext);
#endif
}

{INT} {
#ifdef FFF_LEXER
  printf("0x107 INT %s\n", yytext);
#endif
}

{ASSIGN} {
#ifdef FFF_LEXER
  printf("0x110 ASSIGN %s\n", yytext);
#endif
}

{COND} {
#ifdef FFF_LEXER
  printf("0x111 COND %s\n", yytext);
#endif
}

{BOOLOR} {
#ifdef FFF_LEXER
  printf("0x112 BOOLOR %s\n", yytext);
#endif
}

{BOOLAND} {
#ifdef FFF_LEXER
  printf("0x113 BOOLAND %s\n", yytext);
#endif
}

{BITOR} {
#ifdef FFF_LEXER
  printf("0x114 BITOR %s\n", yytext);
#endif
}

{BITXOR} {
#ifdef FFF_LEXER
  printf("0x115 BITXOR %s\n", yytext);
#endif
}

{BITAND} {
#ifdef FFF_LEXER
  printf("0x116 BITAND %s\n", yytext);
#endif
}

{EQUAL} {
#ifdef FFF_LEXER
  printf("0x117 EQUAL %s\n", yytext);
#endif
}

{ORDER} {
#ifdef FFF_LEXER
  printf("0x118 ORDER %s\n", yytext);
#endif
}

{BITSHIFT} {
#ifdef FFF_LEXER
  printf("0x119 BITSHIFT %s\n", yytext);
#endif
}

{ARITH1} {
#ifdef FFF_LEXER
  printf("0x11a ARITH1 %s\n", yytext);
#endif
}

{ARITH2} {
#ifdef FFF_LEXER
  printf("0x11b ARITH2 %s\n", yytext);
#endif
}

{MONOARG} {
#ifdef FFF_LEXER
  printf("0x11c MONOARG %s\n", yytext);
#endif
}

{EDGE} {
#ifdef FFF_LEXER
  printf("0x11d EDGE %s\n", yytext);
#endif
}

{COMMA} {
#ifdef FFF_LEXER
  printf("0x120 COMMA %s\n", yytext);
#endif
}

{BRACE} {
#ifdef FFF_LEXER
  printf("0x121 BRACE %s\n", yytext);
#endif
}

{SEMICOLON} {
#ifdef FFF_LEXER
  printf("0x122 SEMICOLON %s\n", yytext);
#endif
}

'{CHAR}' {
#ifdef FFF_LEXER
  printf("0x106 CHAR %s\n", yytext);
#endif
}

\"{CHAR}*\" {
#ifdef FFF_LEXER
  printf("0x109 STRING %s\n", yytext);
#endif
}

{BOOL} {
#ifdef FFF_LEXER
  printf("0x105 BOOL %s\n", yytext);
#endif
}

{KEYWORD} {
#ifdef FFF_LEXER
  printf("0x103 KEYWORD %s\n", yytext);
#endif
}

{IDENTIFIER} {
#ifdef FFF_LEXER
  printf("0x104 IDENTIFIER %s\n", yytext);
#endif
}

[\n ]* {
#ifdef FFF_LEXER
  printf("0x102 BLANK\n");
#endif
}

. {
#ifdef FFF_LEXER
  printf("0x100 BADTOKEN at line:%d %s\n", yylineno, yytext);
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
