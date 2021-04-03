%{
#define NUMBER 256
#define LF 257
#define NODE 258
#define INSERT 259
extern int yylval;
%}

%%

[0-9]+ {yylval = atoi(yytext); return NUMBER;}

	/* count return COUNT; */
Node return NODE;
Lf return LF;
insert return INSERT;

[,;()\n] {return *yytext;}
[ \t]

