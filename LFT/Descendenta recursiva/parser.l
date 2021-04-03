%{
#include <stdio.h>
#define NUMB 257
int yylval;
%}
%%
[0-9]+ {yylval=atoi(yytext);
return NUMB;
}
[()\n+] return *yytext;
[ \t]+ ;
