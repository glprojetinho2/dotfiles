vimb -v || paru -S --needed vimb
cd $HOME/Programas
adblock="/usr/lib/wyebrowser/4.1/adblock.so"
if [ ! -f "$adblock" ]; then
  git clone https://github.com/jun7/wyebadblock
  cd wyebadblock
  WEBKITVER=4.1 make
  sudo WEBKITVER=4.1 make install
fi
mkdir -p $HOME/.config/wyebadblock
curl -Ssf https://easylist.to/easylist/easylist.txt > $HOME/.config/wyebadblock/easylist.txt
sudo ln -sf $adblock $(vimb --bug-info | grep 'Extension dir' | awk '{print $3}')
