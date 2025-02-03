#!/bin/sh
    palavra="$(echo "$1" | iconv -f utf8 -t ascii//TRANSLIT)"
    padrao_regex="$2"
    caminho_livro="$LIVRO"
    if test "$caminho_livro" = ""
    then
    echo "Esqueceste do \$LIVRO"
    return 1
    fi

    if test "$palavra" = ""
        then
        echo "O primeiro argumento é uma palavra."
        return 1
        fi

        if test "$padrao_regex" = ""
            then
            set padrao_regex $(echo "\b$argv[1]")

            fi
            set -l pagina $(curl -sSf "https://www.dicio.com.br/$palavra/")
            set -l definicao $(echo "$pagina" | pup '.significado' | sed 's/span/div/g' > file.html; and links -dump file.html)

            set -l exemplos $(grep --color=always -C1 -m 12 -iE "$padrao_regex" "$caminho_livro")

            set -l resposta_raw $(echo "$definicao\n\n\nEXEMPLOS:\n\n$exemplos\n")
            set -l resposta $( echo "$resposta_raw\n"| aha)
            echo $resposta | wl-copy -t text/html
            echo $resposta_raw
