typedef struct node{
	int k;
	struct node *l, *r;
}node;

main(){
	next_symbol();
	while(symbol != 0){
		parser();
		next_symbol();
	}
}

parser(){
	print_tree(T());
	if(symbol != '\n')
		error();
}

node *T(){
	if(symbol == LF){
		next_symbol();
		return NULL;
	}
	else if (symbol == NODE)
}

void insert(node *T){
	
	
}