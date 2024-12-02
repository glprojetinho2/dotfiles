#!/bin/bash

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

if [[ -z "$NERD_FONT_NAME" ]]
  then 
    echo "Execute com o NERD_FONT_NAME definido:
export NERD_FONT_NAME=0xProto"
    exit 1
fi

echo $HOME 
cd $HOME 
yay -S --needed --noconfirm unzip getnf alacritty neovim python-toml

setup_nerd_font_in_alacritty

getnf -i $NERD_FONT_NAME

# installs NVM (Node Version Manager) 
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash 
export NVM_DIR="$HOME/.nvm" 
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm 
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" 

# download and install Node.js
nvm install 20 

# verifies the right Node.js version is in the environment
node -v # should print `v20.12.1` 

# verifies the right NPM version is in the environment
npm -v # should print `10.5.0` 

echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.bashrc 
export PATH=$HOME/.local/bin:$PATH 
bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/uninstall.sh) 
yes y | bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)
