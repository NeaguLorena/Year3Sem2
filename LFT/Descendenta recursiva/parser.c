#include <stdio.h>
#define NUMB 257
int symbol;
extern int yylval;

parser(){
printf("parser, ");
E();
if (symbol!='\n') error();
}

int E(){
printf("E, ");
return E1(T());
}

int E1(int v){
printf("E1, ");
if (symbol=='\n'||symbol==')')
return v;
else if (symbol=='+'){
int t;
next_symbol();
t=T();
return E1(v+t);
}
else error();
}

next_symbol(){
printf("next_symbol, ");
symbol=yylex();
}

int T(){
int val;
printf("T, ");
if (symbol==NUMB){
val==yylval;
next_symbol();
return val;
}
else if (symbol=='('){
next_symbol();
val=E();
if (symbol==')') next_symbol();
else error();
return val;
} else error();
}

main(){
printf("main, ");
next_symbol();
while (symbol!=0){
parser();
next_symbol();
}
}

error(){
printf("Error!\n");
}
