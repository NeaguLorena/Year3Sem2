%{
#define NUMB 257
#define APPEND 258
#define CONCAT 259
#define TAIL 260
#define HEAD 261
#define TAKE 262
#define DROP 263

int yylval;
%}

%% 
[0-9]+ {yylval=atoi(yytext); return NUMB;}
\+\+ return APPEND;
: return CONCAT;
head return HEAD;
tail return TAIL;
take return TAKE;
drop return DROP;

[ \t]+ ;
[;,\n\[\]()] return *yytext;
