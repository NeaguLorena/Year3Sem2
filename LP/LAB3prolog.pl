gcd(A,B,G):-
	A=B,
	G=A.
gcd(A,A,A).
gcd(A,B,G):-
	A>B,
	V is A-B,
	gcd(V,B,G).
gcd(A,B,G):-
	A<B,
	V is B-A,
	gcd(A,V,G).

fact(0,1).
fact(N,F):-
    N >0,
    N1 is N-1,
    fact(N1,F1),
    F is F1*N.

fact1(0, FF, FF).
fact1(N, FP, FF):-
    N>0,
    N1 is N-1,
    FP1 is FP*N,
    fact1(N1, FP1, FF).

fact1_pretty(N,F):-
    fact1(N,1,F).

forLoop(In,In,0):-!. 
forLoop(In,Out,I):-
	NewI is I-1,
    Intermediate is In + I,
    forLoop(Intermediate,Out,NewI).

lcm(A,B,L):-
    A=B,
    L=A.
lcm(A,B,L):-
    Intermediate is A*B,
    gcd(A,B,G),
    L is Intermediate/G.

fib(0,1).
fib(1,1).
fib(N,R) :-
    N>1,
    N1 is N-1,
    N2 is N-2,
    fib(N1,F1),
    fib(N2,F2),
    R is F1 + F2.

repUntil(L,H):-
    I is L + 1,
    I < H,
    repUntil(I,H).

while(L,H):-
    L < H,
    NewL is L+1,
    while(NewL,H).

triangle(A,B,C):-
    I = B + C,
    A > I,
    triangle(A,C,B),
    triangle(B,A,C).

solve_eg(A,B,C,X1):-
    D is B*B -4*A*C,
    SQ is 
    X1 is -B+sqrt(D)/2*A,
solve_eq(A,B,C,X2):-
    DD is B*B,
    DDD is 4*A*C,
    D is DD-DDD,
    X2 is -B-sqrt(D)/2*A.
    
