#!/bin/bash

fetch_cfg () {
	file=$1
	path_to_copy_to=$2
	rm -rf $path_to_copy_to
  mkdir -p "$(dirname ${path_to_copy_to})"
  ln -srf $file $path_to_copy_to
}

# coloca os scripts no PATH
for file in scripts/*
do
  path=$(realpath $file)
  cmd_name=$(basename $file | sed 's/\.[^.]*$//')
  ln -srf "$path" "$HOME/.local/bin/$cmd_name"
done

# configura o river (window manager)
fetch_cfg river $HOME/.config/river

# configura o alacritty (terminal)
fetch_cfg alacritty $HOME/.config/alacritty

# configura o waybar
fetch_cfg waybar/config.jsonc $HOME/.config/waybar/config
fetch_cfg waybar/style.css $HOME/.config/waybar/style.css

# mostra o preço do monero na waybar
fetch_cfg waybar/waybar-crypto/config.ini $HOME/.config/waybar-crypto/config.ini

# configura as aplicações-padrão
fetch_cfg mimeapps.list ~/.config/mimeapps.list

# configura o helix
fetch_cfg helix $HOME/.config/helix

# configura o todotxt-tui
fetch_cfg todotxt-tui $HOME/.config/todotxt-tui

# configura o keepassxc
./keepass.py

# configura o okular
./okular.py

# configura o starship
fetch_cfg starship/config.toml $HOME/.config/starship.toml

# configura o fish
fetch_cfg zsh $HOME/.config/zsh
fetch_cfg .zshenv $HOME/.zshenv

# configura o fish
fetch_cfg mpv $HOME/.config/mpv

# ricezinho no rofi
fetch_cfg rofi $HOME/.config/rofi

# configura o yazi (explorador de arquivos)
fetch_cfg yazi $HOME/.config/yazi

# deixa o fastfetch mais bonito
fetch_cfg fastfetch $HOME/.config/fastfetch

# configura o qutebrowser
fetch_cfg qutebrowser $HOME/.config/qutebrowser 
xdg-settings set default-web-browser org.qutebrowser.qutebrowser.desktop

fetch_cfg qutebrowser/quickmarks qutebrowser-for-shitty-websites/quickmarks
fetch_cfg qutebrowser/bookmarks qutebrowser-for-shitty-websites/bookmarks
fetch_cfg qutebrowser-for-shitty-websites $HOME/.config/qutebrowser-for-shitty-websites/config

# configura os executáveis
ln -srf bin/* $HOME/.local/bin/

if [ ! -z $1 ]; then
	# configura aplicações
	sudo ln -srf applications/*.desktop /usr/share/applications/
	xdg-icon-resource install --size 128 ./applications/*.png
	xdg-icon-resource install --size 128 ./applications/*.jpg
fi
