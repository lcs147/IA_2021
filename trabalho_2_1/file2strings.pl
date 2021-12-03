%
%   Copyright (C) 2021 Edjard Mota
%   UFAM - IComp
%   Objetivo: ler um arquivo de texto e tranformar cada
%   linha lida em uma lista de listas de frases a serem
%   processdas por uma gramatica.

% Comente ate linha ** para nao exibir todos elementos
% de uma lista
:- set_prolog_flag(answer_write_options,
                   [ quoted(true),
                     portray(true),
                     spacing(next_argument)
                   ]).
% **
/* ------------------------------------------------
   In SWI-Prolog, the cleanest solution is to write 
   a DCG that describes what a "line" is, then call 
   a predicate for each line. Use library(pio) to 
   apply the DCG to a file.
   (Shon, Software Engineer - stackoverflow user)
   Post: https://bit.ly/3B6wU8C
   Answer: 16

*/
:- use_module(library(pio)).

lines([])           --> call(eos), !.
lines([Line|Lines]) --> line(Line), lines(Lines).

eos([], []).

line([])     --> ( "\n" ; call(eos) ), !.
line([L|Ls]) --> [L], line(Ls).
% -------------------------------------------------

textFileToListOfString(File,LPhrases):-
		phrase_from_file(lines(Ls),File),
%		read_lines(Ls,LPhrases).
		read_lines(Ls,Lines),
		line_to_phrases(Lines,LPhrases).

read_lines([],[]).
read_lines([H|T],[Periodo|Linhas]):-
		string_to_list(S,H), 
		split_string(S,".","",Periodo),
		read_lines(T,Linhas).

% -------------------------------------------------

line_to_phrases([],[]).
line_to_phrases([H|L],[PhraseList|LPhrases]):-
    list_phrases(H,PhraseList),
    line_to_phrases(L,LPhrases).

% -------------------------------------------------
list_phrases([],[]).
list_phrases([F|T],[S|R]):-
%    string_codes(F,P),
	atom_codes(F,P),
    \+ P = [], !,
	get_only_words(P,X,X,Words),
	codes_to_string_list(Words,S),
    list_phrases(T,R), !.
list_phrases([_|T],R):-
    list_phrases(T,R).

% -------------------------------------------------
% get a list of valid words from a list
% of ASCII codes
get_only_words([],W,[],[W]):- !.
get_only_words([C|T],W,Wsf,Wds) :-
    valid_char(C),
    Wsf = [C|R],
    get_only_words(T,W,R,Wds),!.
get_only_words([_|T],W,[],[W|Wds]) :-
	is_list(W),
    get_only_words(T,NW,NW,Wds).
get_only_words([_|T],W,W,Wds) :-
    get_only_words(T,W,W,Wds).

% -------------------------------------------------
valid_char(C):-
    C \== 37, % %
    C \== 33, % !
    C \== 39, % aspas simples
    C \== 34, % "
    C \== 63, % interrogação
    C \== 40,  % parenteses
    C \== 41,  % parenteses 2
    C \== 10,  % enter ou return
    C \== 32,  % branco
    C \== 46,  % ponto
    C \== 44,  % virgula
    C \== 58,  % dois pontos
    C \== 59.  % ponto e virgula

codes_to_string_list([],[]).
codes_to_string_list([Codes|T],[W|Words]):-
%    string_codes(W,Codes),
    \+ Codes = [], !,
    atom_codes(W,Codes),
    codes_to_string_list(T,Words),!.
codes_to_string_list([_|T],Words):-
    codes_to_string_list(T,Words).
