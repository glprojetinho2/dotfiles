#!/bin/bash

# instala ferramentas do Rust
curl --tlsv1.2 --proto "=https" https://sh.rustup.rs -Ssf | sh -s -- -y
clear

# instala o pipx
yes y | sudo pacman -S --needed python-pip python python-pipx
python3 -m pipx ensurepath
clear

# alguns programas essenciais
yes y | yay -S --needed anki-bin librewolf-bin syncthing ripgrep alacritty
pipx install jrnl
cargo install tealdeer
clear

# configura o i3wm
curl --tlsv1.2 --proto "=https" https://raw.githubusercontent.com/glprojetinho2/dotfiles/main/i3wm/config -Ssf > $HOME/.i3/config

export NERD_FONT_NAME=0xProto
# instala o lvim
curl --tlsv1.2 --proto "=https" https://raw.githubusercontent.com/glprojetinho2/dotfiles/main/lvim/arch_install.sh -Ssf | sh
