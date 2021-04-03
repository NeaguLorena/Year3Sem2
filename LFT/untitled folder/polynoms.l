%{
	#include "y.tab.h"
%}

%%

[1-9][0-9]* {yylval.ival = atoi(yytext); return NUMBER;}

Y return VAR;

[,()\[\];*+-@\n] {return *yytext;}
[ \t];
