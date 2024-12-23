append_to_rc () {
  grep -q -F "$1" ~/.bashrc && echo "'$1' já estava no .bashrc" || echo "$1" >> ~/.bashrc
}

append_to_rc '[[ $- == *i* ]] && source /usr/share/blesh/ble.sh --noattach'
append_to_rc "export EDITOR=vim"
append_to_rc 'export PATH="$HOME/.local/share/nvim/mason/bin/:$PATH"' 
append_to_rc 'eval "$(zoxide init bash)"'
append_to_rc '[[ ${BLE_VERSION-} ]] && ble-attach'
append_to_rc "export EDITOR=vim"
append_to_rc 'export PATH="$HOME/.local/share/lvim/mason/bin/:$PATH"' 
