#!/bin/fish
function exemplos -d "Retorna exemplos do padrão num livro"
    set -l IFS
    set resultado (rg --color=always -C1 "$argv[1]")
    echo $resultado | aha | wl-copy -t text/html
    echo $resultado
end
