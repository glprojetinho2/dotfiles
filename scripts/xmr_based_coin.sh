#!/bin/zsh
coin_output="$(COINMARKETCAP_API_KEY="$(cat ~/.coinmarketcap)" waybar-crypto)"
text="$(echo "$coin_output" | jq -r '.text')"
coins=(${(s/ | /)text})
waybar_text=()
waybar_tooltip=()
for coin in $coins; do
  icon="$(echo $coin | cut -d' ' -f1 | sed 's/^[ \t]*//;s/[ \t]*$//')"
  icon=" <span size='xx-large'>$icon</span> "
  waybar_text+=("$icon<span baseline_shift='2pt'>$(echo $coin | cut -d' ' -f2 | sed 's/^[ \t]*//;s/[ \t]*$//')</span>")
  waybar_tooltip+=("$icon$(echo $coin | cut -d' ' -f3- | sed 's/^[ \t]*//;s/[ \t]*$//')")
  
done
echo "{\"text\": \"${(j/ /)waybar_text}\", \"tooltip\": \"${(j/\\n/)waybar_tooltip}\", \"class\": \"crypto\"}"
