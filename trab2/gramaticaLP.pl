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

% --------------------------------------------------------------------
% Regras lexicais %
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
frase(Numero,Genero) -->  artigo(Numero,Genero) , sujeito(Numero,Genero).

sujeito(Numero,Genero) --> pronome(Numero,Genero).
sujeito(Numero,Genero) --> substantivo(Numero,Genero).
sujeito(Numero,Genero) --> artigo(Numero,Genero) , substantivo(Numero,Genero), preposicao(Numero, Genero).
sujeito(Numero,Genero) --> adverbio(Numero,Genero), adjetivo(Numero,Genero).
sujeito(Numero,Genero) --> artigo(Numero,Genero) , substantivo(Numero,Genero).
sujeito(Numero,Genero) --> artigo(Numero,Genero) , substantivo(Numero,Genero), adjetivo(Numero,Genero).
sujeito(Numero,Genero) --> substantivo(Numero,Genero) , conjuncao, substantivo(Numero,Genero).

predicado(Numero,Genero) --> verbo(Numero,Genero).
predicado(Numero,Genero) --> verbo(Numero,Genero), substantivo(Numero,Genero).
predicado(Numero,Genero) --> verbo(Numero,Genero), substantivo(Numero,Genero), adjetivo(Numero,Genero).
predicado(Numero,Genero) --> verbo(Numero,Genero), artigo(Numero,Genero), adjetivo(Numero,Genero).
predicado(Numero,Genero) --> verbo(Numero,Genero), artigo(Numero,Genero), substantivo(Numero,Genero).
predicado(Numero,Genero) --> verbo(Numero,Genero), artigo(Numero,Genero), substantivo(Numero,Genero), adjetivo(Numero,Genero).
predicado(Numero,Genero) --> verbo(Numero,Genero), artigo(Numero,Genero), pronome(Numero,_), substantivo(Numero,Genero), preposicao(Numero, Genero), verbo(Numero,Genero).
predicado(Numero,Genero) --> verbo(Numero,Genero), numeral(Numero,Genero), substantivo(Numero,Genero).
predicado(Numero,Genero) --> verbo(Numero,Genero), numeral(Numero,Genero), substantivo(Numero,Genero), adjetivo(Numero,Genero).
predicado(Numero,Genero) --> verbo(Numero,Genero), preposicao(Numero, Genero), substantivo(Numero,Genero).
predicado(Numero,Genero) --> verbo(Numero,Genero), preposicao(Numero, Genero), substantivo(Numero,Genero), preposicao(Numero, Genero), adjetivo(Numero,Genero),substantivo(Numero,Genero).
predicado(Numero,Genero) --> verbo(Numero,Genero), preposicao(Numero, Genero), verbo(Numero,Genero), adverbio(Numero,Genero), adjetivo(Numero,Genero). 
predicado(Numero,Genero) --> verbo(Numero,Genero), substantivo(Numero,Genero), artigo(Numero,Genero), substantivo(Numero,Genero).
predicado(Numero,Genero) --> verbo(Numero,Genero), substantivo(Numero,Genero), artigo(Numero,Genero), substantivo(Numero,Genero), adjetivo(Numero,Genero).

%***********************************************************************************
%Estou comprando um protetor solar.
%Irei à praia.

objeto_direto(N) --> substantivo(N).
objeto_direto(N) --> artigo(N), substantivo(N).
objeto_indireto(N) --> preposicao(N), substantivo(N).
% --------------------------------------------------------------------