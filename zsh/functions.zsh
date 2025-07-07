french()
{
  word=$1
  page="$(curl -sSf "https://fr.wiktionary.org/wiki/$word" | paste -s -d ' ' | perl -pe 's/.+?<h2 id="Français">/<html><body><div><h2 id="Français">/' | sed 's:\\:\\\\:g' | sed 's-"//-"https://-g' | perl -pe 's/\s+/ /g' | perl -pe 's:<a .+?>::g' | perl -pe 's:</a>::g' | perl -pe 's:<b( .+?>|>)([^<]+?)</b>:<a href="${2}">_</a>:g')"
  echo "$page" | pup '.API text{}' > /tmp/french_ipa
  pronunciation="$(echo "$page" | pup "source attr{src}" | grep -P '%28fra%29' | head -n1 | sed 's/^/https:/')"
  echo -e "$(cat /tmp/french_ipa)\n$pronunciation" | wl-copy
  echo "$page" > /tmp/french.html
  cat /tmp/french_ipa | sort | uniq
  echo "$pronunciation"
}

russian()
{
  word=$1
  page="$(curl -sSf "https://ru.wiktionary.org/wiki/$word" | paste -s -d ' ' | perl -pe 's/.+?<h1 id="Русский">/<html><body><div><h1 id="Русский">/' | sed 's:\\:\\\\:g')"
  echo "$page" | pup '.IPA text{}' | sed -e 's/^/[/g' -e 's/$/]/g' | xargs > /tmp/russian_ipa
  pronunciation="$(echo "$page" | pup "source attr{src}" | grep -P '/Ru-' | head -n1 | sed 's/^/https:/')"
  echo "$page" | sed 's-"//-"https://-g' | perl -pe 's/\s+/ /g' | perl -pe 's:<a .+?>::g' | perl -pe 's:</a>::g' | perl -pe 's:<b( .+?>|>)([^<]+?)</b>:<a href="${2}">_</a>:g' > /tmp/russian.html
  echo -e "$(cat /tmp/russian_ipa)\n$pronunciation" | wl-copy 
  cat /tmp/russian_ipa
  echo "$pronunciation"
}

y()
{
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

toggle_border()
{
    if [[ "$_border" == "1" ]]; then
        _border=0
        riverctl border-color-focused 0xffffff
    else 
        _border=1
        riverctl border-color-focused 0x000000
    fi
    
}

esconder()
{
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
  resultado="$(wl-paste | perl -pe "s/$padrao/<span class=\"esconder\" texto=\"\$1\">_<\/span>/gi" | perl -pe 's/\n+/<br>/g' | perl -pe 's/<br>$//g')"
  echo $resultado | wl-copy
  echo $resultado 
}
