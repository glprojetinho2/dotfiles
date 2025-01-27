#!/bin/fish

# sincroniza configs
./sync_cfgs.sh

# previne erro de chave PGP
if not sudo pacman -S --needed --noconfirm archlinux-keyring
    echo "falha ao instalar archlinux-keyring"
    return 1
end


if not sudo pacman -Syu --noconfirm
    echo "falha ao fazer update"
    return 1
end

# instala o gvim com `yes y`
if not yes y | LANG="en_US.UTF-8" sudo pacman -S --needed gvim
    echo "falha ao instalar gvim"
    return 1
end

# instala pacotes com o pacman
if not sudo pacman -S --needed --noconfirm base-devel
    echo "falha ao instalar pacotes com o pacman"
    return 1
end

python3 -m pipx ensurepath

# instala o paru
mkdir /tmp/prog
cd /tmp/prog
paru --version
or eval "git clone https://aur.archlinux.org/paru.git && cd paru && makepkg -si"

set deleted rofi swayfx manjaro-i3-settings morc_menu dmenu-manjaro swaylock yazi-git swaylock-effects-git
for package in $deleted
    if not sudo pacman --noconfirm -Rs $package
        echo "falha ao desinstalar $package com o pacman"
    end
end

# alguns programas essenciais
if not paru -S --needed --noconfirm \
        wikiman archwiki-offline socat wf-recorder \
        rofi-wayland python-pip python python-pipx \
        python-i3ipc anki-bin syncthing ripgrep \
        swaybg imv alacritty lldb rustup \
        pipewire pipewire-pulse pwvucontrol lazygit \
        tealdeer kdotool yazi bat polkit \
        multibg-sway waybar sway \
        jq yq wl-clipboard swaylock grim slurp \
        zoxide fish fisher qutebrowser \
        calibre helix starship \
        glow pup-bin aha fastfetch jqp-bin \
        zenith qt5-wayland umpv urlview arti
    echo "falha ao instalar pacotes"
    return 1
end

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
set NERD_FONT_NAME 0xProto

function setup_nerd_font_in_alacritty
    mkdir -p $HOME/.config/alacritty
    set family $(fc-list : family | grep $NERD_FONT_NAME | sort -n | head -n1)
    set config $HOME/.config/alacritty/alacritty.toml
    touch $config
    echo """
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
"""
    echo sucesso
end
setup_nerd_font_in_alacritty
getnf -i $NERD_FONT_NAME

# configura o TOR
sudo systemctl enable tor.service
sudo systemctl start tor.service
