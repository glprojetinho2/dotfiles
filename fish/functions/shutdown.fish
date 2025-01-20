function shutdown --description 'alias shutdown=pkill -f anki; sleep 3; shutdown'
    pkill -f anki
    command shutdown $argv

end
