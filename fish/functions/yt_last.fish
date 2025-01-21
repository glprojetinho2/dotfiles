function yt_last --wraps='echo "https://www.youtube.com/watch?v=$(cat ~/.config/pipe-viewer/watched.txt | tail -n1)" | wl-copy' --description 'alias yt_last=echo "https://www.youtube.com/watch?v=$(cat ~/.config/pipe-viewer/watched.txt | tail -n1)" | wl-copy'
  echo "https://www.youtube.com/watch?v=$(cat ~/.config/pipe-viewer/watched.txt | tail -n1)" | wl-copy $argv
        
end
