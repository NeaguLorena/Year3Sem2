%{
#define NUMBER 256
extern int yylval;
%}

%%

[0-9]+ { yylval = atoi(yytext); return NUMBER; }

[-+*/()\n] return *yytext;

[ \t]

