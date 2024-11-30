#!/bin/bash

function setup_nerd_font_in_alacritty() {
  mkdir -p $HOME/.config/alacritty
  family=$(fc-list : family | grep $NERD_FONT_NAME | sort -n | head -n1)
  echo -e "[font]\nsize = 10.0\n\n[font.bold]\nfamily = \"$family\"\nstyle = \"Bold\"\n\n[font.bold_italic]\nfamily = \"$family\"\nstyle = \"Bold Italic\"\n\n[font.italic]\nfamily = \"$family\"\nstyle = \"Italic\"\n\n[font.normal]\nfamily = \"$family\"\nstyle = \"Regular\"\n" >> $HOME/.config/alacritty/alacritty.toml
  echo sucesso
}
setup_nerd_font_in_alacritty
clear

if [[ -z "$NERD_FONT_NAME" ]]
  then 
    echo "Execute com o NERD_FONT_NAME definido:
export NERD_FONT_NAME=0xProto"
    exit 1
fi
echo $HOME 
cd $HOME 
yes y | yay -S unzip getnf alacritty neovim
clear
getnf -i $NERD_FONT_NAME

clear
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

clear
echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.bashrc 
export PATH=$HOME/.local/bin:$PATH 
bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/uninstall.sh) 
yes y | bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)
