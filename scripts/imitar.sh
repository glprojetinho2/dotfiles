#!/bin/sh
palavra="$(echo "$1" | iconv -f utf8 -t ascii//TRANSLIT)"
padrao_regex="$2"
caminho_livro="$LIVRO"
if [[ -z "$palavra" ]]; then
	echo "O primeiro argumento é uma palavra."
	exit 1
fi

if [[ -z "$padrao_regex" ]]; then
	palavra_regex="$1"
	padrao_regex="\b$palavra_regex"
	removido=0
	if [[ ${#padrao_regex} -gt 9 ]]; then
		padrao_regex="\b${palavra_regex%?}\w+"
		removido=1
	elif [[ ${#padrao_regex} -gt 8 ]]; then
		padrao_regex="\b${palavra_regex%??}\w+"
		removido=2
	fi
fi

pagina="$(curl -sSf "https://www.dicio.com.br/$palavra/")"
definicao="$(
	echo "$pagina" | pup '.significado' | sed 's/span/div/g' >/tmp/file.html && links -dump /tmp/file.html
)"

echo "Padrão: $padrao_regex"
if [[ -z "$caminho_livro" ]]; then
  exemplos="$(rg --color=always -C1 "$padrao_regex")"
else
  exemplos="$(grep --color=always -C1 -m 12 -iE "$padrao_regex" "$caminho_livro")"
fi
if [[ -z "$exemplos" ]] && ! [[ -z "$palavra_regex" ]]; then
	if [[ $removido -eq 0 ]]; then
		padrao_regex="\b${palavra_regex%?}\w+"
	elif [[ $removido -eq 1 ]]; then
		padrao_regex="\b${palavra_regex%??}\w+"
	elif [[ $removido -eq 2 ]]; then
		padrao_regex="\b${palavra_regex%???}\w+"
	fi

	echo "Outro padrão: $padrao_regex"
	if [[ -z "$caminho_livro" ]]; then
	  exemplos="$(rg --color=always -C1 "$padrao_regex")"
	else
	  exemplos="$(grep --color=always -C1 -m 12 -iE "$padrao_regex" "$caminho_livro")"
	fi
fi

resposta_raw="$(echo -e "$definicao\n\n\nEXEMPLOS:\n\n$exemplos\n")"
resposta="$(echo -e "$resposta_raw\n" | aha)"
echo "$resposta" | wl-copy -t text/html
echo "$resposta_raw"
