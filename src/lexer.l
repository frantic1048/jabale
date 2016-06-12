DIGIT [0-9]
HEXDIGIT [0-9abcde]
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

  printf("0x101 COMMENT\n");
}

"//".* {
  printf("0x101 COMMENT\n");
}

true|false {
  printf("0x105 BOOL %s\n", yytext);
}

abstract|boolean|break|byte|case|catch|char|class|const|continue|default|do|double|else|extends|final|finally|float|for|goto|if|implements|import|instanceof|int|interface|long|native|new|null|package|private|protected|public|return|short|static|super|switch|synchronized|this|throw|throws|transient|try|void|volatile|while {
  printf("0x103 KEYWORD %s\n", yytext);
}

-?{DIGIT}+"."{DIGIT}*[Ff]?|-?{DIGIT}*"."{DIGIT}+[Ff]?|-?{DIGIT}+[Ee]-?{DIGIT}+|-?{DIGIT}+"."{DIGIT}*[Ee]-?{DIGIT}+|-?{DIGIT}*"."{DIGIT}+[Ee]-?{DIGIT}+ {
  printf("0x108 FLOAT %s\n", yytext);
}

-?{DIGIT}+L?|-?0x{HEXDIGIT}+L? {
  printf("0x107 INT %s\n", yytext);
}

\n {} /* newline */
. {} /* For others, do nothing */
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
