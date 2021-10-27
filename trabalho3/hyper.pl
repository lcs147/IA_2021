:- op(500, xfx, :).

prove(Goal, Hypo, Answer) :-
    max_proof_lenght(D),
    prove(Goal, Hypo, D, RestD),
    (RestD >=0, Answer = yes
    ;
     RestD<0, !, Answer = maybe
    ).
prove(Goal, _, no).
prove(G, H, D, D) :- 
    D<0, !.
prove([], _, D, D) :- !.
prove([G1|Gs], Hypo, D0, D) :- !,
    prove(G1, Hypo, D0, D1),
    prove(Gs, Hypo, D1, D).
prove(G, _, D, D) :-
    prolog_predicate(G),
    call(G).
prove(G, Hyp, D0, D) :-
    D0 =< 0, !, D is D0-1;
    D1 is D0-1,
    member(Clause/Vars, Hyp),
    copy_term(Clause, [Head|Body]),
    G = Head,
    prove(Body, Hyp, D1, D).

induce(Hyp) :-
    init_counts, !,
    start_hyps(Hyps),
    best_search(Hyps, _:Hyp).

best_search([Hyp|Hyps], Hyp) :-
    show_counts,
    Hyp = 0:H,
    complete(H).

best_search([C0:H0 | Hyps0], H) :-
    write('Refining hypo with cost'), write(C0),
    write(:), nl, show_hyp(H0), nl,
    all_refinements(H0, NewHs),
    add_hyps(NewHs, Hyps0, Hyps), !,
    add1(refined),
    best_search(Hyps, H).

all_refinements(H0, Hyps) :-
    findall(C:H,
            (   refine_hyp(H0, H),
                once((add1(generated),
                    complete(H),
                    add1(complete),
                    eval(H, C)
            ))),
            Hyps).

add_hyps(Hyps1, Hyps2, Hyps) :-
    mergesort(hyps1, OrderedHyps1),
    merge(Hyps2, OrderedHyp1, Hyps).

not(A,B,C):-
    A,
    B,
    C, !, fail.
not(_,_,_).

complete(Hyp) :-
    not(ex(P),
        once(prove(P, Hyp, Answ)),
        Answ \== yes).

eval(Hyp, Cost) :-
    size(Hyp, S),
    covers_neg(Hyp, N),
    (N = 0, !, Cost is 0;
    Cost is S + 10*N).

size([],0).
size([Cs0/Vs0 | RestHyp], Size) :-
    length(Cs0, L0),
    length( Vs0, N0),
    size( RestHyp, SizeRest),
    Size is 10*L0 + N0 + SizeRest.

covers_neg(Hyp, N) :-
    findall(1, (nex(E), once(prove(E, Hyp, Answ)), Answ \== no), L),
    length(L, N).

unsatisfiable([Head|Body], Hyp) :-
    once(prove(Body, Hyp, Answ)), Answ = no.

start_hyps(Hyps) :-
    max_clauses(M),
    setof(C:H,
        (   
            start_hyp(H,M), add1(generated),
            complete(H), add1(complete), eval(H,C)),
            Hyps
        ).

start_hyp([], _).
start_hyp([C|Cs], M) :-
    M > 0, M1 is M - 1,
    start_clause(C),
    start_hyp(Cs, M1).

refine_hyp(Hyp0, Hyp) :-
    choose_clause(Hyp0, Clause0/Vars0, Clauses1, Clauses2),
    append(Clauses1, [CLause/Vars | Clauses2], Hyp),
    refine(Clauuse0, Vars0, Clause, Vars),
    non_redundant(Clause),
    \+ unsatisfiable(Clause, Hyp).

choose_clause(Hyp, Clause, Clauses1, Clauses2) :-
    append(Clauses1, [Clause | Clauses2], Hyp),
    nex(E),
    prove(E, [Clause], yes),
    !
    ;
    append(Clauses1, [Clause | Clauses2], Hyp).

refine(Clause, Args, Clause, NewArgs) :-
    append(Args1, [A | Args2], Args),
    member(A, Args2),
    append(Args1, Args2, NewArgs).

refine(Clause, Args0, CLause, Args) :-
    delete(Var:Type, Args0, Args1),
    term(Type, Var, Vars),
    append(Args1, Vars, Args).

refine(Clause, Args, NewClause, NewArgs) :-
    length(Clause, L),
    max_clause_lenght(MaxL),
    L < MaxL,
    backliteral(Lit, InArgs, RestArgs),
    append(Clause, [Lit], NewClause),
    connect_inputs(Args, InArgs),
    append(Args, RestArgs, NewArgs).

non_redundant([_]).
non_rendundant([Lit1|Lits]) :-
    \+ literal_member(Lit1, Lits),
    non_redundant(Lits).

literal_member(X, [X1|X2]) :-
    X == X1,!
    ;
    literal_member(X, Xs).

show_hyp([]) :- nl.
show_hyp([C/Vars | Cs]) :- nl,
    copy_term(C/Vars, C1/Vars1),
    name_vars(Vars1, ['A','B','C','D','E','F','G','H','I','J','K','L','M','N']),
    show_clause(C1),
    show_hyp(Cs), !.
show_clause([Head | Body]) :-
    write(Head),
    (Body = [], write(' :- '), nl),
    write_body(Body).
write_body([]) :-
    write('.'), !.
write_body([G|Gs]) :- !,
    tab(2), write(G),
    (
        Gs = [], !, write('.'), nl
        ;
        write(','), nl,
        write_body(Gs)
    ).
name_vars([], _).
name_vars([Name:Type|Xs], [Name|Names]) :-
    name_vars(Xs, Names).
connect_inputs(_, []).
connect_inputs(S, [X|Xs]) :-
    member(X, S),
    connect_inputs(S, Xs).
merge([], L, L) :- !.
merge(L, [], L) :- !.
merge([X1|L1], [X2|L2], [X1|L3]) :-
    X1 @=< X2, !,
    merge(L1, [X2|L2], L3).
merge(L1, [X2|L2], [X2|L3]) :-
    merge(L1, L2, L3).
mergesort([],[]) :- !.
mergesort(L, S) :-
    split(L, L1, L2),
    mergesort(L1, S1),
    mergesort(L2, S2),
    merge(S1, S2, S).

split([],[],[]).
split([X],[X],[]).
split([X1,X2|L], [X1|L1], [X2|L2]) :-
    split(L, L1, L2).

init_counts :-
    retract(counter(_,_)), fail
    ;
    assert(counter(generated, 0)),
    assert(counter(complete, 0)),
    assert(counter(refined, 0)).

add1(Counter) :-
    retract(counter(Counter, N)), !, N1 is N + 1,
    assert(counter(COunter, N1)).

show_counts :-
    counter(generated, NG), counter(refined, NR), counter(complete, NC),
    nl, write('Hypotheses generated: '), write(NG),
    nl, write('Hypotheses refined: '), write(NR),
    ToBeRefined is NC - NR,
    nl, write('To be refined: '), write(ToBeRefined), nl.

max_proof_lenght(6).
max_clauses(4).
max_clause_lenght(5).


