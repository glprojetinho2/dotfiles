#!/bin/sh

# lsblk
# echo "Choose partition"
# read disk
# sudo cryptsetup open "/dev/$disk" drive
folders=(eval echo ($(cat ~/.backup.txt)))
ls $folders


# sudo umount /dev/mapper/drive
# sudo cryptsetup close drive
