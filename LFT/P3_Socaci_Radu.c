#include <stdio.h>
#include <stdlib.h>

typedef struct _cons {
  int car;
  struct _cons *cdr;
} cons_c;

void next_symbol();
void error();
cons_c *E();
cons_c *L();
cons_c *Enum();
cons_c *concat(cons_c *l1, cons_c *l2);
cons_c *cons(int nr, cons_c *l);
void print_list(cons_c *l);

#define NUMB 257
#define CONCAT 259
#define MAP 261
#define FILTER 262
#define ODD 263
#define EVEN 264
#define INC 265
#define DEC 266

extern int yylval;
int symbol;

void main(){
    next_symbol();
    while(symbol!=0){
        printf("[");
        print_list(E());
        printf("]\n");
        next_symbol();
    }
}
  
void next_symbol(){
    symbol=yylex();
}  

void error(){
	printf("error\n");
}
	
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

cons_c *L(){
	if (symbol==MAP){
	    bool inc = false;
		next_symbol();
		if (symbol==INC) {
		    inc=true;
		} else if (symbol==DEC) {
		    inc=false;
		} else {
		    error();
		}
		next_symbol();
		cons_c *lista=E();
		map(lista, inc);
		return lista;
	}
	else if (symbol==FILTER){
	    bool odd = false;
		next_symbol();
		if (symbol==ODD) {
		    odd = true;
		} else if (symbol==EVEN) {
		    odd = false;
		} else {
		    error();
		}
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

cons_c *Enum(){
	if (symbol==NUMB){
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

cons_c *concat(cons_c *l1, cons_c *l2)
{
	cons_c *lista;
	for (lista=l1; lista->cdr!=NULL; lista=lista->cdr);
	lista->cdr = l2;
	return l1;
}

cons_c *cons(int nr, cons_c *l)
{
    cons_c *lista = (cons_c *)malloc(sizeof(cons_c));
	lista->car = nr;
	lista->cdr = l;
	return lista;
}

cons_c *map(cons_c *l, bool inc)
{
	cons_c *lista;
	for (lista=l1; lista->cdr!=NULL; lista=lista->cdr) {
	    if (inc) {
	        lista->car++;
	    } else {
	        lista->car--;
	    }
	}
	return lista;
}

cons_c *filter(cons_c *l, bool odd)
{
	cons_c *lista;
	for (lista=l1; lista->cdr!=NULL; lista=lista->cdr) {
	    if (odd) {
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
		print_l(l->cdr);
	}
}





	
	
