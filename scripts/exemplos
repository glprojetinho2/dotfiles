#!/bin/bash
resultado=$(grep --color=always -C1 -iE "$1" "$LIVRO")
echo "$resultado" | aha | xclip -sel c
echo "$resultado"
