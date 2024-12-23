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
paru -S --needed --noconfirm python-pip python python-pipx anki-bin librewolf-bin syncthing ripgrep alacritty lldb rustup git-credential-oauth pipewire pipewire-pulse pwvucontrol lazygit tealdeer kdotool nemo wmenu polkit sway jq swaylock-effects-git grim slurp zoxide blesh fish fisher || { echo "falha ao instalar pacotes essenciais"; exit 1; }
pipx install jrnl
tldr --update
rustup default stable
rustup component add rust-src rust-analyzer

# instala o silver
cargo install --git https://github.com/reujab/silver

# inicializa o git credential oauth
git-credential-oauth configure
git config --global --unset-all credential.helper
git config --global --add credential.helper "cache --timeout 21600" # seis horas
git config --global --add credential.helper oauth

# atualiza db de informações sobre comandos
sudo mandb

append_to_rc () {
  grep "$1" ~/.bashrc || echo "$1" >> ~/.bashrc
}
# ativa numlock ao iniciar shell
append_to_rc "export EDITOR=vim"
append_to_rc 'export PATH="$HOME/.local/share/nvim/mason/bin/:$PATH"' 
append_to_rc 'eval "$(zoxide init bash)"'


# ativa numlock ao iniciar shell
append_to_rc "export EDITOR=vim"
append_to_rc 'export PATH="$HOME/.local/share/lvim/mason/bin/:$PATH"' 

# sincroniza configs
./sync_cfgs.sh

export NERD_FONT_NAME=0xProto
# instala o lvim caso já não esteja instalado
lvim -v || ./lvim/arch_install.sh || { echo "falha ao instalar lvim"; exit 1; }

librewolf --setDefaultBrowser
