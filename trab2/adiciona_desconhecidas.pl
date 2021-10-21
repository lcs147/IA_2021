is_known_word(X, R) :-
    artigo(_, _, [X], []), R = [], !;
    artigoCombinacao(_, _, [X], []), R = [], !;
    pronome(_, [X], []), R = [], !;
    pronome(_, _, [X], []), R = [], !;
    substantivo(_, _, [X], []), R = [], !;
    verbo(_, [X], []), R = [], !;
    adjetivo(_, _, [X], []), R = [], !;
    numeral(_, _, [X], []), R = [], !;
    adverbio(_, _, [X], []), R = [], !;
    preposicao(_, _, [X], []), R = [], !;
    conjuncao([X], []), R = [], !;
    interjeicao(_, _, [X], []), R = [], !;
    R = [X], !.

add_unknow_words(FileIn, FileOut) :-
    textFileToListOfString(FileIn, LPhrases),
    find_unknow_words(LPhrases, UnkownWords),
    write_in_file(UnkownWords, FileOut).

find_unknow_words([],[]).
find_unknow_words([H|T], UnkownWords) :-
    is_list(H), find_unknow_words(H, L1), find_unknow_words(T, L2), append(L1, L2, UnkownWords), !;
    \+ is_list(H), is_known_word(H, L1), find_unknow_words(T, L2), append(L1, L2, UnkownWords), !;
    UnkownWords = [], !.

write_in_file(Words, File) :-
    open(File, write, Out),
    write_list(Words, Out),
    close(Out).

write_list([], _).
write_list([H|T], Stream):-
    write(Stream, H),
    write(Stream, '\n'),
    write_list(T, Stream).
