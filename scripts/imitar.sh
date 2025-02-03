#!/bin/sh
palavra="$(echo "$1" | iconv -f utf8 -t ascii//TRANSLIT)"
padrao_regex="$2"
caminho_livro="$LIVRO"
if [[ -z "$caminho_livro" ]]; then
	echo "Esqueceste do \$LIVRO"
	exit 1
fi

if [[ -z "$palavra" ]]; then
	echo "O primeiro argumento é uma palavra."
	exit 1
fi

if [[ -z "$padrao_regex" ]]; then
	padrao_regex="$(echo "\b$1")"
fi
pagina="$(curl -sSf "https://www.dicio.com.br/$palavra/")"
definicao="$(
	echo "$pagina" | pup '.significado' | sed 's/span/div/g' >/tmp/file.html && links -dump /tmp/file.html
)"

exemplos="$(grep --color=always -C1 -m 12 -iE "$padrao_regex" "$caminho_livro")"

resposta_raw="$(echo "$definicao\n\n\nEXEMPLOS:\n\n$exemplos\n")"
resposta="$(echo "$resposta_raw\n" | aha)"
echo "$resposta" | wl-copy -t text/html
echo "$resposta_raw"
