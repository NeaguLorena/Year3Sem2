#include <stdlib.h>
#include <stdio.h>

typedef struct _node{
    int key;
    struct _node *left, *right;
} node;

void error();
void next_symbol();
void E();
node* T();
node* TE();
int IE();
void print_tree(node* tree);
void parser();
node* insert(int nr, node* tree);
int count(node* tree);
int yylex();

#define NUMBER 256
#define LF 257
#define NODE 258
#define INSERT 259
#define COUNT 260

extern int ival;
int symbol;

void error(){
    printf("error");
}

void next_symbol(){
    symbol=yylex();
}

void E(){
	if (symbol==COUNT || symbol==NUMBER) printf("%d\n",IE());
	else print_tree(TE());
}

node* TE(){
	if (symbol==INSERT){
		next_symbol();
		int number=IE();
		return insert(number, TE());
		}
	else if (symbol=='('){
		next_symbol();
		node* tree=TE();
		if (symbol!=')') printf("error paranteza TE\n");
		else next_symbol();
		return tree;
		}
	else if (symbol==NODE || symbol==LF)
		return T();
	else printf("error TE\n");		
}

int IE(){
	if (symbol==COUNT){
		next_symbol();
		return count(TE());
		}
	else if (symbol=='('){
		next_symbol();
		int number=IE();
		if (symbol!=')') printf("error paranteza IE\n");
		else next_symbol();
		return number;
		}
	else if (symbol==NUMBER){
		int number=ival;
		next_symbol();
		return number;
		}
	else printf("error IE\n");
}

node* T(){
    if (symbol==NODE){
        next_symbol();
        node* tree=(node*)malloc(sizeof(node));        
        tree->left=T();
        if (symbol==NUMBER){
            tree->key=ival;
            next_symbol();
        } else printf("error T number\n");
        tree->right=T();
        return tree;
    }
    else if (symbol==LF){
            next_symbol();
            return NULL;
         }
    else if (symbol=='('){
            next_symbol();
            node* tree=T();
            if (symbol==')') {next_symbol(); return tree;}
            else printf("error T paranteze\n");
         }
    else printf("error T\n");
}

node* insert(int nr, node* tree){
	if (tree==NULL) {
		node* n=(node*)malloc(sizeof(node));                   
	        n->key=nr;                     
		n->left=NULL;                     
		n->right=NULL;                     
		return n;
	}    
	if (tree->key > nr) tree->left=insert(nr, tree->left);    
	else tree->right=insert(nr,tree->right);    
	return tree;
}

int count(node* tree){
	if (tree==NULL) return 0;    
	return 1+count(tree->left)+count(tree->right);
}

void print_tree(node* tree){
    if (tree != NULL)	
		{ 
			printf("\t");
			print_tree(tree->left);    
     			printf("%d\n",tree->key);  
			printf("\t");  
			print_tree(tree->right);
		}
    else { printf("Leaf\n"); }
}

void parser(){
	E();
	if (symbol != '\n') printf("eroare principala\n");
}

void main(){
    next_symbol();
    while (symbol!=0){
        parser();
        next_symbol();
    }
}
