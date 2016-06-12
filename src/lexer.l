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

  printf("0x101 COMMENT\n");
}

"//".* {
  printf("0x101 COMMENT\n");
}

{FLOAT} {
  printf("0x108 FLOAT %s\n", yytext);
}

{INT} {
  printf("0x107 INT %s\n", yytext);
}

{ASSIGN} {
  printf("0x110 ASSIGN %s\n", yytext);
}

{COND} {
  printf("0x111 COND %s\n", yytext);
}

{BOOLOR} {
  printf("0x112 BOOLOR %s\n", yytext);
}

{BOOLAND} {
  printf("0x113 BOOLAND %s\n", yytext);
}

{BITOR} {
  printf("0x114 BITOR %s\n", yytext);
}

{BITXOR} {
  printf("0x115 BITXOR %s\n", yytext);
}

{BITAND} {
  printf("0x116 BITAND %s\n", yytext);
}

{EQUAL} {
  printf("0x117 EQUAL %s\n", yytext);
}

{ORDER} {
  printf("0x118 ORDER %s\n", yytext);
}

{BITSHIFT} {
  printf("0x119 BITSHIFT %s\n", yytext);
}

{ARITH1} {
  printf("0x11a ARITH1 %s\n", yytext);
}

{ARITH2} {
  printf("0x11b ARITH2 %s\n", yytext);
}

{MONOARG} {
  printf("0x11c MONOARG %s\n", yytext);
}

{EDGE} {
  printf("0x11d EDGE %s\n", yytext);
}

{COMMA} {
  printf("0x120 COMMA %s\n", yytext);
}

{BRACE} {
  printf("0x121 BRACE %s\n", yytext);
}

{SEMICOLON} {
  printf("0x122 SEMICOLON %s\n", yytext);
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

{IDENTIFIER} {
  printf("0x104 IDENTIFIER %s\n", yytext);
}

[\n ]* {
  printf("0x102 BLANK\n");
}

. {
  printf("0x100 BADTOKEN\n");
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
