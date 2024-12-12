fetch_cfg () {
	file=$1
	path_to_copy_to=$2
  ln -srf $file $path_to_copy_to
}

# configura o vim
fetch_cfg .vimrc $HOME/.vimrc

# configura o i3wm
fetch_cfg i3wm/config $HOME/.i3/config

# configura o sway
fetch_cfg sway/config $HOME/.sway/config

# configura a lock screen
mkdir -p $HOME/.config/swaylock
fetch_cfg swaylock/config.idle $HOME/.config/swaylock/config.idle
fetch_cfg lock.png $HOME/lock.png

# configura o wallpaper
fetch_cfg wallpaper.png $HOME/wallpaper.png

#configura o lvim
mkdir -p $HOME/.config/lvim
fetch_cfg lvim/config.lua $HOME/.config/lvim/config.lua

#configura scripts
mkdir $HOME/.config/myscripts
fetch_cfg screen_recorder.sh $HOME/.config/myscripts/screen_recorder.sh
