#!/bin/sh

coin_output="$(echo "{\"text\": \"\ued0a \$221.42 24h:-0.91% 1h:0.97%\", \"tooltip\": \"\", \"class\": \"crypto\"}")"
main_text="$(echo "$coin_output" | jq -r '.text' | cut -d' ' -f1-2)"
tooltip_info="$(echo "$coin_output" | jq -r '.text' | cut -d' ' -f3-)"
echo "{\"text\": \"$main_text\", \"tooltip\": \"$tooltip_info\", \"class\": \"crypto\"}"
