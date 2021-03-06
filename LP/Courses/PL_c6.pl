bplist00—_WebMainResource’	
_WebResourceData_WebResourceMIMEType_WebResourceTextEncodingName^WebResourceURL_WebResourceFrameNameO<html><head></head><body><pre style="word-wrap: break-word; white-space: pre-wrap;">tree1(t(7, t(4, t(2, nil, nil), t(6, nil, nil)), t(12, t(9, nil, nil), t(15, nil, t(18, nil, t(18, nil, nil)))))).

inorderb(nil, []).
inorderb(t(K,L,R), Rez):- 	inorderb(L, LLeft),
					  		inorderb(R, LRight),
					  		append(LLeft, [K|LRight], Rez).

%search BST
searchBST(Key, t(Key, _, _)):-!.
searchBST(Key, t(K, L, _)):- Key &lt; K, 
							!,
							searchBST(Key, L).
searchBST(Key, t(_, _, R)):- searchBST(Key, R).

%search BT
searchBT(Key, t(Key, _, _)):-!.
searchBT(Key, t(_, L, R)):- (searchBT(Key, L), !) ; (searchBT(Key, R)).


%insertBST
insertBST(Key, nil, t(Key, nil, nil)).
insertBST(Key, t(Key, L, R), t(Key, L, R)):- write('Cheia exista in arbore!'), !.
insertBST(Key, t(K, L, R), t(K, NL, R)):- Key &lt; K, 
							!,
							insertBST(Key, L, NL).
insertBST(Key, t(K, L, R), t(K, L, NR)):- insertBST(Key, R, NR).


%insertBT - TEMA! (choose where - left/right; deterministic/non-deterministic versions!)


%deleteBST
deleteBST(_, nil, nil). %key not in tree, return tree unchanged
%deleteBST(Key, t(Key, nil, nil), nil):-!. %must delete leaf; not needed - covered by next clause 
deleteBST(Key, t(Key, nil, R), R):-!. %delete node with 1 child or leaf
deleteBST(Key, t(Key, L, nil), L):-!. %delete node with 1 child (or leaf)
deleteBST(Key, t(Key, L, R), t(Succ, L, NR)):- !, get_min(R, Succ),
									deleteBST(Succ, R, NR).

deleteBST(Key, t(K, L, R), t(K, NL, R)):- Key &lt; K, 
							!,
							deleteBST(Key, L, NL).
deleteBST(Key, t(K, L, R), t(K, L, NR)):- deleteBST(Key, R, NR).

get_min(t(Key, nil, _), Key):-!.
get_min(t(_, L, _), Succ):-get_min(L, Succ).


%%%%%%%%% INCOMPLETE LISTS %%%%%%%%%%%%%%%
% L = [1,2,3,4|_]

member_il(_, L):- var(L),!, fail.
member_il(X, [X|_]).
member_il(X, [_|T]):-member_il(X,T).

%pred(..., IStruct):-var(IStruct), !, .... - ALWAYS FIRST!


%insert_il(X, L):- var(L),!, L=[X|_]. %not necessary, but clearer if you have it
insert_il(X, [X|_]):-!.
insert_il(X, [_|T]):-insert_il(X,T).

</pre></body></html>Ztext/plainUUTF-8_Phttps://moodle.cs.utcluj.ro/pluginfile.php/81114/mod_resource/content/1/PL_c6.plP    ( : P n } Ēě©Į	                           	