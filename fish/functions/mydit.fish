function mydit --description 'gets images from reddit'
    # Original script at https://github.com/Bugswriter/redyt
    # Check if necessary programs are installed
    for prog in dmenu jq imv
        test -z "$(which "$prog")"; and echo "Please install $prog!"; and return 1
    end

    # If notify-send is not installed, use echo as notifier
    test -z "$(which notify-send)"; and set notifier echo; or set notifier notify-send
    argparse l/limit= k/keep v/verbose -- $argv
    set -q _flag_limit
    or set _flag_limit 100
    if not string match -qr '^[0-9]+$' -- $_flag_limit
        echo "limit should be an integer"
        return 1
    end

    # Default config directory
    set configdir "$HOME/.config/redyt"
    not test -z $XDG_CONFIG_HOME; and set configdir "$XDG_CONFIG_HOME/.config/redyt"

    # Create .config/redyt if it does not exist to prevent
    # the program from not functioning properly
    if not test -d "$configdir"
        echo "Directory $configdir does not exist, creating..."
        mkdir -p "$configdir"
    end

    # Default subreddit that will be inserted in "subreddit.txt"
    # if it does not exist
    set defaultsub linuxmemes

    # If subreddit.txt does not exist, create it to prevent
    # the program from not functioning properly
    test -f "$configdir/subreddit.txt"; or echo "$defaultsub" >>"$configdir/subreddit.txt"

    # If no argument is passed
    if test -z "$argv"
        # Ask the user to enter a subreddit
        set subreddit (dmenu -p "Select Subreddit r/" -i -l 10 < "$configdir/subreddit.txt" | awk -F "|" '{print $1}')

        # If no subreddit was chosen, exit
        test -z "$subreddit"; and echo "no sub chosen"; and return 1
    else
        set subreddit $argv
    end

    # Default directory used to store the feed file and fetched images
    set cachedir /tmp/redyt

    # If cachedir does not exist, create it
    if not test -d "$cachedir"
        echo "$cachedir does not exist, creating..."
        mkdir -p "$cachedir"
    end

    # Send a notification
    set -q $_flag_verbose; and $notifier Redyt "📩 Downloading your 🖼️ Memes"

    # Download the subreddit feed, containing only the
    # first 100 entries (limit), and store it inside
    # cachedir/tmp.json
    curl -H "User-agent: 'your bot 0.1'" "https://www.reddit.com/r/$subreddit/hot.json?limit=$_flag_limit" >"$cachedir/tmp.json"

    # Create a list of images
    set imgs (jq '.' < "$cachedir/tmp.json" | grep url_overridden_by_dest | grep -Eo "http(s|)://.*(jpg|png)\b" | sort -u)

    # If there are no images, exit
    test -z "$imgs"
    and $notifier Redyt "sadly, there are no images for subreddit $subreddit, please try again later!"
    and return 1

    # Download images to $cachedir
    for img in $imgs
        if not test -e "$cachedir/(basename $img)"
            wget -P "$cachedir" $img
        end
    end

    # Send a notification
    set -q _flag_verbose
    and $notifier Redyt "👍 Download Finished, Enjoy! 😊"

    rm "$cachedir/tmp.json"

    imv "$cachedir" | pipe_img_copy

    # Once finished, remove all of the cached images
    not set -q $_flag_keep
    and test -d $cachedir
    and rm $cachedir/*
end
