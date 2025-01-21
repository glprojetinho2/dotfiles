#!/bin/fish
function imitar
    set -l IFS
    set -l palavra $(echo "$argv[1]" | iconv -f utf8 -t ascii//TRANSLIT)
    set -l padrao_regex $argv[2]
    set -l caminho_livro $LIVRO
    if test "$caminho_livro" = ""
        echo "Esqueceste do \$LIVRO"
        return 1
    end
    if test "$palavra" = ""
        echo "O primeiro argumento é uma palavra."
        return 1
    end
    if test "$padrao_regex" = ""
        set padrao_regex $(echo "\b$argv[1]")
    end
    set -l pagina $(curl -sSf "https://www.dicio.com.br/$palavra/")
    set -l definicao $(echo "$pagina" | pup '.significado' | sed 's/span/div/g' > file.html; and links -dump file.html)

    set -l exemplos $(grep --color=always -C1 -m 12 -iE "$padrao_regex" "$caminho_livro")

    set -l resposta_raw $(echo "$definicao\n\n\nEXEMPLOS:\n\n$exemplos\n")
    set -l resposta $( echo "$resposta_raw\n"| aha)
    echo $resposta | wl-copy -t text/html
    echo $resposta_raw
end
