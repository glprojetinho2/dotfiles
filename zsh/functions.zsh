function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

toggle_border() {
    if [[ "$_border" == "1" ]]; then
        _border=0
        riverctl border-color-focused 0xffffff
    else 
        _border=1
        riverctl border-color-focused 0x000000
    fi
    
}

