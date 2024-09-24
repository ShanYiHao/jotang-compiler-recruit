%{
#include <stdio.h>
void yyerror(const char* msg) {}
%}

%union {
    int ival;
    float fval;
}

%token <ival> T_INT_NUM
%token <fval> T_FLOAT_NUM
%token T_INC T_AND_MUL T_OR_MUL

%left '+' '-'
%left '*' '/'
%left T_INC T_AND_MUL T_OR_MUL

%type <ival> S E
%type <fval> F
%%

S   :   S E '\n'        { printf("ans = %d\n", $2); }
    |   S F '\n'        { printf("ans = %f\n", $2); }
    |   /* empty */     { /* empty */ }
    ;

E   :   E '+' E         { $$ = $1 + $3; }
    |   E '-' E         { $$ = $1 - $3; }
    |   E '*' E         { $$ = $1 * $3; }
    |   E '/' E         { $$ = $1 / $3; }
    |   E T_INC E       { $$ = $1 + ( $3 + 1 ); }
    |   E T_AND_MUL E   { $$ = ( $1 & $3 ) * $3; }
    |   E T_OR_MUL E    { $$ = ( $1 | $3 ) * $3; }
    |   T_INT_NUM       { $$ = $1; }
    |   '(' E ')'       { $$ = $2; }
    ;

F   :   F '+' F         { $$ = $1 + $3; }
    |   F '-' F         { $$ = $1 - $3; }
    |   F '*' F         { $$ = $1 * $3; }
    |   F '/' F         { $$ = $1 / $3; }
    |   T_INT_NUM       { $$ = $1; }
    |   T_FLOAT_NUM     { $$ = $1; }
    |   '(' F ')'       { $$ = $2; }
    ;

%%

int main() {
    return yyparse();
}