diameter(T, D):-diameter_accH(T, D,  ).
diameter_accH(t(, L, R), D, H):- diameter_acc_H(L, DL, HL), diameter_acc_H(R, DR, HR), max(HL, HR, HMax),
    H is HMax + 1,
    max(DL, DR, DMax),
    HDiam is HL + HR,
    max(DMax, HDiam, D).
diameter_acc_H(nil, 0, 0).

transform_to_list(nil, []).
transform_to_list(tree(K, nil, Right), [K|L]) :-
  transform_to_list(Right, L).
transform_to_list(T, L) :-
  rotate_right(T, NewT),
  transform_to_list(NewT, L).

rotate_right(tree(K, L, R), NewT) :-
  L = tree(LK, LL, LR),
  NewT = tree(LK , LL, tree(K, LR, R)).
right_rot(t(t(A,P,B),Q,C), t(A,P,t(B,Q,C))).
///////////
t2l_lin_rec(t(t(A,P,B),Q,C),List):-
    t2l_lin_rec(t(A,P,t(B,Q,C)),List).
t2l_lin_rec(t(nil,Q,C),[Q|List]):-
    t2l_lin_rec(C,List).
t2l_lin_rec(nil,[]).

generateNodes:-
    neighbours(N,LV),
    col(N,C),
    validCol(C,LV),
    assertz(solNode(N,C)),
    fail.
generateNodes.

validCol(C,[H|T]):-
    col(H,CH),
    C=\= CH, !,
    validCol(C,T).
validCol(_,[]).
%-------------------------------------
generateEdges:-
    solNode(A,_),
    neighbour(A,LVA),
    checkLVA(A,LVA),
    fail.
generateEdges.

isSolNode(X,Y):-
    solNode(X,Y);solNode(Y,X).

checkLVA(A,[H|T]):-
    isSolNode(H,_),
    assertz(solEdge(A,H)),
    checkLVA(A,T).
checkLVA(_,[]).