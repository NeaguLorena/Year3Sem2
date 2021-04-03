%{
#include "y.tab.h"
%}

%%

[A-Z]   {
	yylval.ival = *yytext - 'A';
	return VARIABLE;
	}
[0-9]+  { 
 	yylval.ival = atoi(yytext);
 	return NUMBER;
	}
[-+*\n()=] return *yytext;
[\t]+;