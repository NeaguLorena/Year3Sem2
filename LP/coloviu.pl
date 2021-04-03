%Number of atomic elements in a deep incomplete list
nb_elems_atomic(L,C,C):-
	var(L), 
    !.
nb_elems_atomic([H|T],C,C1):-
    atomic(H),
    !,
    C2 is C+1,
    nb_elems_atomic(T,C2,C1).
nb_elems_atomic([H|T],C,C1):-
    nb_elems_atomic(H,R1),
    CC1 is C + R1,
    nb_elems_atomic(T,CC1,C1).
nb_elems_atomic(L,C1):-
    nb_elems_atomic(L,0,C1).

%Count the number of lists and  atomic elements for a deep and 
%incomplete list (the list itself is not counted). 

list_atoms1(L, RL, RA):-
	list_atoms1(L,0,0, RL, RA).
list_atoms1(L, RL,RA, RL, RA):-
	var(L), 
    !.
list_atoms1([H|T], CL, CA, RL, RA):-
    atomic(H),
    !,
    CA2 is CA +1,
    list_atoms1(T,CL,CA2,RL,RA).
list_atoms1([H|T], CL, CA, RL, RA):-
    %nb_elems_atomic(H,RA1),
    list_atoms1(H,RL1,RA1),
    CA1 is CA + RA1,
	CL2 is CL + RL1 + 1,
    list_atoms1(T,CL2,CA1,RL,RA).

%2
tree(t(1,t(4,t(2,_,t(4,_,_)), t(1,_,_)), t(1, t(4,_,t(1,_,_)), _))).

add_nr_occurrences(T,T):-
	var(T),
	!.
add_nr_occurrences(t(Key,L,R), t([Key,N], NL, NR)):-
     search_key(Key,L,C1),
     search_key(Key,R,C2),
     N is C1 + C2 + 1,
	 add_nr_occurrences(L,NL),
     add_nr_occurrences(R,NR).

search_key(_,T,0):-
    var(T),
    !.
search_key(Key, t(Key, L, R), C):-
    !,
    search_key(Key, L, K1),
    search_key(Key, R, K2),
    C is K1 + K2 + 1.
search_key(Key, t(_, L, R), C):-
    search_key(Key, L, K1),
    search_key(Key, R, K2),
    C is K1 + K2.
    

