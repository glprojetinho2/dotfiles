#!/bin/bash
for file in *.sh
do
  path=$(realpath $file)
  cmd_name=$(basename $file .sh)
  ln -srf "$path" "$HOME/.local/bin/$cmd_name"
done
