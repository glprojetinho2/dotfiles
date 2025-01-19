#!/bin/fish
function exemplos -d "Retorna exemplos do padrão num livro"
    set -l IFS
    set resultado (grep --color=always -C1 -iE "$argv[1]" "$LIVRO")
    echo $resultado | aha | wl-copy -t text/html
    echo $resultado
end
