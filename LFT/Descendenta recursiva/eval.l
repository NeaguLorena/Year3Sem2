%{
#define NUMBER 256
%}

%%

[0-9]+ { return NUMBER; }

[+()\n] return *yytext;


