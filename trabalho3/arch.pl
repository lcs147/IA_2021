backliteral( isa(X, Y), [X:object], []) :-
    member( Y, [polygon, convex_poly, stable_poly, unstable_poly, triangule, rectangle, trapezium, unstable_triangule, hexagon]).

backliteral( support(X,Y), [X:object, Y:object], []).
backliteral( touch(X,Y), [X:object, Y:object], []).
backliteral( \+(G), [X:object, Y:object], []) :-
    G = touch(X,Y); G = support(X,Y).

prolog_predicate( isa(X,Y)).
prolog_predicate( support(X,Y)).
prolog_predicate( touch(X,Y)).
prolog_predicate( \+(G)).

ako( polygon, convex_poly).
ako( convex_poly, stable_poly).
ako( convex_poly, unstable_poly).
ako( convex_poly, triangule).
ako( convex_poly, rectangle).
ako( convex_poly, trapezium).
ako( convex_poly, unstable_triangule).
ako( convex_poly, hexagon).

ako( rectangle, X) :-
    member( X, [a1,a2,a3,a4,a5,b1,b2,b3,b4,b5,c1,c2,c3]).

ako( triangule, c4).
ako( unstable_triangule, c5).

isa( Figure1, Figure2) :-
    ako( Figure2, Figure1).

isa( Fig0, Fig) :-
    ako( Fig1, Fig0),
    isa( Fig1, Fig).

support(a1,c1).     support(b1,c1).
support(a3,c3).     support(b3,c3).     touch(a3,b3).
support(a4,c4).     support(b4,c4).
support(a5,c5).     support(b5,c5).

start_clause( [ arch(X,Y,Z)] / [X:object,Y:object,Z:object]).

ex( arch(a1,b1,c1)).
ex( arch(a4,b4,c4)).

nex( arch(a2,b2,c2)).
nex( arch(a3,b3,c3)).
nex( arch(a5,b5,c5)).
nex( arch(a1,b2,c1)).
nex( arch(a2,b1,c1)).
