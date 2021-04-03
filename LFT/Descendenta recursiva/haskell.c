#include <stdio.h>
#include <stdlib.h>

typedef struct _cons{
    int head;
    struct _cons* tail;
} cons;
extern int yylval;

#define NUMB 257
#define APPEND 258
#define CONCAT 259
#define TAIL 260
#define HEAD 261
#define TAKE 262
#define DROP 263

void next_symbol();
void error(int symbol);
cons* parser();
cons* expr();
cons* list();
cons* builder();
void print_list(cons* list);

int symbol;

void next_symbol(){
    symbol=yylex();
}

void error(int symbol){
    char* message;
    switch(symbol){
        case NUMB: message="NUMB"; break;
        case APPEND: message="APPEND"; break;
        case CONCAT: message="CONCAT"; break;
        case TAIL: message="TAIL"; break;
        case HEAD: message="HEAD"; break;
        default: sprintf(message, "%c", symbol);
    }
    printf("ERROR %s\n", message);
}

cons* parser(){
    cons* l = expr();
    if (symbol==';'){
        next_symbol();
        return l;
    }
    else error(';');
}

cons* expr(){
    cons* l=list();
    if (symbol==APPEND){
        next_symbol();
        cons* it;
        for (it=l; it->tail!=NULL; it=it->tail);
        it->tail=expr();
    }
    return l;
}

cons* list(){
    if (symbol==NUMB){
        cons* l = (cons*)malloc(sizeof(cons));
        l->head=yylval;
        next_symbol();
        if (symbol==CONCAT){
            next_symbol();
            l->tail=list();
            return l;
        }
        else error(CONCAT);
    } else if (symbol=='['){
        next_symbol();
        cons* l = builder();
        if (symbol==']') { next_symbol(); return l;}
        else error(']');
    } else if (symbol=='('){
        next_symbol();
        cons* l=expr();
        if (symbol==')') { next_symbol(); return l;}
        else error(')');
    } else if (symbol==TAIL){
        next_symbol();
        if (symbol=='('){
            next_symbol();
            cons* l=expr();
            if (symbol==')') { next_symbol(); return l->tail;}
            else error(')');
        } else error('(');
    } else error("wrong");
}

cons* builder(){
    cons* list=(cons*)malloc(sizeof(cons));
    if (symbol==NUMB){
        list->head=yylval;
        next_symbol();
        if (symbol==','){
            next_symbol();
            list->tail=builder();
        } else list->tail=NULL;
    } else error (NUMB);
    return list;
}

void print_list(cons* list){
    if (list==NULL){ return ; }
    if (list->tail == NULL) printf("%d", list->head);
    else printf("%d, ", list->head);
    print_list(list->tail);
}

void main(){
    next_symbol();
    while(symbol!=0){
        printf("[");
        print_list(parser());
        printf("]\n");
        next_symbol();
    }
}
        

    
