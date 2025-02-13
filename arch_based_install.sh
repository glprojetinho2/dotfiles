#!/bin/sh

# sincroniza configs
./sync_cfgs.sh fjkdsajl

# previne erro de chave PGP
if ! sudo pacman -S --needed archlinux-keyring; then
    echo "falha ao instalar archlinux-keyring"
    exit 1
fi

if ! sudo pacman -Syu; then
    echo "falha ao fazer update"
    exit 1
fi

# instala o gvim com `yes y`
if ! yes y | LANG="en_US.UTF-8" sudo pacman -S --needed gvim; then
    echo "falha ao instalar gvim"
    exit 1
fi

# instala pacotes com o pacman
if ! sudo pacman -S --needed base-devel; then
    echo "falha ao instalar pacotes com o pacman"
    exit 1
fi

# instala o paru
mkdir /tmp/prog
cd /tmp/prog
paru --version || eval "git clone https://aur.archlinux.org/paru.git && cd paru && makepkg -si"

# alguns programas essenciais
if ! paru -S --needed \
        wikiman archwiki-offline socat wf-recorder \
        rofi-wayland python-pip python python-pipx \
        anki-bin syncthing ripgrep alacritty \
        lldb rustup lazygit waybar-crypto \
        tealdeer yazi polkit waybar tiny \
        jq yq wl-clipboard waylock grim slurp \
        zoxide qutebrowser zsh tgpt \
        helix ueberzugpp wlopm pinta swayidle \
        aha fastfetch qt5-wayland urlview arti \
        keepassxc antigen waybar-updates river     
        then
    echo "falha ao instalar pacotes"
    exit 1
fi

python3 -m pipx ensurepath

jrnl -v || pipx install jrnl
tldr --update
rustup default stable
rustup component add rust-src rust-analyzer

# atualiza db de informações sobre comandos
sudo mandb

# configura as fontes no alacritty
NERD_FONT_NAME=0xProto

function setup_nerd_font_in_alacritty() {
  
    mkdir -p $HOME/.config/alacritty
    family="$(fc-list : family | grep $NERD_FONT_NAME | sort -n | head -n1)"
    config="$HOME/.config/alacritty/alacritty.toml"
    touch $config
    cat << EOF | python3
import toml
config = toml.load('$config')
config.update(
{
  'font': {
    'size': 8,
    'bold': {
      'family': '$family',
      'style': 'Bold'
    },
    'bold_italic': {
      'family': '$family',
      'style': 'Bold Italic'
    },
    'italic': {
      'family': '$family',
      'style': 'Italic'
    },
    'normal': {
      'family': '$family',
      'style': 'Regular'
    }
  },
  'selection': {
    'save_to_clipboard': True
  }
}
)
with open('$config', 'w') as f:
    print(toml.dump(config, f))
toml.dump
EOF
    echo sucesso
}
setup_nerd_font_in_alacritty
getnf -i $NERD_FONT_NAME
