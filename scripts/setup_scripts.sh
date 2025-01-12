#!/bin/bash
for file in *
do
  path=$(realpath $file)
  cmd_name=$(basename $file)
  ln -srf "$path" "$HOME/.local/bin/$cmd_name"
done
