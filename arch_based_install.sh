#!/bin/bash

# previne erro de chave PGP
sudo pacman -S --needed --noconfirm archlinux-keyring || { echo "falha ao instalar archlinux-keyring"; exit 1; }

sudo pacman -Syu --noconfirm || { echo "falha ao fazer update"; exit 1; }

# instala o gvim com `yes y`
yes y | LANG="en_US.UTF-8" sudo pacman -S --needed gvim || { echo "falha ao instalar gvim"; exit 1; }

# instala pacotes com o pacman
sudo pacman -S --needed --noconfirm base-devel || { echo "falha ao instalar pacotes com o pacman"; exit 1; }
python3 -m pipx ensurepath

# instala o paru
mkdir Programas
cd Programas
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si

# alguns programas essenciais
paru -S --needed --noconfirm python-pip python python-pipx anki-bin librewolf-bin syncthing ripgrep alacritty lldb rustup git-credential-oauth pipewire pipewire-pulse pwvucontrol lazygit tealdeer kdotool nemo wmenu polkit sway jq swaylock-effects-git grim slurp || { echo "falha ao instalar pacotes essenciais"; exit 1; }
pipx install jrnl
tldr --update
rustup default stable
rustup component add rust-src rust-analyzer

# inicializa o git credential oauth
git-credential-oauth configure
git config --global --unset-all credential.helper
git config --global --add credential.helper "cache --timeout 21600" # seis horas
git config --global --add credential.helper oauth

# atualiza db de informações sobre comandos
sudo mandb

fn append_to_rc(){
  grep $1 .bashrc || echo $1 >> .bashrc
}
# ativa numlock ao iniciar shell
append_to_rc "export EDITOR=vim"
append_to_rc 'export PATH="$HOME/.local/share/nvim/mason/bin/:$PATH"' 

fetch_cfg () {
	file=$1
	path_to_copy_to=$2
  ln -srf $file $path_to_copy_to
}

append_to_rc () {
  grep "$1" ~/.bashrc || echo "$1" >> ~/.bashrc
}

# ativa numlock ao iniciar shell
append_to_rc "export EDITOR=vim"
append_to_rc 'export PATH="$HOME/.local/share/lvim/mason/bin/:$PATH"' 

# configura o vim
fetch_cfg .vimrc $HOME/.vimrc

# configura o i3wm
fetch_cfg i3wm/config $HOME/.i3/config

# configura o sway
fetch_cfg sway/config $HOME/.sway/config

# configura a lock screen
mkdir -p $HOME/.config/swaylock
fetch_cfg swaylock/config.idle $HOME/.config/swaylock/config.idle
fetch_cfg lock.png $HOME/lock.png

# configura o wallpaper
fetch_cfg wallpaper.png $HOME/wallpaper.png

export NERD_FONT_NAME=0xProto
# instala o lvim caso já não esteja instalado
lvim -v || ./lvim/arch_install.sh || { echo "falha ao instalar lvim"; exit 1; }

#configura o lvim
mkdir -p $HOME/.config/lvim
fetch_cfg lvim/config.lua $HOME/.config/lvim/config.lua

#configura scripts
mkdir $HOME/.config/myscripts
fetch_cfg screen_recorder.sh $HOME/.config/myscripts/screen_recorder.sh

librewolf --setDefaultBrowser
