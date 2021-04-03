%{
#include <stdio.h>
typedef struct _cons {
  int car;
  struct _cons *cdr;
} cons_c;

cons_c *cons(int, cons_c *);
cons_c *concat(cons_c *, cons_c *);
cons_c *cdr(cons_c *);
int car(cons_c *);
void print_list(cons_c *);
void print_l(cons_c *);
%}

%union{
	int ival;
	struct _cons *list;
}

%token <ival> NUMB
%token CONS CAR CDR APPEND

%type <list> l_form l_command enum
%type <ival> i_form i_command

%%
file : file form '\n'
     | file '\n'
     | /* empty */
     ;

form : i_form { printf("%d\n", $1);}
	 | l_form { print_list($1);}
	 ;

i_form: '(' i_command ')' { $$ = $2; }
	  | NUMB 
	  ;

i_command: CAR l_form { $$=car($2); }
		 | '+' i_form i_form { $$=$2+$3; }
		 ;

l_form: '(' l_command ')' { $$ = $2; }
	  | '\'' '(' enum ')' { $$ = $3; }
	  ;

l_command: CDR l_form { $$=cdr($2); }
		 | CONS i_form l_form { $$=cons($2,$3); }
		 | APPEND l_form l_form { $$=concat($2,$3); }
		 ;

enum: NUMB enum { $$=cons($1,$2); }
	| NUMB { $$=cons($1,NULL); }
	;

%%
cons_c *cons(int nr, cons_c *l)
{
	cons_c *lista = (cons_c *)malloc(sizeof(cons_c));
	lista->car = nr;
	lista->cdr = l;
	return lista;
}

cons_c *concat(cons_c *l1, cons_c *l2)
{
	cons_c *lista;
	for (lista=l1; lista->cdr!=NULL; lista=lista->cdr);
	lista->cdr = l2;
	return l1;
}

cons_c *cdr(cons_c *l)
{
	return l->cdr;
}

int car(cons_c *l)
{
	return l->car;
}

void print_list(cons_c *l)
{
	printf("[");
	print_l(l);
	printf("]\n");
}

void print_l(cons_c *l)
{
	if (l!=NULL) {
		if (l->cdr != NULL)
			printf("%d ", l->car);
		else
			printf("%d", l->car);
		print_l(l->cdr);
	}
}







