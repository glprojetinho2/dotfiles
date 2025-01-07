#!/bin/bash
copy_cmd='xclip -sel c'
palavra=$(echo "$1" | iconv -f utf8 -t ascii//TRANSLIT)
padrao_regex=$2
caminho_livro=$LIVRO
if [ "$caminho_livro" = "" ]; then
    echo "Esqueceste do \$LIVRO"
    exit 1
fi
if [ "$palavra" = "" ]; then
  exit 1
fi
if [ "$padrao_regex" = "" ]; then
  padrao_regex=$(echo "\b$1")
fi
pagina=$(curl -sSf "https://www.dicio.com.br/$palavra/")
definicao=$(echo "$pagina" | pup '.significado' | sed 's/span/div/g' > file.html && links -dump file.html)
exemplos=$(grep --color=always -C1 -m 12 -iE "$padrao_regex" "$caminho_livro")

resposta_raw=$(echo -e "$definicao\n\nEXEMPLOS:\n\n$exemplos")
resposta=$( echo "$resposta_raw"| aha)
eval 'echo "$resposta" | $copy_cmd'
echo "$resposta_raw"
