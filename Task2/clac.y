%{
#include <stdio.h>
void yyerror(const char* msg) {}
%}

%union {
    int ival;
    *char sval;
}

%token <ival> T_NUM
%token T_INC T_AND_MUL T_OR_MUL
%left '+' '-'
%left '*' '/'

%type <ival> S E

%%

S   :   S E '\n'        { printf("ans = %d\n", $2); }
    |   /* empty */     { /* empty */ }
    ;

E   :   E '+' E         { $$ = $1 + $3; }
    |   E '-' E         { $$ = $1 - $3; }
    |   E '*' E         { $$ = $1 * $3; }
    |   E '/' E         { $$ = $1 / $3; }
    |   E T_INC E       { $$ = $1 + ( $3 + 1 ); }
    |   E T_AND_MUL E   { $$ = ( $1 & $3 ) * $3; }
    |   E T_OR_MUL E    { $$ = ( $1 | $3 ) * $3; }
    |   T_NUM           { $$ = $1; }
    |   '(' E ')'       { $$ = $2; }
    ;

%%

int main() {
    return yyparse();
}