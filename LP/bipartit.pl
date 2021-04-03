/*Graf G=(V,E) - neorientat, conex - bipartit, iff V=reun(V1,V2), inters(V1,V2) = EMPTY, and for every (u,v) from E, either u in V1 and v in V2, or u in V2 and v in V1.*/

:-dynamic color/2.
:-dynamic que/1.

negate(red,green).
negate(green,red).

edge(a,b).
edge(a,c).
edge(b,d).
edge(e,f).
edge(e,c).
edge(c,f).

is_edge(X,Y):-edge(X,Y);edge(Y,X).


bfs:-	q(X),
		!,
		expand(X),
		bfs.
bfs.


expand(X):-	is_edge(X,Y),
			color(X,C),
			not(process(Y,C)),
			!,
			fail.
expand(X):-retract(q(X)),!.


process(Node,Color):-   color(Node,Color),
						!,
						writeln('Graful nu e bipartit'),
						fail.
process(Node,_):- 	color(Node,_),
					!.
process(Node,Color):- 	negate(Color, NColor),
						assertz(color(Node,NColor)),
						assertz(q(Node)).


startup_bi:-
		edge(X,_),!,
		assertz(q(X)),
		assertz(color(X,red)),
		bfs.

/*Graph with colors assosciated to nodes. Generate subgraph containing those nodes (and
	corresponding edges) that do not have a neighbor node of the same color*/

n(a, red, [b,c]).
n(b, blue, [a,c,d]).
n(c, blue, [a,b,d]).
n(d, red, [b,c,e]).
n(e, green, [d]).

/*
sn(a, red,[]).
sn(d,red,[e]).
sn(e,green,[d]).
*/

:-dynamic p/1.

gen_nodes:- n(X,Color,Neighbors),
			process(X,Color,Neighbors),
			fail.
gen_nodes:-gen_edges.

process(_,Color,[H|_]):- n(H, Color, _),
						!,
						fail.
process(X,Color,[_|T]):-process(X,Color,T).
process(X,Color,[]):- assertz(sn(X,Color,[])).

gen_edges:- sn(X,C,_),
			n(X,_,Neighbors),
			findall(Y, sn(Y,_,_), Vertices),
			%writeln(Vertices),
			%writeln(Neighbors),
			inters(Neighbors, Vertices, NNeighbors),
			update(X,C,NNeighbors),
			fail.
gen_edges.

update(N,C,NList):-retract(sn(N,_,_)),
					!,
					assertz(sn(N,C,NList)).

inters([H|T], L, [H|R]):-member(H,L),!,
					inters(T,L,R).
inters([_|T],L,R):-inters(T,L,R).
inters([],_,[]).
			






							







