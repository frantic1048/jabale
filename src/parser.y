%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int yyerror(char const *s);
int yylex(void);

/* temp variable number */
int tempNo = 1;

/* while point number */
int weNo = 1;
%}

%union{
  char *string;
}

/*%start Vc*/

%token KEYWORD_WHILE ORDER_LT ORDER_BT ASSIGN_NORMAL EDGE_OPAREN EDGE_EPAREN ARITH1_PLUS ARITH1_MINUS ARITH2_MUL ARITH2_DIV SEMICOLON
%token <string> IDENTIFIER INT
%type <string> Vc Ex Ex2 Er

%%
Start: Start Sw
     | Start S
     | Sw
     | S
     ;

Vc: INT
  | IDENTIFIER
  ;

Sw: KEYWORD_WHILE EDGE_OPAREN Er EDGE_EPAREN S
  {
    printf("(j,@ws%d, , )\n", weNo);
    printf("@we%d\n", weNo);
    ++weNo;
  }
  ;

Er: Vc ORDER_LT Vc
  {
    printf("@ws%d\n", weNo);
    printf("(<,%s,%s,@t%d)\n", $1, $3, tempNo);
    printf("(jF,@t%d,@we%d, )\n", tempNo, weNo);
    char *s;
    asprintf(&s, "@t%i", tempNo);
    ++tempNo;
    $$=s;
  }
  | Vc ORDER_BT Vc
  {
    printf("@ws%d\n", weNo);
    printf("(>,%s,%s,@t%d)\n", $1, $3, tempNo);
    printf("(jF,@t%d,@we%d, )\n", tempNo, weNo);
    char *s;
    asprintf(&s, "@t%i", tempNo);
    ++tempNo;
    $$=s;
  }
  ;

S: IDENTIFIER ASSIGN_NORMAL Ex SEMICOLON
 {
   printf("(=,%s, ,%s)\n", $3, $1);
 }
 ;

Ex: Ex2
  | Ex ARITH1_MINUS Ex2
  {
    printf("(-,%s,%s,@t%d)\n", $1, $3, tempNo);
    char *s;
    asprintf(&s, "@t%i", tempNo);
    ++tempNo;
    $$=s;
  }
  | Ex ARITH1_PLUS Ex2
  {
    printf("(+,%s,%s,@t%d)\n", $1, $3, tempNo);
    char *s;
    asprintf(&s, "@t%i", tempNo);
    ++tempNo;
    $$=s;
  }
  ;

Ex2
  : Vc
  {
    printf("(=,%s, ,@t%d)\n", $1, tempNo);
    char *s;
    asprintf(&s, "@t%i", tempNo);
    ++tempNo;
    $$=s;
  }
  | Ex2 ARITH2_MUL Vc
  {
    printf("(*,%s,%s,@t%d)\n", $1, $3, tempNo);
    char *s;
    asprintf(&s, "@t%i", tempNo);
    ++tempNo;
    $$=s;
  }
  | Ex2 ARITH2_DIV Vc
  {
    printf("(/,%s,%s,@t%d)\n", $1, $3, tempNo);
    char *s;
    asprintf(&s, "@t%i", tempNo);
    ++tempNo;
    $$=s;
  }
  ;
%%

int yyerror(char const *s) {
  extern char *yytext;
  printf("syntex error around \"%s\"\n", yytext);
  return 0;
}

int yywrap() {
  return 1;
}

void main(int argc, char **argv) {
  yyparse();
}
