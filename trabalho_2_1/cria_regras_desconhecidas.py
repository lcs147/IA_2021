import json
import pprint
import spacy
nlp = spacy.load("pt_core_news_sm")

def print2(x):
    pprint.pprint(x)

file = open("data/textos/desconhecidas.txt", "r")
desconhecidas = set()
for line in file:
    word = line.replace('\n', '')
    desconhecidas.add(word)
file.close()

def converte(x):
    mapa = {'NOUN':'substantivo',
            'PROPN':'substantivo',
            'ADJ':'adjetivo',
            'VERB':'verbo',
            'ADV':'adverbio',
            'DET':'pronome',
            'ADP':'preposicao',
            'SCONJ':'conjuncao',
            'CCONJ':'conjuncao',
            'AUX':'verbo',
            'PRON':'pronome',
            'PUNCT':'pontuacao',
            'NUM':'numeral',
            'SYM':"simbolo",
            'X':'outro',
            'PART':'adverbio'}
    if x in mapa:
        return mapa[x]

    print("ta sem o:", x)
    return mapa[-1]

banco_linhas = []
def adiciona_ao_banco(word, classe, genero, numero):
    ret = "???"
    if(classe == 'substantivo'):
        if(genero == None):
            genero = 'masculino'
        ret = "substantivo({}, {}) --> ['{}'].".format(numero, genero, word)
    elif(classe == 'conjuncao'):
        ret = "conjuncao --> ['{}'].".format(word)
    elif(classe == 'numeral'):
        if(numero == None):
            numero = 'singular'
        if(genero == None):
            ret = "numeral({}) --> ['{}'].".format(numero, word)
        else:
            ret = "numeral({}, {}) --> ['{}']".format(numero, genero, word)
    elif(classe == 'adjetivo'):
        ret = "adjetivo({}, {})--> ['{}'].".format(numero, genero, word)
    elif(classe == 'artigo'):
        ret = "artigo({}, {}) --> ['{}'].".format(numero, genero, word)
    elif(classe == 'pronome'):
        if(genero == None):
            if(numero == None):
                numero = 'singular'
            ret = "pronome({}) --> ['{}'].".format(numero, word)
        else:
            if(numero == None):
                if(word[-1] == 's'):
                    numero = 'plural'
                else:
                    numero = 'singular'
            ret = "pronome({},{}) --> ['{}'].".format(numero, genero, word)
    elif(classe == 'verbo'):
        if(numero == None):
            numero = 'singular'
        ret = "verbo({}) --> ['{}'].".format(numero, word)
    elif(classe == 'adjetivo'):
        ret = "adjetivo({},{}) --> ['{}'].".format(numero, genero, word)
    elif(classe == 'preposicao'):
        if(genero == None):
            genero = 'neutro'
        if(numero == None):
            numero = 'singular'
        ret = "preposicao({},{}) --> ['{}'].".format(numero, genero, word)
    elif(classe == 'interjeicao'):
        if(genero == None):
            ret = "interjeicao({}) --> ['{}'].".format(numero, genero, word)
        else:
            ret = "interjeicao({}, {}) --> ['{}'].".format(numero, genero, word)
    elif(classe == 'adverbio'):
        if(genero == None):
            genero = 'neutro'
        if(numero == None):
            numero = 'singular'
        ret = "adverbio({},{}) --> ['{}'].".format(numero, genero, word)
    elif(classe == 'pontuacao'):
        ret = ''
    elif(classe == 'simbolo' or classe == 'outro'):
        ret = "substantivo(singular, masculino) --> ['{}'].".format(word)
    if(ret == "???"):
        print("what?")
        print(word, classe, genero, numero)
        print(numero[-1])
    banco_linhas.append(ret)
    return True

file = open("data/textos/textos.txt", "r")
for line in file:
    doc = nlp(line)
    for w in doc:
        word = w.text
        if(word in desconhecidas):
            desconhecidas.remove(word)
            
            classe = converte(w.pos_)

            genero = None
            if("Gender=Fem" in w.morph):
                genero = "femenino"
            elif("Gender=Masc" in w.morph):
                genero = "masculino"

            numero = None
            if("Number=Sing" in w.morph):
                numero = "singular"
            elif("Number=Plur" in w.morph):
                numero = "plural"
            
            adiciona_ao_banco(word, classe, genero, numero)
file.close()

for linha in banco_linhas:
    # print(linha)
    if("None" in linha):
        print("Bugado:", linha)
        file[-1] = 0

print(len(banco_linhas), "novas regras")

with open("lexicon.pl", "r") as old_banco:
    for line in old_banco:
        banco_linhas.append(line)

print(len(banco_linhas), "regras no total")
banco_linhas = list(set(banco_linhas))
banco_linhas.sort()
with open("new_lexicon.pl", "w") as new_banco:
    for linha in banco_linhas:
        print(linha, file=new_banco)
    print("salvo em new_lexicon.pl!")
    