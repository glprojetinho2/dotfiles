function pipe_img_copy
while read -l line
wl-copy < $line 
end
end
