bplist00Ñ_WebMainResourceÕ	
_WebResourceData_WebResourceMIMEType_WebResourceTextEncodingName^WebResourceURL_WebResourceFrameNameO:ð<html><head></head><body><pre style="word-wrap: break-word; white-space: pre-wrap;">Welcome to SWI-Prolog (threaded, 64 bits, version 8.0.3)
SWI-Prolog comes with ABSOLUTELY NO WARRANTY. This is free software.
Please run ?- license. for legal details.

For online help and background, visit http://www.swi-prolog.org
For built-in help, use ?- help(Topic). or ?- apropos(Word).

?- findall([A,B], append(A,B,[1,2,3,4]), L).
L = [[[], [1, 2, 3, 4]], [[1], [2, 3, 4]], [[1, 2], [3, 4]], [[1, 2, 3], [4]], [[1, 2, 3|...], []]].

?- findall([A,B], append(A,B,[1,2,3,4]), L); true.
L = [[[], [1, 2, 3, 4]], [[1], [2, 3, 4]], [[1, 2], [3, 4]], [[1, 2, 3], [4]], [[1, 2, 3|...], []]] [write]
L = [[[], [1, 2, 3, 4]], [[1], [2, 3, 4]], [[1, 2], [3, 4]], [[1, 2, 3], [4]], [[1, 2, 3, 4], []]] .

?- findall(
, member(X, [1,2,3,4]), L); true.
L = [_3292, _3286, _3280, _3274] .

?- findall(A, member(A, [1,2,3,4]), L); true.
L = [1, 2, 3, 4] ;
true.

?- findall(A, member(A, [1,2,3,4]), L).
L = [1, 2, 3, 4].

?- findall(A, member(6, [1,2,3,4]), L).
L = [].

?- findall(A, append(A,_,[1,2,3,4]), length(A, 2), L).
false.

?- append(A,_,[1,2,3,4]), length(A, 2).
A = [1, 2] ;
false.

?- findall(A, (append(A,_,[1,2,3,4]), length(A, 2)), L).
L = [[1, 2]].

?- findall(A, (append(_,A,[1,2,3,4]), length(A, 2)), L).
L = [[3, 4]].

?- findall(A, member(X, [1,2,1,3,4]), L).
L = [_3210, _3204, _3198, _3192, _3186].

?- findall(A, member(A, [1,2,1,3,4]), L).
L = [1, 2, 1, 3, 4].

?- setof(A, member(A, [1,2,1,3,4]), L).
L = [1, 2, 3, 4].

?- findall(A, (append(_,A,[1,2,3,4]), length(A, 5)), L).
L = [].

?- setof(A, (append(_,A,[1,2,3,4]), length(A, 5)), L).
false.

?- bagof(A, (append(_,A,[1,2,3,4]), length(A, 5)), L).
false.

?- bagof(A, member(A, [1,2,1,3,4]), L).
L = [1, 2, 1, 3, 4].


% /Users/cami/Desktop/C11.pl compiled 0.00 sec, 9 clauses
?- findall(X, edge(a,X), L).
L = [b, c].


% /Users/cami/Desktop/C11 compiled 0.00 sec, 1 clauses
?- findall(X, is_edge(a,X), L).
L = [b, c, b, f].

?- setof(X, edge(X,_), L).
L = [b, f] ;
L = [a] .

?- setof(X, is_edge(X,_), L).
L = [b, c, f] ;
L = [a, c] ;
L = [a, b, d, e, f] ;
L = [c] ;
L = [c, f] ;
L = [a, c, e].

?- setof(X, edge(X,_), L).
L = [b, f] .

?- edge(X,Y).
X = a,
Y = b ;
X = a,
Y = c ;
X = b,
Y = a ;
X = b,
Y = c ;
X = c,
Y = d ;
X = c,
Y = e ;
X = e,
Y = f ;
X = c,
Y = f ;
X = f,
Y = a.

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

?- edge(X,Y).
X = a,
Y = b ;
X = a,
Y = c ;
X = b,
Y = a ;
X = b,
Y = c ;
X = c,
Y = d ;
X = c,
Y = e ;
X = e,
Y = f ;
X = c,
Y = f ;
X = f,
Y = a.

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

?- bagof(X, edge(X,Y), L).
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
L = [e, c].

?- bagof(X, Y^edge(X,Y), L).
L = [a, a, b, b, c, c, e, c, f].

?- setof(X, Y^edge(X,Y), L).
L = [a, b, c, e, f].

?- setof(X, edge(X,_), L).
L = [b, f] ;
L = [a] ;
L = [a, b] ;
L = [c] ;
L = [c] ;
L = [c, e].

?- setof(X, Y^is_edge(X,Y), L).
L = [a, b, c, d, e, f].

?- setof(X, (Y^edge(X,Y);edge(Y,X)), L).
ERROR: Undefined procedure: (^)/2
ERROR:   ^/2 can only appear as the 2nd argument of setof/3 and bagof/3
ERROR: In:
ERROR:   [15] _1486^edge(_1492,_1494)
ERROR:   [14] '&lt;meta-call&gt;'(user:(...;...)) &lt;foreign&gt;
ERROR:   [13] '$bags':findall_loop(v(_1586)-_1582,user:(...;...),_1574,[]) at /Applications/SWI-Prolog.app/Contents/swipl/boot/bags.pl:98
ERROR:   [12] setup_call_catcher_cleanup('$bags':'$new_findall_bag','$bags':findall_loop(...,...,_1648,[]),_1626,'$bags':'$destroy_findall_bag') at /Applications/SWI-Prolog.app/Contents/swipl/boot/init.pl:468
ERROR:    [8] '$bags':setof(_1686,user:(...;...),_1690) at /Applications/SWI-Prolog.app/Contents/swipl/boot/bags.pl:240
ERROR:    [7] &lt;user&gt;
ERROR: 
ERROR: Note: some frames are missing due to last-call optimization.
ERROR: Re-run your program in debug mode (:- debug.) to get more detail.
   Exception: (15) _306^edge(_304, _306) ? setof(X, (Y^edge(X,Y);edge(Y,X)), L).creep
^  Exception: (12) setup_call_catcher_cleanup('$bags':'$new_findall_bag', '$bags':findall_loop(v(_306)-_304, user:(_306^edge(_304, _306);edge(_306, _304)), _726, []), _1768, '$bags':'$destroy_findall_bag') ? creep
^  Call: (14) call('$bags':'$destroy_findall_bag') ? creep
^  Exit: (14) call('$bags':'$destroy_findall_bag') ? creep
?- 
|    setof(X, (Y^edge(X,Y);Y^edge(Y,X)), L).
ERROR: Undefined procedure: (^)/2
ERROR:   ^/2 can only appear as the 2nd argument of setof/3 and bagof/3
ERROR: In:
ERROR:   [15] _3298^edge(_3304,_3306)
ERROR:   [14] '&lt;meta-call&gt;'(user:(...;...)) &lt;foreign&gt;
ERROR:   [13] '$bags':findall_loop(v(_3398)-_3394,user:(...;...),_3386,[]) at /Applications/SWI-Prolog.app/Contents/swipl/boot/bags.pl:98
ERROR:   [12] setup_call_catcher_cleanup('$bags':'$new_findall_bag','$bags':findall_loop(...,...,_3460,[]),_3438,'$bags':'$destroy_findall_bag') at /Applications/SWI-Prolog.app/Contents/swipl/boot/init.pl:468
ERROR:    [8] '$bags':setof(_3498,user:(...;...),_3502) at /Applications/SWI-Prolog.app/Contents/swipl/boot/bags.pl:240
ERROR:    [7] &lt;user&gt;
ERROR: 
ERROR: Note: some frames are missing due to last-call optimization.
ERROR: Re-run your program in debug mode (:- debug.) to get more detail.
   Exception: (15) _2054^edge(_2052, _2054) ? creep
^  Exception: (12) setup_call_catcher_cleanup('$bags':'$new_findall_bag', '$bags':findall_loop(v(_2054)-_2052, user:(_2054^edge(_2052, _2054);_2054^edge(_2054, _2052)), _2502, []), _3580, '$bags':'$destroy_findall_bag') ? creep
^  Call: (14) call('$bags':'$destroy_findall_bag') ? creep
^  Exit: (14) call('$bags':'$destroy_findall_bag') ? creep
?- setof(X, ((Y^edge(X,Y));(Y^edge(Y,X))), L).
ERROR: Undefined procedure: (^)/2
ERROR:   ^/2 can only appear as the 2nd argument of setof/3 and bagof/3
ERROR: In:
ERROR:   [15] _5116^edge(_5122,_5124)
ERROR:   [14] '&lt;meta-call&gt;'(user:(...;...)) &lt;foreign&gt;
ERROR:   [13] '$bags':findall_loop(v(_5216)-_5212,user:(...;...),_5204,[]) at /Applications/SWI-Prolog.app/Contents/swipl/boot/bags.pl:98
ERROR:   [12] setup_call_catcher_cleanup('$bags':'$new_findall_bag','$bags':findall_loop(...,...,_5278,[]),_5256,'$bags':'$destroy_findall_bag') at /Applications/SWI-Prolog.app/Contents/swipl/boot/init.pl:468
ERROR:    [8] '$bags':setof(_5316,user:(...;...),_5320) at /Applications/SWI-Prolog.app/Contents/swipl/boot/bags.pl:240
ERROR:    [7] &lt;user&gt;
ERROR: 
ERROR: Note: some frames are missing due to last-call optimization.
ERROR: Re-run your program in debug mode (:- debug.) to get more detail.
   Exception: (15) _3866^edge(_3864, _3866) ? setof(X, ((Y^edge(X,Y));(Y^edge(Y,X))), L).creep
^  Exception: (12) setup_call_catcher_cleanup('$bags':'$new_findall_bag', '$bags':findall_loop(v(_3866)-_3864, user:(_3866^edge(_3864, _3866);_3866^edge(_3866, _3864)), _4320, []), _5398, '$bags':'$destroy_findall_bag') ? creep
^  Call: (14) call('$bags':'$destroy_findall_bag') ? creep
^  Exit: (14) call('$bags':'$destroy_findall_bag') ? creep
?- 
|    setof(X, ((Y^edge(X,Y));(Y^edge(Y,X))), L).
ERROR: Undefined procedure: (^)/2
ERROR:   ^/2 can only appear as the 2nd argument of setof/3 and bagof/3
ERROR: In:
ERROR:   [15] _6906^edge(_6912,_6914)
ERROR:   [14] '&lt;meta-call&gt;'(user:(...;...)) &lt;foreign&gt;
ERROR:   [13] '$bags':findall_loop(v(_7006)-_7002,user:(...;...),_6994,[]) at /Applications/SWI-Prolog.app/Contents/swipl/boot/bags.pl:98
ERROR:   [12] setup_call_catcher_cleanup('$bags':'$new_findall_bag','$bags':findall_loop(...,...,_7068,[]),_7046,'$bags':'$destroy_findall_bag') at /Applications/SWI-Prolog.app/Contents/swipl/boot/init.pl:468
ERROR:    [8] '$bags':setof(_7106,user:(...;...),_7110) at /Applications/SWI-Prolog.app/Contents/swipl/boot/bags.pl:240
ERROR:    [7] &lt;user&gt;
ERROR: 
ERROR: Note: some frames are missing due to last-call optimization.
ERROR: Re-run your program in debug mode (:- debug.) to get more detail.
   Exception: (15) _5684^edge(_5682, _5684) ? creep
^  Exception: (12) setup_call_catcher_cleanup('$bags':'$new_findall_bag', '$bags':findall_loop(v(_5684)-_5682, user:(_5684^edge(_5682, _5684);_5684^edge(_5684, _5682)), _6110, []), _7188, '$bags':'$destroy_findall_bag') ? creep
^  Call: (14) call('$bags':'$destroy_findall_bag') ? creep
^  Exit: (14) call('$bags':'$destroy_findall_bag') ? creep
?- 
|    setof((X,Y), (edge(X,Y);edge(Y,X)), L).
L = [(a, b),  (a, c),  (a, f),  (b, a),  (b, c),  (c, a),  (c, b),  (c, d),  (c, e),  (c, f),  (d, c),  (e, c),  (e, f),  (f, a),  (f, c),  (f, e)].

?- findall((X,Y), (edge(X,Y);edge(Y,X)), L).
L = [(a, b),  (a, c),  (b, a),  (b, c),  (c, d),  (c, e),  (e, f),  (c, f),  (f, a),  (b, a),  (c, a),  (a, b),  (c, b),  (d, c),  (e, c),  (f, e),  (f, c),  (a, f)].


% /Users/cami/Desktop/C11 compiled 0.00 sec, 6 clauses
?- edge2(a,b).
true ;
false.


% /Users/cami/Desktop/C11 compiled 0.00 sec, 2 clauses
?- fait12.
true.


% /Users/cami/Desktop/C11 compiled 0.00 sec, 0 clauses
?- fait12.
false.


Warning: /Users/cami/Desktop/C11.pl:65:
	Clauses of fait12/0 are not together in the source-file
	  Earlier definition at /Users/cami/Desktop/C11.pl:54
	  Current predicate: fait21/0
	  Use :- discontiguous fait12/0. to suppress this message
% /Users/cami/Desktop/C11 compiled 0.00 sec, 2 clauses
% /Users/cami/Desktop/C11 compiled 0.00 sec, 0 clauses
?- fait12.
true.


% /Users/cami/Desktop/C11 compiled 0.00 sec, 0 clauses
?- fait12.
false.


% /Users/cami/Desktop/C11 compiled 0.00 sec, 5 clauses
Warning: The predicates below are not defined. If these are defined
Warning: at runtime using assert/1, use :- dynamic Name/Arity.
Warning: 
Warning: dfs/1, which is referenced by
Warning: 	/Users/cami/Desktop/C11.pl:82:24: 1-st clause of dfs/2
% /Users/cami/Desktop/C11 compiled 0.00 sec, 0 clauses
?- dfs(a,L).
true .


% /Users/cami/Desktop/C11 compiled 0.00 sec, 0 clauses
?- dfs(a,L).
L = [b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] .

?- visited(C).
false.


% /Users/cami/Desktop/C11 compiled 0.00 sec, 1 clauses
?- do_dfs(a,L).
L = [a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] ;
L = [e, f, a, b, c, d] .


% /Users/cami/Desktop/C11 compiled 0.00 sec, 0 clauses
?- visited(J).
false.

?- do_dfs(a,L).
L = [a, b, c, d, e, f].


% /Users/cami/Desktop/C11 compiled 0.00 sec, 5 clauses
Warning: The predicates below are not defined. If these are defined
Warning: at runtime using assert/1, use :- dynamic Name/Arity.
Warning: 
Warning: q/1, which is referenced by
Warning: 	/Users/cami/Desktop/C11.pl:119:8: 1-st clause of bfs/1
Warning: 	/Users/cami/Desktop/C11.pl:111:28: 1-st clause of expand/1
% /Users/cami/Desktop/C11 compiled 0.00 sec, 0 clauses
?- assertz(q(a)).
true.

?- expand(a).
true.

?- listing(q/1), listing(visited/1).
:- dynamic q/1.

q(b).
q(c).

:- dynamic visited/1.

visited(a).

true.

?- q(X), expand(X).
X = b .

?- listing(q/1), listing(visited/1).
:- dynamic q/1.

q(c).

:- dynamic visited/1.

visited(a).
visited(b).

true.

?- q(X), expand(X).
X = c.

?- listing(q/1), listing(visited/1).
:- dynamic q/1.

q(d).
q(e).
q(f).

:- dynamic visited/1.

visited(a).
visited(b).
visited(c).

true.

?- q(X), expand(X).
X = d .

?- listing(q/1), listing(visited/1).
:- dynamic q/1.

q(e).
q(f).

:- dynamic visited/1.

visited(a).
visited(b).
visited(c).
visited(d).

true.

?- q(X), expand(X).
X = e .

?- listing(q/1), listing(visited/1).
:- dynamic q/1.

q(f).

:- dynamic visited/1.

visited(a).
visited(b).
visited(c).
visited(d).
visited(e).

true.

?- q(X), expand(X).
X = f.

?- listing(q/1), listing(visited/1).
:- dynamic q/1.


:- dynamic visited/1.

visited(a).
visited(b).
visited(c).
visited(d).
visited(e).
visited(f).

true.

?- q(X), expand(X).
false.

?- collect(L).
L = [a, b, c, d, e, f].

?- q(X), expand(X).
false.

?- 
|    listing(q/1), listing(visited/1).
:- dynamic q/1.


:- dynamic visited/1.


true.

?- do_bfs(X,L).
L = [_13872] .

?- listing(q/1), listing(visited/1).
:- dynamic q/1.


:- dynamic visited/1.


true.

?- do_bfs(a,L).
L = [a, b, c, d, e, f] ;
L = [] ;
L = [] ;
L = [f, a, b, c, d, e] ;
L = [] ;
L = [] ;
L = [] ;
L = [] ;
L = [] ;
L = [] ;
L = [] ;
L = [] ;
L = [].


% /Users/cami/Desktop/C11 compiled 0.00 sec, 0 clauses
?- listing(q/1), listing(visited/1).
:- dynamic q/1.

q(f).
q(d).
q(e).

:- dynamic visited/1.


true.

?- retractall(q(_)).
true.

?- listing(q/1), listing(visited/1).
:- dynamic q/1.


:- dynamic visited/1.


true.

?- do_bfs(a,L).
L = [a, b, c, d, e, f].


% /Users/cami/Desktop/C11 compiled 0.00 sec, 0 clauses
?- do_bfs(a,L).
L = [a, b, c, d, e, f] ;
L = [] ;
L = [] ;
L = [f, a, b, c, d, e] ;
L =
L = [] ;
L = [] ;
L = [] ;
L = [] ;
L = [] ;
L = [] ;
L = [] ;
L = [].

?-  [] ;


|    
|    a
|    a
|    a
|    
|    
|    
|    .
ERROR: Syntax error: Operator expected
ERROR: a
ERROR: ** here **
ERROR: 
a
a . 
?- listing(q/1), listing(visited/1).
:- dynamic q/1.

q(f).
q(d).
q(e).

:- dynamic visited/1.


true.

?- listing(q/1), listing(visited/1).
:- dynamic q/1.

q(f).
q(d).
q(e).

:- dynamic visited/1.


true.

?- retractall(q(_)).
true.

?- listing(q/1), listing(visited/1).
:- dynamic q/1.


:- dynamic visited/1.


true.


% /Users/cami/Desktop/C11 compiled 0.00 sec, 0 clauses
% /Users/cami/Desktop/C11 compiled 0.00 sec, 0 clauses
?- listing(q/1), listing(visited/1).
:- dynamic q/1.


:- dynamic visited/1.


true.

?- do_bfs(a,L).
first node in queuea
first node in queueb
first node in queuec
first node in queued
first node in queuee
first node in queuef
L = [a, b, c, d, e, f] ;
L = [] ;
first node in queuef
L = [] ;
first node in queuee
first node in queuef
first node in queuea
first node in queueb
first node in queuec
first node in queued
first node in queuee
L = [f, a, b, c, d, e] </pre></body></html>Ztext/plainUUTF-8_Uhttps://moodle.cs.utcluj.ro/pluginfile.php/82937/mod_resource/content/1/trace_C11.txtP    ( : P n } ”;ˆ;“;™;ñ                           ;ò