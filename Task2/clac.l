%{
#include "y.tab.h"
%}

%%
-?[0-9]+          { yylval.ival = atoi(yytext); return T_INT_NUM; }
-?[0-9]+\.[0-9]+  { yylval.fval = atof(yytext); return T_FLOAT_NUM; }
\+\+              { return T_INC; } //定义自增运算符
\&\*              { return T_AND_MUL; } //定义“&*”运算
\|\*              { return T_OR_MUL; }//定义“|*”运算
[-/+*()]          { return yytext[0]; }//识别到运算符、括号时返回对应的ASCII码
(\/\/.*\n)|(\/\*.*\*\/) { /* 忽略注释 */ }
[ \n\t]+          { /* 忽略空格 */ }

.                 { return 0; } //识别到非法字符时返回0
%%

int yywrap(void) { 
    return 1;
}