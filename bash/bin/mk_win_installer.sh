#!/bin/bash
TARGET_DEVICE=$1
SOURCE_ISO_FILE=$2

warn() {
    echo "$1" >&2
}

die() {
    warn "$1"
    exit 1
}
[ -z $1 ] && warn "Usage: mk_win_installer.sh TARGET_DEVICE" && sudo lsblk && die
/home/angus/.bin/mk_bootable_usb.sh $TARGET_DEVICE
#sudo mkfs.ntfs "$TARGET_DEVICE"1

[ -z $2 ] && warn "Usage: mk_win_installer.sh $TARGET_DEVICE SOURCE_ISO_FILE" && sudo ls -l && die
sudo mount -o loop $SOURCE_ISO_FILE /mnt
sudo mkdir /media/temp_mount_point
sudo mount -t ntfs "$TARGET_DEVICE"1 /media/temp_mount_point
sudo rsync -av --progress /mnt/* /media/temp_mount_point/
sudo grub-install --target=i386-pc --boot-directory="/media/temp_mount_point/boot" $TARGET_DEVICE

cat >/media/temp_mount_point/boot/grub/grub.cfg<<START_SHELL
default=1
timeout=15
color_normal=light-cyan/dark-gray
menu_color_normal=black/light-cyan
menu_color_highlight=white/black

menuentry "Start Windows Installation" {
insmod ntfs
insmod search_label
search --no-floppy --set=root --label W7SP20718 --hint hd0,msdos1
ntldr /bootmgr
boot
}

menuentry "Boot from the first hard drive" {
insmod ntfs
insmod chain
insmod part_msdos
insmod part_gpt
set root=(hd1)
chainloader +1
boot
}
START_SHELL


sudo umount /mnt
sudo umount /media/temp_mount_point
sudo rmdir /media/temp_mount_point
