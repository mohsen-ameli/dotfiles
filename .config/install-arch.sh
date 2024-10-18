#!/bin/sh

if ! ping -c 1 google.com; then
  echo "No internet connection detected ;("
  exit 1
fi

lsblk
echo ""
printf ":: Please specify the drive to use to install Arch Linux on: "
read drive
echo ""
if [ ! -b "$drive" ]; then
  echo "drive doesn't exist"
  exit 1
fi

echo "Selected drive is $drive"
echo ""
echo "Starting partitioning..."
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | sudo fdisk $drive
  o # clear the in memory partition table
  n # new partition
  p # primary partition
  1 # partition number 1
    # default - start at beginning of disk 
  +512M # 100 MB boot parttion
  n # new partition
  p # primary partition
  2 # partion number 2
    # default, start immediately after preceding partition
    # default, extend partition to end of disk
  a # make a partition bootable
  1 # bootable partition is partition 1 -- /dev/sda1
  p # print the in-memory partition table
  w # write the partition table
  q # and we're done
EOF

echo ":: Formatting drives"
mkfs.fat -F 32 $drive"1"
mkfs.ext4 $drive"2"

echo ":: Mounting drives"
mount $drive"2" /mnt
mkdir /mnt/boot
mount $drive"1" /mnt/boot

# Enabling multilib and g14
echo -e """
[multilib]
Include = /etc/pacman.d/mirrorlist

[g14]
Server = https://arch.asus-linux.org
""" | sudo tee /etc/pacman.conf

# Setting mirrorlist to canada
curl "https://archlinux.org/mirrorlist/?country=CA&protocol=http&protocol=https&ip_version=4" | sudo tee /etc/pacman.d/mirrorlist
sudo sed 's/#Server/Server/g' -i /etc/pacman.d/mirrorlist

echo ":: Starting installation"
pacstrap -K /mnt base base-devel linux linux-firmware grub efibootmgr networkmanager vim htop wget terminus-fonts
genfstab -U /mnt >> /mnt/etc/fstab

echo ":: Setting locale"
echo "en_US.UTF-8 UTF-8" >> /mnt/etc/locale.gen
echo """
export LANG=\"en_US.UTF-8\"
export LC_COLLATE=\"C\"
""" > /mnt/etc/locale.conf

printf ":: Enter a hostname: "
read hostname
echo ":: Setting hostname"
echo "$hostname" > /mnt/etc/conf.d/hostname
echo "$hostname" > /mnt/etc/hostname

echo ":: Setting up network"
echo """
127.0.0.1        localhost
::1              localhost
127.0.1.1        $hostname.localdomain  $hostname
""" > /mnt/etc/hosts

cat > /mnt/install-arch-chroot.sh << EOF
#!/bin/sh
locale-gen

echo ":: Setting timezone"
ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
hwclock --systohc

echo ":: Installing GRUB"
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
grub-mkconfig -o /boot/grub/grub.cfg

echo ":: Change Root Password"
passwd

printf ":: Enter a new username: "
read user
useradd -m -G wheel -s /bin/bash "\$user"
passwd "\$user"

echo ":: Enabling services"
systemctl enable NetworkManager

echo "Finished !"
EOF

arch-chroot /mnt /mnt/install-arch-chroot.sh
umount -a
reboot now

