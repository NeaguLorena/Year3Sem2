%{
	#include <stdio.h>
	void init(int array[10]);
	void add_pol(int rez[10], int x[10], int y[10]);
	void sub_pol(int rez[10], int x[10], int y[10]);
	void print_pol(int x[10]);
%}


%union{
	int ival;
	int array[10];
}

%left '+' '-'
%token <ival> NUMBER
%token VAR
%type <array> expr monom


%%
file : file expr ';' '\n' { print_pol($2); }
	 | file '\n'
	 |
	 ;
	
expr : expr '+' expr { add_pol($$, $1, $3); }
	 | expr '-' expr { sub_pol($$, $1, $3); }
	 | '(' expr ')' { for(int i = 0; i < 10; i++)  
						$$[i] = $2[i];}
	 | monom
	 ;
	 
monom : NUMBER '*' VAR '^' NUMBER { init($$); $$[$5] = $1; }
	  | VAR '^' NUMBER { init($$); $$[$3] = 1; }
	  | NUMBER '*' VAR { init($$); $$[1] = $1; }
	  | VAR { init($$); $$[1] = 1; }
	  | NUMBER { init($$); $$[0] = $1; }
	  ;
	
%%

void init(int array[10]){
	for(int i = 0; i < 10; i++)
		array[i] = 0;
}

void add_pol(int rez[10], int x[10], int y[10]){
	for(int i = 0; i < 10; i++)
		rez[i] = x[i] + y[i];
}

void sub_pol(int rez[10], int x[10], int y[10]){
	for(int i = 0; i < 10; i++)
		rez[i] = x[i] - y[i];
}


void print_pol(int x[10]){
	for(int i = 9; i >=0; i--)
		if(x[i] != 0)
			printf("%d*y^%d ",x[i], i); 
}

void yyerror(char *s){printf("%s", s);}

int main(){ yyparse();}
