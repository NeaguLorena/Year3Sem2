%{
#define NUMBER 256
#define HEAD 257
#define LENGTH 258
#define TAIL 259
#define CONCAT 260
#define CONS 261
extern int yylval;
%}

%% 

[0-9]+ {yylval=atoi(yytext); return NUMBER;}
: return CONS;
concat return CONCAT;
head return HEAD;
tail return TAIL;
length return LENGTH;

[,()\[\]\n] {return *yytext;}
[ \t]+
