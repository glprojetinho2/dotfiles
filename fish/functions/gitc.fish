function gitc --wraps='git clone $(wl-paste)' --description 'alias gitc=git clone $(wl-paste)'
  git clone $(wl-paste) $argv
        
end
