#!/bin/bash
echo $HOME
cd $HOME
sudo apt update && sudo apt -y upgrade && sudo apt install -y wget unzip fontconfig git curl gcc make vim cargo
export NERD_FONT_NAME=BigBlueTerminal
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.0/$NERD_FONT_NAME.zip
mkdir nerd-font
unzip $NERD_FONT_NAME.zip -d nerd-font
mkdir -p ~/.local/share/fonts
mv nerd-font/* ~/.local/share/fonts/
fc-cache -f -v
if fc-list | grep "Nerd"; then echo "OK"; else echo "FONT WAS NOT INSTALLED"; fi

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
rm -rf /opt/nvim
tar -C /opt -xzf nvim-linux64.tar.gz
echo 'export PATH="$PATH:/opt/nvim-linux64/bin"' >> $HOME/.bashrc
source $HOME/.bashrc
# installs NVM (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

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
