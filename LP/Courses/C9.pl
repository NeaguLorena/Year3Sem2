bplist00?_WebMainResource?	
_WebResourceData_WebResourceMIMEType_WebResourceTextEncodingName^WebResourceURL_WebResourceFrameNameO?<html><head></head><body><pre style="word-wrap: break-word; white-space: pre-wrap;">%HANOI

:-dynamic src/1, dest/1, interm/1.

init_pole(_,0):-!.
init_pole(P,N):-
		D=..[P,N],
		asserta(D),
		N1 is N-1,
		init_pole(P,N1).

move_discs(0,_,_,_):-!.
move_discs(N, Src, Interm, Dest):-
		N1 is N-1,
		move_discs(N1, Src, Dest, Interm),
		move(Src, Dest),
		move_discs(N1, Interm, Src, Dest).

move(Src, Dest):-
	D=..[Src, N], % se formeaza src(N), N e neinstantiat
	retract(D), %instantiaza N si sterge de pe source pole
	!,
	write('moving disk '),
	write(N),
	write(' from '),
	write(Src),
	write(' to '),
	write(Dest),
	nl,
	DD=..[Dest,N], % se formeaza dest(N), N e instantiat
	asserta(DD).


%Tema: implementarea cu functor si arg

%Replace subexpression in expression
/*OExpr: 2+3*5-6+2+3-9
OSExpr:2+3 
NSExpr: 5*9
NExpr: 5*9*5-6+5*9-9
*/

subst(Old,New,Old,New):-!.
subst(Val,Val,_,_):-
	atomic(Val),!.
subst(Val,NewVal,OldSubExpr,NewSubExpr):-
	functor(Val,F,N),
	functor(NewVal,F,N),
	subst_args(N,Val,NewVal,OldSubExpr,NewSubExpr).


subst_args(0,_,_,_,_):-!.
subst_args(N, Val, NewVal, OldSE, NewSE):-
	N1 is N-1,
	arg(N, Val, OldArg),
	subst(OldArg, NewArg, OldSE, NewSE),
	arg(N, NewVal, NewArg),
	subst_args(N1, Val, NewVal, OldSE, NewSE).

</pre></body></html>Ztext/plainUUTF-8_Mhttps://moodle.cs.utcluj.ro/pluginfile.php/82211/mod_resource/content/1/C9.plP    ( : P n } ?????                           ?