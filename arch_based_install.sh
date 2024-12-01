#!/bin/bash

# previne erro de chave PGP
pacman -S --needed archlinux-keyring

# instala o pipx
yes y | sudo pacman -S --needed python-pip python python-pipx
python3 -m pipx ensurepath
clear

# alguns programas essenciais
yes y | yay -S --needed anki-bin librewolf-bin syncthing ripgrep alacritty lldb rustup git-credential-oauth 
pipx install jrnl
rustup default stable
cargo install tealdeer
clear

# inicializa o git credential oauth
git-credential-oauth configure
git config --global --unset-all credential.helper
git config --global --add credential.helper "cache --timeout 21600" # seis horas
git config --global --add credential.helper oauth

# ativa numlock ao iniciar o PC
sed '2s/.*/numlockx \&/' -i $HOME/.bash_profile

# configura o i3wm
curl --tlsv1.3 --proto "=https" https://raw.githubusercontent.com/glprojetinho2/dotfiles/main/i3wm/config -Ssf > $HOME/.i3/config

export NERD_FONT_NAME=0xProto
# instala o lvim
curl --tlsv1.3 --proto "=https" https://raw.githubusercontent.com/glprojetinho2/dotfiles/main/lvim/arch_install.sh -Ssf | sh

#configura o lvim
mkdir -p $HOME/.config/lvim
curl --tlsv1.3 --proto "=https" https://raw.githubusercontent.com/glprojetinho2/dotfiles/main/lvim/config.lua -Ssf > $HOME/.config/lvim/config.lua

librewolf --setDefaultBrowser
