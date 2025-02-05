#!/bin/bash

fetch_cfg () {
	file=$1
	path_to_copy_to=$2
	rm -rf $path_to_copy_to
  mkdir -p "$(dirname ${path_to_copy_to})"
  ln -srf $file $path_to_copy_to
}

# configura o vim
fetch_cfg .vimrc $HOME/.vimrc
vim_clip=~/.vim/pack/vim-wayland-clipboard/start/vim-wayland-clipboard

if [ ! -d $vim_clip ]; then
  mkdir -p ~/.vim/pack/vim-wayland-clipboard/start/ # habilita o "+
  git clone https://github.com/jasonccox/vim-wayland-clipboard.git $vim_clip
fi

# coloca os scripts no PATH
for file in scripts/*
do
  path=$(realpath $file)
  cmd_name=$(basename $file .sh)
  ln -srf "$path" "$HOME/.local/bin/$cmd_name"
done

# configura o river (window manager)
fetch_cfg river $HOME/.config/river

# configura os papéis de parede
fetch_cfg wallpapers $HOME/.sway/wallpapers

# configura o alacritty (terminal)
fetch_cfg alacritty $HOME/.config/alacritty

# configura o waybar
fetch_cfg waybar/config.jsonc $HOME/.config/waybar/config
fetch_cfg waybar/style.css $HOME/.config/waybar/style.css

# mostra o preço do monero na waybar
fetch_cfg waybar/waybar-crypto/config.ini $HOME/.config/waybar-crypto/config.ini

# configura as aplicações-padrão
fetch_cfg mimeapps.list ~/.config/mimeapps.list

# configura a lock screen
fetch_cfg swaylock/config.idle $HOME/.config/swaylock/config.idle
fetch_cfg lock.png $HOME/lock.png

# configura o wallpaper
fetch_cfg wallpaper.png $HOME/wallpaper.png

# configura o helix
fetch_cfg helix $HOME/.config/helix

# configura scripts
fetch_cfg scripts/screen_recorder.sh $HOME/.config/myscripts/screen_recorder.sh

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
