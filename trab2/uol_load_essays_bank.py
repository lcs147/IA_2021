import nltk
import uol_redacoes_xml
nltk.download('punkt')

out = open("data/textos/textos.txt", "w")
num_redacoes = 500

essays = uol_redacoes_xml.load()[0:num_redacoes]
total = len(essays)
stotal = str(total)
print("Quantidade de redacoes: " + stotal)

for essay in essays:
	str = ''.join([c for c in essay.text if (c not in "”“–‘’")])
	str = str.replace('(s)','')
	str = str.replace('(a)','')
	str = str.replace(' -',' ')
	str = str.replace(' - ',' ')
	print(str, file=out)

out.close()