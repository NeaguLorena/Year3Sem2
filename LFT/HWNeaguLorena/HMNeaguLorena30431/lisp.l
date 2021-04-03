%{
#include "y.tab.h"
%}

%%

[0-9]+	{
		yylval.ival = atoi(yytext);
		return NUMB;
	}

CONS return CONS;
CAR return CAR;
CDR return CDR;
APPEND return APPEND;


[()+'\n] return *yytext;

[ \t] ;
