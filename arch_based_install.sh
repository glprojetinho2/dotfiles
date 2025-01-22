#!/bin/bash

# sincroniza configs
./sync_cfgs.sh

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
paru --version || eval "git clone https://aur.archlinux.org/paru.git && cd paru && makepkg -si"

sudo pacman -Rs manjaro-i3-settings morc_menu dmenu-manjaro

# alguns programas essenciais
paru -S --needed --noconfirm wikiman archwiki-offline socat yq wf-recorder rofi python-pip python python-pipx python-i3ipc anki-bin syncthing ripgrep swaybg imv alacritty lldb rustup git-credential-oauth pipewire pipewire-pulse pwvucontrol lazygit tealdeer kdotool yazi bat polkit multibg-sway waybar swayfx jq wl-clipboard swaylock grim slurp zoxide fish fisher torbrowser-launcher tor qutebrowser calibre  helix starship glow links pup-bin aha || { echo "falha ao instalar pacotes essenciais"; exit 1; }
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

# configura as fontes no alacritty
export NERD_FONT_NAME=0xProto

function setup_nerd_font_in_alacritty() {
  mkdir -p $HOME/.config/alacritty
  family=$(fc-list : family | grep $NERD_FONT_NAME | sort -n | head -n1)
  config=$HOME/.config/alacritty/alacritty.toml
  touch $config
  python3 <<EOF
import toml
config = toml.load("$config")
config.update(
{
  "font": {
    "size": 8,
    "bold": {
      "family": "$family",
      "style": "Bold"
    },
    "bold_italic": {
      "family": "$family",
      "style": "Bold Italic"
    },
    "italic": {
      "family": "$family",
      "style": "Italic"
    },
    "normal": {
      "family": "$family",
      "style": "Regular"
    }
  },
  "selection": {
    "save_to_clipboard": True
  }
}
)
with open("$config", "w") as f:
    print(toml.dump(config, f))
toml.dump
EOF
  echo sucesso
}
setup_nerd_font_in_alacritty
getnf -i $NERD_FONT_NAME

# configura o TOR
sudo systemctl enable tor.service
sudo systemctl start tor.service
