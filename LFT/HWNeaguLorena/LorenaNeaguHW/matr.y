%{
 define MAX 10

typedef struct _matr{
     line *rows[MAX];
     int no_rows_used;
}matr;

typedef structure _line{
     int elems[MAX];
     int no_columns_used;
}line;

int mem [26]; -> _dc2
%}

%union
     int ival;
struct _matr *mat;
struct _line *lin;

%token <ival> NUMBER CAR

%type <mat> matrix expr
%type <lin>
%left '+' '-'
%left '*'
%%  

%%
file : file stmt '\n'
     | file '\n'
     | /*epsilon*/
     ;

stmt : VAR '=' matrix ';'
        {mem[$1] = $3;}
     | expr ';'
        {print_matr($1);}
     ;

expr : expr '+' expr {$$ = add_matr($1,$3);}
     | expr '-' expr {$$ = sub_matr($1,$3);}
     | expr '*' expr {$$ = mult_matr($1,$3);}
     | '(' expr ')' {$$ = $2;}
     | VAR {$$ = mem[$1];}
     ;

row : row NUMBER  {$$ = add_elem($2, $1);}
    | NUMBER {$$ = create_row($1);}
    ;

matrix : matrix '\n' row                      
       | row  {$$ = add_row($3, $1);}          
       | {$$ = create_matr($1);}
       ;

line *create_row(int el)
{
    line *ln;
    ln = (line *)malloc(sizeof(line));
    ln-> no_colums_used = 0;
    ln->elems[ln->no_columns_used++] = el;
    return ln;
}

line *add_elem(int number, line *ln){
    ln->elems[ln->no_columns_used++] = el;
return ln;
}

matr *create_matr(line *ln)
{
    matr *mt = (matr *)malloc(sizeof(matr));
    mt-> no_rows_used = 0;
    mt-> rows[mt->no_rows_used++] = ln;
    return mt;
}

matr *add_row(line *ln, matr *mt){
    mt->rows[mt->no_rows_used++] = ln;
    return mt;
}

matr *add_matr(matr *mat1, matr *mat2){
    matr *rez = (matr *)malloc(sizeof(matr));
    rez->no_rows_used = mat1->no_rows_used;
    int i,j;
    for(i = 0; i < rez->no_rows_used; i++){
        rez->rows[i] = (line *)malloc(sizeof(line));
        rez->rows[i]->no_columns_used =  mat1->rows[i]->no_columns_used;
        for(j = 0; j < rez->rows[i]->no_columns_used; j++){
          rez->rows[i]->elems[j] = mat1->rows[i]->elems[j] + mat2->rows[i]->elems[j];
        }
    }
    return rez;
}

matr *sub_matr(matr *mat1, matr *mat2){
    matr *rez = (matr *)malloc(sizeof(matr));
    rez->no_rows_used = mat1->no_rows_used;
    int i,j;
    for(i = 0; i < rez->no_rows_used; i++){
        rez->rows[i] = (line *)malloc(sizeof(line));
        rez->rows[i]->no_columns_used =  mat1->rows[i]->no_columns_used;
        for(j = 0; j < rez->rows[i]->no_columns_used; j++){
          rez->rows[i]->elems[j] = mat1->rows[i]->elems[j] - mat2->rows[i]->elems[j];
        }
    }
    return rez;
}

matr *mul_matr(matr *mat1, matr *mat2){
    matr *rez = (matr *)malloc(sizeof(matr));
    rez->no_rows_used = mat1->no_rows_used;
    int i,j;
    for(i = 0; i < rez->no_rows_used; i++){
        rez->rows[i] = (line *)malloc(sizeof(line));
        rez->rows[i]->no_columns_used =  mat1->rows[i]->no_columns_used;
        for(j = 0; j < rez->rows[i]->no_columns_used; j++){
            rez->rows[i]->elems[j] = 0;
            for(k = 0; k < rez->rows[i]->no_columns_used; k++){
                rez->rows[i]->elems[j] = rez->rows[i]->elems[j] + mat1->rows[i]->elems[k] * mat2->rows[k]->elems[j];
            }
        }
    }
    return rez;
}