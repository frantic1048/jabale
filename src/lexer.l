DIGIT [0-9]
OCTDIGIT [0-7]
HEXDIGIT [0-9abcdef]
BOOL true|false
KEYWORD abstract|boolean|break|byte|case|catch|char|class|const|continue|default|do|double|else|extends|final|finally|float|for|goto|if|implements|import|instanceof|int|interface|long|native|new|null|package|private|protected|public|return|short|static|super|switch|synchronized|this|throw|throws|transient|try|void|volatile|while|true|false
INT -?{DIGIT}+L?|-?0x{HEXDIGIT}+L?
FLOAT -?{DIGIT}+"."{DIGIT}*[Ff]?|-?{DIGIT}*"."{DIGIT}+[Ff]?|-?{DIGIT}+[Ee]-?{DIGIT}+|-?{DIGIT}+"."{DIGIT}*[Ee]-?{DIGIT}+|-?{DIGIT}*"."{DIGIT}+[Ee]-?{DIGIT}+
CHAR [[:alnum:][:print:]]|\\{OCTDIGIT}{1,3}|\\u{HEXDIGIT}{1,4}|\\[\\'rnftb]
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

'{CHAR}' {
  printf("0x106 CHAR %s\n", yytext);
}

\"{CHAR}*\" {
  printf("0x109 STRING %s\n", yytext);
}

{BOOL} {
  printf("0x105 BOOL %s\n", yytext);
}

{KEYWORD} {
  printf("0x103 KEYWORD %s\n", yytext);
}

{FLOAT} {
  printf("0x108 FLOAT %s\n", yytext);
}

{INT} {
  printf("0x107 INT %s\n", yytext);
}

[\n ]* {
  printf("0x102 BLANK\n");
}

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
