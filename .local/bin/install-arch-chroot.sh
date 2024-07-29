#!/bin/sh

echo ":: Setting timezone"
ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
hwclock --systohc

echo ":: Setting locale"
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo """
export LANG=\"en_US.UTF-8\"
export LC_COLLATE=\"C\"
""" > /etc/locale.conf

echo ":: Installing GRUB"
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
grub-mkconfig -o /boot/grub/grub.cfg

echo ":: Change Root Password"
passwd

printf ":: Enter a new username: "
read user
useradd -m -G wheel -s /bin/bash $user
passwd $user

echo ":: Setting up network"
echo """
127.0.0.1        localhost
::1              localhost
127.0.1.1        myhostname.localdomain  myhostname
""" > /etc/hosts

printf ":: Enter a hostname: "
read hostname

echo ":: Setting hostname"
echo "$hostname" > /etc/conf.d/hostname
echo "$hostname" > /etc/hostname

echo ":: Enabling services"
systemctl enable NetworkManager

echo "Finished !"
