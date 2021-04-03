%{
#define NUMB 257
#define CONCAT 259
#define MAP 261
#define FILTER 262
#define ODD 263
#define EVEN 264
#define INC 265
#define DEC 266

int yylval;
%}

%% 
[0-9]+ {yylval=atoi(yytext); return NUMB;}
: return CONCAT;
map return MAP;
filter return FILTER;
inc return INC;
odd return ODD;
dec return DEC;
even return EVEN;

[ \t]+ ;
[;,\n\[\]()] return *yytext;
