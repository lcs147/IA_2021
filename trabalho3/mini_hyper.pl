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
    iter_deep(Hyp, 0),
    !, show_counts.

iter_deep(Hyp, MaxD) :-
    write('MaxD = '), write(MaxD), nl,
    start_hyp(Hyp0),
    complete(Hyp0),
    depth_first(Hyp0, Hyp, MaxD)
    ;
    NewMaxD is MaxD + 1,
    iter_deep(Hyp, NewMaxD).

depth_first(Hyp, Hyp, _) :-
    consistent(Hyp).

depth_first(Hyp0, Hyp, MaxD0) :-
    MaxD0 > 0,
    MaxD1 is MaxD0 - 1,
    add1(refined),
    refine_hyp(Hyp0, Hyp1),
    add1(generated),
    complete(Hyp1),
    depth_first(Hyp1, Hyp, MaxD1).

not(A,B,C):-
    A,
    B,
    C, !, fail.
not(_,_,_).
complete(Hyp) :-
    not(ex(E),
        once(prove(E, Hyp, Answer)),
        Answer \== yes).

consistent(Hyp) :-
    not(nex(E),
        once(prove(E, Hyp, Answer)),
        Answer \== no).

refine_hyp(Hyp0, Hyp) :-
    append(Clauses1, [Clause0/Vars0 | Clauses2], Hyp0),
    append(Clauses1, [Clause/Vars | Clauses2], Hyp),
    refine(Clause0, Vars0, Clause, Vars).

refine(Clause, Args, Clause, NewArgs) :-
    append(Args1, [A|Args2], Args),
    member(A, Args2),
    append(Args1, Args2, NewArgs).

refine(Clause, Args, NewClause, NewArgs) :-
    length(Clause,L),
    max_clause_lenght(MaxL),
    L < MaxL,
    backliteral(Lit, Vars),
    append(Clause, [Lit], NewClause),
    append(Args, Vars, NewArgs).

max_proof_lenght(6).
max_clause_lenght(3).

init_counts :-
    retract(counter(_,_)), fail
    ;
    assert(counter(generated, 0)),
    assert(counter(refined, 0)).

add1(Counter) :-
    retract(counter(Counter, N)), !,
    N1 is N + 1,
    assert(counter(Counter, N1)).

show_counts :-
    counter(generated, NG), counter(refined, NR),
    nl, write('Hypotheses generated: '), write(NG),
    nl, write('Hypotheses refined: '), write(NR).
