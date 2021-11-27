
%knowledgebase
backliteral(parent(X, Y), [X, Y]).
backliteral(male(X), [X]).
backliteral(female(X), [X]).

prolog_predicate(parent(_,_)).
prolog_predicate(male(_)).
prolog_predicate(female(_)).

parent(pam, bob).
parent(tom, bob).
parent(tom, liz).
parent(bob, ann).
parent(bob, pat).
parent(pat, jim).
parent(pat, eve).

female(pam).
female(liz).
female(ann).
female(pat).
female(eve).
male(tom).
male(bob).
male(jim).

ex(has_daughter(tom)).
ex(has_daughter(bob)).
ex(has_daughter(pat)).

nex(has_daughter(pam)).
nex(has_daughter(jim)).

start_hyp([[has_daughter(X)]/[X]]).