%{
#include "build/y.tab.h"
%}

%%
-?[0-9]+        { yylval.ival = atoi(yytext); return T_NUM; }
\+\+              { return T_INC; }
\&\*              { return T_AND_MUL; }
\|\*              { return T_OR_MUL; }
[-/+*()\n]      { return yytext[0]; }
.               { return 0; /* end when meet everything else */ }
%%

int yywrap(void) { 
    return 1;
}