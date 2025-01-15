function vtex --wraps='latex $argv[1].tex; and xdvi $argv[1].dvi & disown'
    pkill xdvi
    latex *.tex; and xdvi *.dvi
end
