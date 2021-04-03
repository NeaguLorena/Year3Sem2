#include <stdio.h>
#include <stdlib.h>
#define NUMBER 256
#define HEAD 257
#define LENGTH 258
#define TAIL 259
#define CONCAT 260
#define CONS 261

typedef struct _cons
{
	int car;
	struct _cons *cdr;
}cons_c;

int yylval;
int symbol;

void next_symbol();
void error();
cons_c *LE();
cons_c *L();
int IE();
int yylex();
cons_c *Enum();
cons_c *concat(cons_c *l1, cons_c *l2);
cons_c *cons(int nr, cons_c *l);
void print_list(cons_c *l);
cons_c *tail(cons_c *l);
int head(cons_c *l);
int length(cons_c *l);

void error() {
	printf("Syntax error\n");
}

void parser()
{
	print_list(LE()); //call List Expression function and print the result
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

//LE -> L concat LE | L
cons_c *LE(){
	cons_c *lista=L();
	if (symbol==CONCAT){
		next_symbol();
		return concat(lista,LE());
	}
	else {
		return lista;
	}
}

//L -> IE : L | tail LE |(LE) | [Enum]
cons_c *L(){
	if (symbol==TAIL){
		next_symbol();
		return tail(LE());
	}
	else if (symbol=='('){
		next_symbol();
		cons_c *lista=LE();
		if (symbol==')'){
			next_symbol();
			return lista;
		} else error();
	}
	else if (symbol=='['){
		next_symbol();
		cons_c *lista=Enum();
		if (symbol==']'){
			next_symbol();
			return lista;
		} else error();
	}
	else {
		int nb = IE();
		if(symbol == CONS){
			next_symbol();
			return cons(IE(),L());
		}
		return cons(IE(),L());
	}
}

//Enum -> IE, Enum | IE
cons_c *Enum(){
		int number=IE();
		if (symbol==','){
			next_symbol();
			return cons(number, Enum());
		} 
		else 
			return cons(number, NULL);
}

//IE -> head LE | length LE | (IE) | i 
int IE(){
	if(symbol==HEAD){
		next_symbol();
		return head(LE());
	}
	else if(symbol==LENGTH){
		next_symbol();
		return length(LE());
	}
	else if (symbol=='('){
		int nb = IE();
		next_symbol();
		if(symbol==')'){
			return nb;
		}
		else error();
	}
	else if(symbol==NUMBER){
		next_symbol();
		int number = yylval;
		return number;
	}
	else error();
}

//appends list l2 to l1
cons_c *concat(cons_c *l1, cons_c *l2)
{
	cons_c *lista;
	for (lista=l1; lista->cdr!=NULL; lista=lista->cdr);//reach the pointer to the last position in l1
	lista->cdr = l2;//unify it with the poiter to list 2
	return l1;
}

//insert nr in list l 
cons_c *cons(int nr, cons_c *l)
{
    cons_c *lista = (cons_c *)malloc(sizeof(cons_c));
	lista->car = nr;
	lista->cdr = l;
	return lista;
}

//computes length of list
int length(cons_c *l){
	cons_c *lista;
	int count = 0;
	for (lista=l; lista->cdr!=NULL; lista=lista->cdr){
		count++; //cout each element
	}
	printf("%d", count);
	return count;
}

//return head of list
int head(cons_c *l){
	printf("%d", l->car);
	return l->car;
}

//returns the tail of the list
cons_c *tail(cons_c *l){
	return l->cdr;
}

void print_list(cons_c *l)
{
	if (l!=NULL) {
		if (l->cdr != NULL)
			printf("%d, ", l->car);
		else
			printf("%d", l->car);
		print_list(l->cdr);
	}
}