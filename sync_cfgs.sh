fetch_cfg () {
	file=$1
	path_to_copy_to=$2
  mkdir -p "$(dirname ${path_to_copy_to})"
  ln -srf $file $path_to_copy_to
}

# configura o vim
fetch_cfg .vimrc $HOME/.vimrc
vim_clip=~/.vim/pack/vim-wayland-clipboard/start/vim-wayland-clipboard

if [ ! -d $vim_clip ]; then
  mkdir -p ~/.vim/pack/vim-wayland-clipboard/start/ # habilita o "+
  git clone https://github.com/jasonccox/vim-wayland-clipboard.git $vim_clip
fi

# configura o i3wm
fetch_cfg i3wm/config $HOME/.i3/config

# configura o sway
fetch_cfg sway $HOME/.sway

# configura o alacritty (terminal)
fetch_cfg alacritty.toml $HOME/.config/alacritty/alacritty.toml

# configura o waybar
fetch_cfg waybar/config.jsonc $HOME/.config/waybar/config
fetch_cfg waybar/style.css $HOME/.config/waybar/style.css

# configura a lock screen
fetch_cfg swaylock/config.idle $HOME/.config/swaylock/config.idle
fetch_cfg lock.png $HOME/lock.png

# configura o wallpaper
fetch_cfg wallpaper.png $HOME/wallpaper.png

# configura o helix
fetch_cfg helix/config.toml $HOME/.config/helix/config.toml

# configura scripts
fetch_cfg scripts/screen_recorder.sh $HOME/.config/myscripts/screen_recorder.sh

# configura o starship
fetch_cfg starship/config.toml $HOME/.config/starship.toml

# configura o fish
fetch_cfg fish/config.fish $HOME/.config/fish/config.fish

# configura o qutebrowser
rm -rf ~/.config/qutebrowser
ln -srf qutebrowser $HOME/.config/qutebrowser 
xdg-settings set default-web-browser org.qutebrowser.qutebrowser.desktop

ln -srf qutebrowser/quickmarks qutebrowser-for-shitty-websites/quickmarks
ln -srf qutebrowser/bookmarks qutebrowser-for-shitty-websites/bookmarks
mkdir -p $HOME/.config/qutebrowser-for-shitty-websites
ln -srf qutebrowser-for-shitty-websites $HOME/.config/qutebrowser-for-shitty-websites/config
