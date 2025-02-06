function _current_dir() {
  pwd="$(pwd)"
  if [[ "$pwd" == "$HOME" ]]; then
    echo '~'
  else
    echo "$(basename $pwd)"
  fi
}

function preexec() {
  timer=$(($(date +%s%0N)/1000000))
}

function precmd() {
  if [ $timer ]; then
    now=$(($(date +%s%0N)/1000000))
    elapsed=$(($now-$timer))

    export RPROMPT="${elapsed}ms $?"
    unset timer
  fi
}

setopt PROMPT_SUBST
PROMPT='$(_current_dir) > '
