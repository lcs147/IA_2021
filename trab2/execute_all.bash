python3 uol_load_essays_bank.py
prolog -s file2strings.pl gramaticaLP.pl adiciona_desconhecidas.pl lexicon.pl
# add_unknow_words('data/textos/textos.txt', 'data/textos/desconhecidas.txt').
# halt.
python3 cria_regras_desconhecidas.py
prolog -s file2strings.pl gramaticaLP.pl adiciona_desconhecidas.pl new_lexicon.pl
# add_unknow_words('data/textos/textos.txt', 'data/textos/desconhecidas2.txt').