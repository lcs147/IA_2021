import nltk
import uol_redacoes_xml
nltk.download('punkt')

out = open("data/textos/textos.txt", "w")
num_redacoes = 3

essays = uol_redacoes_xml.load()[0:num_redacoes]
total = len(essays)
stotal = str(total)
print("Quantidade de redacoes: " + stotal)

for essay in essays:
	print(essay.text, file=out)

out.close()