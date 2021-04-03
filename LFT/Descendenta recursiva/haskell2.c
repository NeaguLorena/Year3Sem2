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
cons_c *take(cons_c *l, int nr);
cons_c *drop(cons_c *l, int nr);
void print_list(cons_c *l);

#define NUMB 257
#define APPEND 258
#define CONCAT 259
#define TAIL 260
#define HEAD 261
#define TAKE 262
#define DROP 263

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
	if (symbol==TAKE){
		next_symbol();
		cons_c *lista=E();
		if (symbol==NUMBER){
			int number=yylval;
			next_symbol();
			return take(lista, number);
		}
		else error();
	}
	else if (symbol==DROP){
		next_symbol();
		cons_c *lista=E();
		if (symbol==NUMBER){
			int number=yylval;
			next_symbol();
			return drop(lista, number);
		}
		else error();
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

cons_c *take(cons_c *l, int nr)
{
	if (nr>0) 
		return cons(l->car, take(l->cdr,nr-1));
	else 
		return NULL;
}

cons_c *drop(cons_c *l, int nr)
{
	if (nr>0) 
		return drop(l->cdr, nr-1);
	else 
		return l;
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





	
	
