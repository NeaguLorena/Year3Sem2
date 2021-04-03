%{
#define INSERT 257
#define NUMB 258
#define LF 259
#define NODE 260
typedef struct _node{
    int key;
    struct _node *left, *right;
} node;
int ival;
%}

%% 
[0-9]+ {ival = atoi(yytext); 
        return NUMB;}
Node return NODE;
Lf return LF;
Insert return INSERT;
[ \t]+ ;
[()\n] return *yytext;
