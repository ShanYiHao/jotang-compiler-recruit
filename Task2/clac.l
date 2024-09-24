%{
#include "y.tab.h"
%}

%%
-?[0-9]+        { yylval.ival = atoi(yytext); return T_INT_NUM; }
-?[0-9]+\.[0-9]+ { yylval.fval = atof(yytext); return T_FLOAT_NUM; }
\+\+              { return T_INC; }
\&\*              { return T_AND_MUL; }
\|\*              { return T_OR_MUL; }
[-/+*()\n]      { return yytext[0]; }
(\/\/.*\n)|(\/\*.*\*\/) { /* 忽略注释 */ }
[ \n\t]+ { /* 忽略空格 */ }

.               { return 0; /* end when meet everything else */ }
%%

int yywrap(void) { 
    return 1;
}