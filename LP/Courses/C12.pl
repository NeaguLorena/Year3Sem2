bplist00?_WebMainResource?	
_WebResourceMIMEType_WebResourceTextEncodingName^WebResourceURL_WebResourceFrameName_WebResourceDataZtext/plainUUTF-8_Nhttps://moodle.cs.utcluj.ro/pluginfile.php/83564/mod_resource/content/1/C12.plPO?<html><head></head><body><pre style="word-wrap: break-word; white-space: pre-wrap;">%%%%%%%%%%%% C12 %%%%%%%%%%%

graph1([	n(a,[b,c,d]),
			n(b,[a,c]),			  
			n(c,[a,b,d]),			  
			n(d,[a,c])			  
		]).

graph2([	n(1,[2,4]),		
			n(2,[1,3,4]),
			n(3,[2,4]),
			n(4,[1,2,3])
		]).


perm(List, [H|R]):- delete(H, List, RList), perm(RList, R).
perm([],[]).

all_perm(L, AllP):- findall(X, perm(L,X), AllP).

delete(H,[H|T],T).
delete(X,[H|T],[H|R]):-
	delete(X,T,R).


tr(1,1).
tr(2,4).
tr(3,9).

%[1,2,3]; [9,1,5]


eq_perm([H1|T1],L2,EQ):-
	delete(H2,L2,T2),
	P=..[EQ,H1,H2],
	P,
	eq_perm(T1,T2,EQ).
eq_perm([],[],_).

iso_graph(L1,L2,List):-eq_perm(L1,L2,eq_neighb), findall(p(A,B),p(A,B),List). % n(1, []) si n(a, []) ...

eq_neighb(n(N1,L1),n(N2,L2)):-
		eq_node(N1,N2),
		eq_perm(L1,L2,eq_node). % 1 si a ....

:-dynamic p/2.
eq_node(N1,N2):-
	p(N1,N2).
eq_node(N1,_):-
	p(N1,_),!,
	fail.
eq_node(_,N2):-
	p(_,N2),!,
	fail.
eq_node(N1,N2):-
	asserta(p(N1,N2)).
eq_node(N1,N2):-
	retract(p(N1,N2)),!,
	fail.


% Dati un algoritm si implementarea Prolog corespunzatoare pentru generarea componentelor conexe ale unui graf neorientat.
% Implementati algoritmul care stabileste daca un graf neorientat este bipartit.

</pre></body></html>    ( > \ k ? ? ? ? ? ?                           ?