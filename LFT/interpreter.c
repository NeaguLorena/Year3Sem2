#include <stdio.h>
#include <stdlib.h>
#define NUMBER 257
#define MAP 258
#define INC 259
#define DEC 260
#define FILTER 261
#define ODD 262
#define EVEN 263
#define CONCAT 264

typedef struct _cons 
{
  int car;
  struct _cons *cdr;
}cons_c;

int yylval;
int symbol;

void print_list(cons_c *l);
void next_symbol();
void error();
cons_c *E();
cons_c *L();
cons_c *Enum();
cons_c *concat(cons_c *l1, cons_c *l2);
cons_c *cons(int nr, cons_c *l);
cons_c *filter(cons_c *l, int odd);
cons_c *map(cons_c *l, int inc);


void next_symbol(){
    symbol=yylex();
}  

void error(){
	printf("Syntax error\n");
}

void parser()
{
	print_list(E());
	if (symbol != '\n')
		error();
}

void main() {
	next_symbol();
	while(symbol != 0) {
		parser();
		next_symbol();
	}
} 
//E -> L concat E | L
cons_c *E(){
	cons_c *lista=L();
	if (symbol==CONCAT){
		next_symbol();
		return concat(lista,E());
	}
	else {
		return lista;
	}
}
//L -> map inc L | map dec L| filter odd L | filter even L | (E) | [Enum]
cons_c *L(){
	if (symbol==MAP){
	    int inc;
		next_symbol();
		if (symbol==INC) {
		    inc=1; 
		} else if (symbol==DEC) {
		    inc=0;
		} else {
		    error();
		}
		next_symbol();
		cons_c *lista=E();
		map(lista, inc);
		return lista;
	}
	else if (symbol==FILTER){
	    int odd;
		next_symbol();
		if (symbol==ODD) {
		    odd = 1;
		} else if (symbol==EVEN) {
		    odd = 0;
		} else error();
		next_symbol();
		cons_c *lista=E();
		filter(lista, odd);
		return lista;
	}
	else if (symbol=='('){
		next_symbol();
		cons_c *lista=E();
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
	else error();
}
//Enum -> i, Enum | i
cons_c *Enum(){
	if (symbol==NUMBER){
		int number=yylval;
		next_symbol();
		if (symbol==','){
			next_symbol();
			return cons(number, Enum());
		} 
		else 
			return cons(number, NULL);
	} else error();
}

//appends list l2 to l1
cons_c *concat(cons_c *l1, cons_c *l2)
{
	cons_c *lista;
	for (lista=l1; lista->cdr!=NULL; lista=lista->cdr);
	lista->cdr = l2;
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

// applies function inc is it's value is 1, else applies decrement on all elements of the list
cons_c *map(cons_c *l, int inc)
{
	cons_c *lista;
	for (lista=l; lista->cdr!=NULL; lista=lista->cdr) {
	    if (inc) {
	        lista->car++; 
	    } else {
	        lista->car--;
	    }
	}
	return lista;
}

//deletes/filters even or odd elements from the list
cons_c *filter(cons_c *l, int even)
{
	cons_c *lista;
	for (lista=l; lista->cdr!=NULL; lista=lista->cdr) {
	    if (even) {
	        if (lista->car % 2 == 0) {
	            lista->cdr = lista->cdr->cdr;
	        }
	    } else {
	        if (lista->car % 2 != 0) {
	            lista->cdr = lista->cdr->cdr;
	        }
	    }
	}
	return lista;
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
		
