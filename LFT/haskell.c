#include <stdio.h>
#define NUMBER 256
#define HEAD 257
#define LENGTH 258
#define TAIL 259
#define CONCAT 260

typedef struct_cons
{
	int car;
	struct_cons *cdr;
}cons_c;

int yylval;
int symbol;

* T();
node* TE();

void error() {
	printf("Syntax Error\n");
}

void parser()
{
	print_tree(TE());
	if (symbol != '\n')
		error();
}

void next_symbol() {
	symbol = yylex();
}
void main() {
	next_symbol();
	while(symbol != 0) {
		parser();
		next_symbol();
	}
}

int *LE(){
	if(symbol == CONCAT)
		return concat(L(), LE());
	else return L();
}

