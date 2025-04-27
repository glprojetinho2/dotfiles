#!/bin/sh
padrao_regex="$1"
caminho_livro="$LIVRO"
if [[ -z "$caminho_livro" ]]; then
  exemplos="$(rg --color=always -C1 "$padrao_regex")"
else
  exemplos="$(grep --color=always -C1 -m 12 -iE "$padrao_regex" "$caminho_livro")"
fi
echo "$exemplos" | aha | wl-copy -t text/html
echo "$exemplos"
