#include <stdio.h>
#define NUMBER 256

void parser();
void E();
void E1();
void T();
void next_symbol();
void eroare();
int yylex();

int symbol;	//variabila globala in care stocam simbolul curent citit

void main()
{
	next_symbol(); 		//detecteaza simbolul/tokenul urmator, look-ahead
	while (symbol!=0){	//atata timp cat exista un simbol,
		parser();	//citeste expresia de pe un rand
		next_symbol();	//mananca '\n'-ul
	}
}

void parser()	// Z-ul
{
	E();
	if (symbol!='\n') eroare(); //se asteapta ca dupa expresia de pe un rand sa fie \n
}

void E() 
{
	T();
	E1();
}

void E1()
{
	if (symbol=='\n' || symbol==')') ;	//pentru epsilon trece prin el si verifica urmatorul simbol, care vine dupa E1, adica ) sau \n, din regula E->TE1
	else if (symbol=='+') {
		next_symbol();
		T();
		E1();
	} else eroare();	
}

void T()
{
	if (symbol==NUMBER) next_symbol();
	else if (symbol=='('){
		next_symbol();
		E();
		if (symbol==')') next_symbol();
		else eroare();
	} else eroare();
}

void next_symbol()
{
	symbol=yylex();
}

void eroare()
{
	printf("syntax error\n");
}

