%*********************************************************************
%*********************************************************************
%	Camila Paixão               									**
%	Felipe Cabral	    										    ** 	
%	Manoel Mota		 												**
% 	Trabalho Final de LFA - dezembro, versao de 2010				** 	 	
%*********************************************************************
%*********************************************************************

% frase(A,[cargo,e,cargos],C,[]).
%false.


%comando para testar se uma frase pertence ao texto
% abrir pelo terminal o diretorio onde esta esse arquivo
% digitar prolog
% para a chamada do arquivo pode ser assim: ['gramatica.pl'].
checa_texto(Texto, ContEncontradas, ContTotal) :-
    textFileToListOfString(Texto, Lfrases),
    cont_frases(Lfrases, ContTotal),
    check_frases(Lfrases, ContEncontradas), !.


cont_frases([], 0).

cont_frases([H|_], ContTotal) :-
    \+ is_list(H),
    ContTotal is 1.

cont_frases([H|T], ContTotal) :-
    is_list(H),
    cont_frases(H, C1),
    cont_frases(T, C2),
    ContTotal is C1 + C2.

check_frases([], 0).

check_frases([H|T], ContEncontradas):-
    \+is_list(H), 
    (
        (
            sentenca(_, _, [H|T], []), !,
            ContEncontradas is 1
        );
        ContEncontradas is 0
    ).

check_frases([H|T], ContEncontradas):-
    is_list(H),
    check_frases(H, C1),
    check_frases(T, C2),
    ContEncontradas is C1 + C2.

% --------------------------------------------------------------------
% Regras lexicais %
sentenca --> sentenca(_, _).
sentenca(Numero,Genero) --> frase(Numero,Genero).
sentenca(Numero,Genero) --> periodoSimples(Numero,Genero).
sentenca(Numero,Genero) --> periodoComposto(Numero,Genero).

periodoSimples(Numero,Genero) --> predicado(Numero,Genero).
periodoSimples(Numero,Genero) --> sujeito(Numero,Genero), predicado(Numero,Genero).

periodoComposto(Numero,Genero) --> oracaoCoordenada(Numero,Genero).
periodoComposto(Numero,Genero) --> oracaoCoordenada(Numero,Genero), sentenca.
periodoComposto(Numero,Genero) --> oracaoCoordenada(Numero,Genero), conjuncao, sentenca.
periodoComposto(Numero,Genero) --> oracaoSubordinada(Numero,Genero).
periodoComposto(Numero,Genero) --> oracaoSubordinada(Numero,Genero), sentenca.
periodoComposto(Numero,Genero) --> oracaoSubordinada(Numero,Genero), preposicao(Numero, Genero),sentenca.
periodoComposto(Numero,Genero) --> oracaoCoordenada(Numero,Genero), conjuncao, oracaoSubordinada(Numero,Genero).
periodoComposto(Numero,Genero) --> oracaoSubordinada(Numero,Genero), conjuncao, oracaoCoordenada(Numero,Genero).

oracaoCoordenada(Numero,Genero) --> predicado(Numero,Genero).
oracaoCoordenada(Numero,Genero) --> sujeito(Numero,Genero), predicado(Numero,Genero).
oracaoSubordinada(Numero,Genero) --> predicado(Numero,Genero).
oracaoSubordinada(Numero,Genero) --> sujeito(Numero,Genero), predicado(Numero,Genero).

%**********************************************************************
frase(Numero,Genero) -->  sujeito(Numero,Genero).
frase(Numero,Genero) -->  artigo(Numero,Genero) , sujeito(Numero,Genero).

sujeito(Numero,Genero) --> pronome(Numero,Genero); pronome(Numero).
sujeito(Numero,Genero) --> substantivo(Numero,Genero).
sujeito(Numero,Genero) --> artigo(Numero,Genero) , substantivo(Numero,Genero), (preposicao(Numero, Genero), preposicao(_, neutro)).
sujeito(Numero,Genero) --> adverbio(Numero,Genero), adjetivo(Numero,Genero).
sujeito(Numero,Genero) --> artigo(Numero,Genero) , substantivo(Numero,Genero).
sujeito(Numero,Genero) --> artigo(Numero,Genero) , substantivo(Numero,Genero), adjetivo(Numero,Genero).
sujeito(Numero,Genero) --> substantivo(Numero,Genero), conjuncao, substantivo(Numero,Genero).

%a liberdade de X
sujeito(Numero,Genero) --> artigo(Numero,Genero), substantivo(Numero,Genero), (preposicao(Numero, Genero); preposicao(_, neutro)), sujeito(_, _).
%liberdade de X

%assim como X
sujeito(Numero,Genero) --> substantivo(Numero,Genero), (preposicao(Numero, Genero); preposicao(_, neutro)), conjuncao, sujeito(_,_).
sujeito(Numero,Genero) --> artigo(Numero,Genero), substantivo(Numero,Genero), sujeito(_, _).
sujeito(Numero,Genero) --> (preposicao(Numero, Genero); preposicao(_, neutro)), substantivo(Numero,Genero).


predicado(Numero,_) --> verbo(Numero).
predicado(Numero,Genero) --> verbo(Numero), substantivo(Numero,Genero).
predicado(Numero,Genero) --> verbo(Numero), substantivo(Numero,Genero), adjetivo(Numero,Genero).
predicado(Numero,Genero) --> verbo(Numero), artigo(Numero,Genero), adjetivo(Numero,Genero).
predicado(Numero,Genero) --> verbo(Numero), artigo(Numero,Genero), substantivo(Numero,Genero).
predicado(Numero,Genero) --> verbo(Numero), artigo(Numero,Genero), substantivo(Numero,Genero), adjetivo(Numero,Genero).
predicado(Numero,Genero) --> verbo(Numero), artigo(Numero,Genero), pronome(Numero,_), substantivo(Numero,Genero), preposicao(Numero, Genero), verbo(Numero,Genero).
predicado(Numero,Genero) --> verbo(Numero), numeral(Numero,Genero), substantivo(Numero,Genero).
predicado(Numero,Genero) --> verbo(Numero), numeral(Numero,Genero), substantivo(Numero,Genero), adjetivo(Numero,Genero).
predicado(Numero,Genero) --> verbo(Numero), preposicao(Numero, Genero), substantivo(Numero,Genero).
predicado(Numero,Genero) --> verbo(Numero), preposicao(Numero, Genero), substantivo(Numero,Genero), preposicao(Numero, Genero), adjetivo(Numero,Genero),substantivo(Numero,Genero).
predicado(Numero,Genero) --> verbo(Numero), preposicao(Numero, Genero), verbo(Numero), adverbio(Numero,Genero), adjetivo(Numero,Genero). 
predicado(Numero,Genero) --> verbo(Numero), substantivo(Numero,Genero), artigo(Numero,Genero), substantivo(Numero,Genero).
predicado(Numero,Genero) --> verbo(Numero), substantivo(Numero,Genero), artigo(Numero,Genero), substantivo(Numero,Genero), adjetivo(Numero,Genero).

%***********************************************************************************
%Estou comprando um protetor solar.
%Irei à praia.

objeto_direto(N) --> substantivo(N).
objeto_direto(N) --> artigo(N), substantivo(N).
objeto_indireto(N) --> preposicao(N), substantivo(N).
% --------------------------------------------------------------------