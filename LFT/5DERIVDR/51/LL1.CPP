// FISIERUL: ll1.cpp

/*
   P = { E -> E+T | E-T | T,
          T -> T*F | T/F | F,
          F -> n | (E) }
                                   PRIM      URMA
P'= { E -> T | TC                 { n,( }   { ),# }
      C -> +T | +TC | -T | -TC    { +,- }   { ),# }
      T -> F | FD                 { n,( }   { +,-,),# }
      D -> *F | *FD | /F | /FD    { *,/ }   { +,-,),# }
      F -> n | (E)                { n,( }   { +,-,*,/,),# }

      n       +          -         *           /           (            )

E     T|TC                                                T|TC
C           +T|+TC     -T|-TC
T     F|FD                                                F|FD
D                                 *F|*FD      /F|/FD
F     n                                                   (E)
*/

#include <stdio.h>
#include <ctype.h>

#define           NUMAR             01
#define           PLUS              04
#define           MINUS             010
#define           STEA              020
#define           SLASH             040
#define           PARS              0100
#define           PARD              0200
#define           NL                01000
#define           PRIMC             (PLUS|MINUS)
#define           PRIMD             (STEA|SLASH)

int lexem,vlexem;
int E(void),C(int),T(void),D(int),F(void);
int lex(void);          // analizorul lexical
void eroare(char *);

void main(void)
{
  while( lex() )
      if (lexem != NL)
            printf("\t%d\n",E());
}

int lex(void)
{  int c;
   while((c=getchar()) == ' ' || c == '\t');
   if (c == EOF)
      return lexem = 0;
   if ( isdigit(c)){
      ungetc(c,stdin);scanf("%d",&vlexem);
      return lexem=NUMAR;
      }
   switch(c){
      case '+' :  lexem=PLUS; break;
      case '-' :  lexem=MINUS; break;
      case '*' :  lexem=STEA; break;
      case '/' :  lexem=SLASH; break;
      case '(' :  lexem=PARS; break;
      case ')' :  lexem=PARD; break;
      case '\n' : lexem=NL;  break;
      default :   lexem = 0;
      }
   return lexem;
}

E(void)
{  int t;
   t=T();
   if(lexem &PRIMC)
      return C(t);
   return t;
}

C(int v)
{  int opr,t,e;
   opr=lexem;
   lex();
   t=T();
   e=opr==PLUS ? v+t : v-t ;
   if (lexem & PRIMC)
      return C(e);
   return e;
}

T(void)
{  int f;
   f=F();
   if(lexem & PRIMD)
      return D(f);
   return f;
}

D(int v)
{  int opr,f,t;
   opr=lexem;
   lex();
   f=F();
   t= opr==STEA ? v*f : v/f ;
   if(lexem & PRIMD)
      return D(t);
   return t;
}

F(void)
{  int n;
   if(lexem == NUMAR){
      n=vlexem;lex();
      return n;
      }
   lex(); n = E(); lex();
   return n;
}
