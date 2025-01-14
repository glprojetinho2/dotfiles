function pyt
    pipe-viewer --res=720p --append-args='--no-config --script-opts=ytdl_hook-ytdl_path=yt-dlp --msg-level=all=no,ytdl_hook=trace' $argv
end
