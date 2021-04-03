/*	Fie gramatica G2’:

	T = { +, (, ), i }		N = { Z, E, E1, F }
	P = { Z -> E,
	      E -> TE1,
	      E1 -> eps	| +TE1 | -TE1,
	      T -> FT1,
	      T1 -> eps	| *FT1 | /FT1,
	      F -> i | (E) }
	
G2’ s-a obtinut prin eliminarea recursivitatii stanga
din gramatica originala G1:
	
		  E -> E+T | T,
		  T -> T*F | F,
		  F -> i | (E)
		  
*/
#include <stdio.h>
#define NUMBER 256
void parser();
int E();
int E1(int v);
int T();
int T1(int v);
int F();
void next_symbol();
void error();
int yylex();

int symbol;
int yylval;

void main()
{
	next_symbol();
	while(symbol != 0) {
		parser();
		next_symbol(); // Eat the '\n'
	}
}

void next_symbol()
{
	symbol = yylex();
}

void error()
{
	printf("syntax error\n");
}

void parser()
{  printf("%d\n", E());
   if(symbol != '\n')
		error();
}

int E()
{  return E1(T());
}

int E1(int v)
{
	int opr;
	if(symbol == '\n' || symbol == ')')	//primim ca parametru o valoare v. Daca dupa ea urmeaza ) sau \n, se incheie si o returnam
		return v;
	else if(symbol == '+' || symbol == '-') {	//daca nu e completa, continuam sa ii adaugam valori, sa compunem expresia
		opr = symbol;
		next_symbol();
		if(opr == '+')
			return E1(v+T());
		else
			return E1(v-T());
		//return v+E1(T()); // asociativ dreapta
	} else
		error();
}

int T()
{  return T1(F());
}

int T1(int v)
{
	int opr;
	if(symbol == '\n' || symbol == ')' || symbol == '+' || symbol == '-')	//primim ca parametru o valoare v. Daca dupa ea urmeaza +, -, ) sau \n, se incheie si o returnam
		return v;
	else if(symbol == '*' || symbol == '/') {	//daca nu e completa, continuam sa ii adaugam valori, sa compunem expresia
		opr = symbol;
		next_symbol();
		if(opr == '*')
			return T1(v*F());
		else
			return T1(v/F());
	} else
		error();
}

int F()
{
	int nr;
	if(symbol == NUMBER) {
		nr = yylval;
		next_symbol();
		return nr;
	} else if(symbol == '(') {
		next_symbol();
		nr = E();
		if(symbol == ')')
			next_symbol();
		else
			error();
		return nr;
	} else
		error();
}

