#include "evol1.h"
#include "ytab.h"

static Simbol *simblist=0; /* tabela de simboluri e o lista */

Simbol *caut(s)     /* cauta in tabela de simboluri */
	char *s;
{	Simbol *sp;
	for(sp=simblist;sp!=(Simbol *) 0;sp=sp->urm)
		if(strcmp(sp->nume,s)==0)  return sp;
	return (Simbol *) 0;  /* nu l-a gasit */ }

Simbol *instal(s,t,d) /* instal. s in tab. de simb.*/
	char *s; int t; double d;
{	Simbol *sp;
	char *emalloc();
	sp=(Simbol *) emalloc(sizeof(Simbol));
	sp->nume=emalloc(strlen(s)+1);   /* +1 ptr. '\0' */
	strcpy(sp->nume,s);
	sp->tip=t;
	sp->u.val=d;
	sp->urm=simblist;  /* inserare in capul listei */
	simblist=sp;
	return sp;
}

char *emalloc(n)            /* verifica revenirea din malloc */
	unsigned n;
{	char *p, *malloc();
	p=malloc(n);
	if(p==0)   execerror("Depasire de memorie",(char *) 0);
	return p;
}