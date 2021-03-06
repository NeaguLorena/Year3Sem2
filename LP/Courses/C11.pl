bplist00—_WebMainResource’	
_WebResourceData_WebResourceMIMEType_WebResourceTextEncodingName^WebResourceURL_WebResourceFrameNameO<html><head></head><body><pre style="word-wrap: break-word; white-space: pre-wrap;">%G1
edge(a,b).
edge(a,c).
edge(b,c).
edge(c,d).
edge(c,e).
edge(e,f).
edge(c,f).
edge(f,a).

%G2
n(a,[b,c]).
n(b,[c]).
n(c,[d,f]).
n(b,[c]).
n(e,[f]).
n(f,[a]).

edge2(X,Y):- n(X,L), member(Y,L).


is_edge(X,Y):-
		edge(X,Y);
		edge(Y,X).

/*

?- bagof(X, Y^edge(X,Y), L). % ^ ignores instantiations of that variable
L = [a, a, b, b, c, c, e, c, f].

?- setof(X, Y^edge(X,Y), L).
L = [a, b, c, e, f].

?- setof(X, edge(X,Y), L).
Y = a,
L = [b, f] ;
Y = b,
L = [a] ;
Y = c,
L = [a, b] ;
Y = d,
L = [c] ;
Y = e,
L = [c] ;
Y = f,
L = [c, e].

*/


%for all ... is true ...
%edge=&gt;edge2

fait12 :- 	edge(X,Y),
			not(edge2(X,Y)),
			!,
			fail.
fait12.

%edge2=&gt;edge
fait21 :- 	edge2(X,Y),
			not(edge(X,Y)),
			!,
			fail.
fait21.

eq12:-fait12, fait21.

%DFS
/*path(X,X,_,[X]).
path(X,Y,Ppath,[X|Path]):-
					edge(X,Z),
					not(member(Z,Ppath)),
					path(Z,Y,[Z|Ppath],Path).*/

:-dynamic visited/1.

dfs(X):-
			edge(X,Z),
			not(visited(Z)),
			assertz(visited(Z)),
			dfs(Z).


collect([X|L]):-retract(visited(X)),
				!,
				collect(L).
collect([]).

do_dfs(X,_):-assertz(visited(X)), dfs(X).
do_dfs(_,L):-collect(L).

%Tema: scrieti un DFS care exploreaza tot graful, si cu colorare (white ,gray, black) - color(Node, Color).


%BFS
/*
bf_search(X,_):-
	assertz(node(X)),
	node(Y),
	is_edge(Y,Z), 
	not(node(Z)), 
	assertz(node(Z)),
	fail. 
bf_search(_,L):-
	assertz(node(end)),
	collect([],L). 
*/

:-dynamic q/1.

expand(X):-edge(X,Y),
			not(q(Y)),
			not(visited(Y)),
			assertz(q(Y)),
			fail.
expand(X):-retract(q(X)),!,
			assertz(visited(X)).


bfs(L):-q(X),!,
		write('first node in queue '),
		write(X),nl,
		expand(X),
		bfs(L).
bfs(L):-collect(L).


do_bfs(X,L):-assertz(q(X)),bfs(L).




</pre></body></html>Ztext/plainUUTF-8_Nhttps://moodle.cs.utcluj.ro/pluginfile.php/82936/mod_resource/content/1/C11.plP    ( : P n } ĒĪľ¬                           