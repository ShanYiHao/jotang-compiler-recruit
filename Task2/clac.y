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
%left T_INC T_AND_MUL T_OR_MUL //定义它们为左结合运算符

%type <ival> S E //定义S和E的类型为整数
%type <fval> F //定义F的类型为浮点数
%%

S   :   S E '\n'        { printf("ans = %d\n", $2); }
    |   S F '\n'        { printf("ans = %f\n", $2); }
    |   /* empty */     { /* empty */ }
    ;

E   :   E '+' E         { $$ = $1 + $3; }//$$表示左值，$1表示第一个E的值，$3表示第二个E的值
    |   E '-' E         { $$ = $1 - $3; }
    |   E '*' E         { $$ = $1 * $3; }
    |   E '/' E         { $$ = $1 / $3; }
    |   E T_INC E       { $$ = $1 + ( $3 + 1 ); }//按照定义给出相应的运算形式
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