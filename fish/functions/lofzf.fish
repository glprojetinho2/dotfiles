function lofzf --wraps='locate $argv | fzf | wl-copy' --wraps='locate $argv | fzf | wl-copy; and return 0;' --description 'alias lofzf=locate $argv | fzf | wl-copy; and return 0;'
  locate $argv | fzf | wl-copy; and return 0; $argv
        
end
