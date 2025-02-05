#!/bin/zsh
# turn into rust
COINMARKETCAP_API_KEY="$(cat ~/.coinmarketcap)"
coin_output="$(waybar-crypto)"
main_text="$(echo "$coin_output" | jq -r '.text' | cut -d' ' -f1-2)"
tooltip_info="$(echo "$coin_output" | jq -r '.text' | cut -d' ' -f3-)"
echo "{\"text\": \"$main_text\", \"tooltip\": \"$tooltip_info\", \"class\": \"crypto\"}"
