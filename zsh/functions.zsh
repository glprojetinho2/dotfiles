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

function esconder() {
   local exata=0
   for arg in "$@"; do
    if [[ "$arg" == "-e" || "$arg" == "--exata" ]]; then
      exata=1
      break
    fi
  done
  if [ "$exata" -eq 0 ]; then
    padrao="(\b$1[A-Za-zÀ-ÖØ-öø-ÿ]*)"
  else
    padrao="($1)"
  fi
  resultado="$(wl-paste | perl -pe "s/$padrao/<span class=\"esconder\" texto=\"\$1\">_<\/span>/g" | perl -pe 's/\n+/<br>/g' | perl -pe 's/<br>$//g')"
  echo $resultado | wl-copy
  echo $resultado 
}
