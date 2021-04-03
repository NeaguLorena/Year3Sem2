%{
#define NUMBER 257
#define MAP 258
#define INC 259
#define DEC 260
#define FILTER 261
#define ODD 262
#define EVEN 263
#define CONCAT 264
extern int yylval;
%}

%% 

[0-9]+ {yylval=atoi(yytext); return NUMBER;}
: return CONCAT;
map return MAP;
inc return INC;
dec return DEC;
filter return FILTER;
odd return ODD;
even return EVEN;


[,()\[\]\n] return *yytext;
[ \t]+ 
