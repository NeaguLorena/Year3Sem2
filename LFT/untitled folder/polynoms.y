%{
	#include <stdio.h>
	void init(int array[10][10]);
	void add_pol(int rez[10][10], int x[10][10], int y[10][10]);
	void sub_pol(int rez[10][10], int x[10][10], int y[10][10]);
	void print_pol(int x[10][10]);
%}


%union{
	int ival;
	int array[10][10];
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
	 					for(int j = 0; j < 10; j++)  
							$$[i][j] = $2[i][j];}
	 | monom
	 ;
	 
monom : NUMBER '*' VAR '^' NUMBER { init($$); 
							for(int i = 0; i < 10;i++)
								$$[$5][i] = $1; }
	  | VAR '^' NUMBER { init($$); 
	  			for(int i = 0; i < 10; i++)
	  				$$[$3][i] = 1; }
	  | NUMBER '*' VAR { init($$); 
	  			for(int i = 0; i < 10; i++)
	  				$$[1][i] = $1; }
	  | VAR { init($$); 
	  			for(int i = 0; i < 10; i++)
	  				$$[1][i] = 1; }
	  | NUMBER { init($$); 
	  			for(int i = 0; i < 10; i++)
	  				$$[0][i] = $1; }
	  ;
	
%%

void init(int array[10][10]){
	for(int i = 0; i < 10; i++)
		for(int j = 0; j < 10; j++)
			array[i][j] = 0;
}

void add_pol(int rez[10][10], int x[10][10], int y[10][10]){
	for(int i = 0; i < 10; i++)
			for(int j = 0; j < 10; j++)
				rez[i][j] = x[i][j] + y[i][j];
}

void sub_pol(int rez[10][10], int x[10][10], int y[10][10]){
	for(int i = 0; i < 10; i++)
			for(int j = 0; j < 10; j++)
				rez[i][j] = x[i][j] - y[i][j];
}


void print_pol(int x[10][10]){
	for(int i = 9; i >=0; i--)
		for(int j = 9; j >=0; j--)
			if(x[i][j] != 0)
				printf("%d*y^%d ",x[i][j], i + j); 
}
int yyerror(char *s){printf("%s", s); return 1;}

int main(){ yyparse();}
