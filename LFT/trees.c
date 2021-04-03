#include <stdio.h>
#define NUMBER 256
#define LF 257
#define NODE 258
#define INSERT 259

typedef struct _node{
	int k;
	struct _node *l, *r;
} node;

int yylval;
int symbol;

node* T();
node* TE();
void print_tree(node* n);
node *insert(node *t, int val);

void error() {
	printf("Syntax Error\n");
}

void print_tree(node* n) {
	if (n == NULL) return;

	printf("%d ", n->k);
	print_tree(n->l);
	print_tree(n->r);
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

node* T() {
	if (symbol == LF) {
		next_symbol();
		return NULL;
	}
	else if (symbol == NODE) {
		next_symbol();
		if (symbol == '(') {
			next_symbol();
			if (symbol == NUMBER) {
				node* tree = (node*) malloc(sizeof(node));
				tree->k = yylval;
				
				next_symbol();
				if (symbol == ',') {
					next_symbol();
					tree->l = T();
					
					if (symbol == ',') {
						next_symbol();
						tree->r = T();
						
						if (symbol == ')') {
							next_symbol();
							return tree;
						}
					}
				}
			}
		}
	}
	error();
}

node *TE(){
	if(symbol == INSERT){
		next_symbol();
		if(symbol == '('){
			next_symbol();
			if(symbol == NUMBER){
				int val = yylval;
				next_symbol();
				if(symbol == ','){
					next_symbol();
					node *tree = insert(TE(),val);
					if(symbol == ')'){
						next_symbol();
						return tree;
					}
				}
			}
		}
		error();
	}
	else return T();
}

node *insert(node *t, int val){
	if(t == NULL){
		node *nod = (node*) malloc(sizeof(node));
		nod->k = val;
		nod->l = NULL;
		nod->r = NULL;
		return nod;
	}
	if(t->k < val){
		t->r = insert(t->r, val);
	}
	else if(t->k > val)
		t->l = insert(t->l, val);
	return t;
}


