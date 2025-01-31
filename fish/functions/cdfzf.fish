function cdfzf --wraps='cd $(find . -type d | fzf | xargs realpath)' --description 'alias cdfzf=cd $(find . -type d | fzf | xargs realpath)'
    cd $(dirname (find . | fzf | xargs realpath || pwd)) $argv

end
