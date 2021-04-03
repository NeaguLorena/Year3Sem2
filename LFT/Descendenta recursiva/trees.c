#include <stdlib.h>
#include <stdio.h>
typedef struct _node{
    int key;
    struct _node *left, *right;
} node;
void error();
void next_symbol();
node* T();
void print(node* tree);
node* insert(int nr, node* tree);
#define INSERT 257
#define NUMB 258
#define LF 259
#define NODE 260

extern int ival;
int symbol;
void error(){
    printf("error");
}
void next_symbol(){
    symbol=yylex();
}

node* T(){
    if (symbol==NODE){
        next_symbol();
        node* tree=(node*)malloc(sizeof(node));        
        tree->left=T();
        if (symbol==NUMB){
            tree->key=ival;
            next_symbol();
        } else error();
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
            else error();
         }
    else error();
}

void print(node* tree){
    if (tree->left != NULL) print(tree->left); else printf("Leaf");
    printf(" %d ",tree->key);
    if (tree->right != NULL) print(tree->right); else printf("Leaf");
}

void main(){
    next_symbol();
    while (symbol!=0){
        if (symbol=='\n'){
            next_symbol();
            continue;
        }
        node* tree=T();
        print(tree);
        next_symbol();
    }
}
