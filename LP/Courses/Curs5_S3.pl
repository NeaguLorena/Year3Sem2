bplist00?_WebMainResource?	
_WebResourceFrameName_WebResourceData_WebResourceMIMEType_WebResourceTextEncodingName^WebResourceURLPO?<html><head></head><body><pre style="word-wrap: break-word; white-space: pre-wrap;">:- dynamic insect/1.

insect(cockroach).
insect(ant).
insect(bee).


test_logical_update :- (retract(insect(I)),
						write(I), nl,
						retract(insect(II)),
						write(II), nl,
						fail)
						;
						true.
/*
cockroach
ant
bee
ant
bee
*/


%Arbori
tree1(t(10, t(6, t(4, nil, nil), t(7, nil, t(8, nil, nil))), t(14, t(12, nil,nil), t(15, nil,nil)))).
tree2(nil).
tree3(t(6, nil, nil)).

%inorder print - O(n)
inorder(nil).
inorder(t(K,L,R)):- 
					inorder(L),
					write(K),
					nl,
					inorder(R).

% inorder tree to list - fwd rec - O(nlogn) mediu, O(n^2) defav
inorder(nil, L, L).
inorder(t(K,L,R), Acc, Rez):-
							inorder(L, Acc, Rez1),
							append(Rez1, [K], AccR),
							inorder(R, AccR, Rez).

%inorder tree to list - bwd rec - O(nlogn) mediu, O(n^2) defav
inorder(nil, []).
inorder(t(K,L,R), Rez):- inorder(L, LLeft),
					  append(LLeft, [K], LK), 
					  inorder(R, LRight),
					  append(LK, LRight, Rez).

%inorder tree to list - bwd - better - O(nlogn) mediu, O(n^2) defav
inorderb(nil, []).
inorderb(t(K,L,R), Rez):- 	inorderb(L, LLeft),
					  		inorderb(R, LRight),
					  		append(LLeft, [K|LRight], Rez).


%permutations
perm([],[]).
perm(L, [X|RI]):- select_X(X, L, LX), perm(LX, RI).

%select_X(X, L, LX):- member(X, L), delete1(X, L, LX).
%select_X(X, L, LX):- delete1(X, L, LX).
select_X(X, L, LX):- append(A, [X|B], L), append(A, B, LX).


delete1(H, [H|T], T). %cu sau fara !, depinde daca vrei determinist sau nu (la member e determinist)
delete1(H, [X|T], [X|R]):- delete1(H, T, R).


all_perms(L, _):- perm(L, R),
					assert(p(R)),
					fail.
all_perms(_,Rez):-collect(Rez).

collect([L|R]):-retract(p(L)),
			!,
			collect(R).
collect([]).

</pre></body></html>Ztext/plainUUTF-8_Shttps://moodle.cs.utcluj.ro/pluginfile.php/80638/mod_resource/content/1/Curs5_S3.pl    ( ? Q g ? ? ????                           ?