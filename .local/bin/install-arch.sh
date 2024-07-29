#!/bin/sh

if ! ping -c 1 google.com; then
  echo "No internet connection detected ;("
  exit 1
fi

init_system="systemd"

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

if [ "$init_system" = "openrc" ]; then
  rc-service ntpd start
fi

curl "https://archlinux.org/mirrorlist/?country=CA&protocol=http&protocol=https&ip_version=4" > /etc/pacman.d/mirrorlist
sed 's/#Server/Server/g' -i /etc/pacman.d/mirrorlist

echo ":: Starting installation"
pacstrap -K /mnt base base-devel linux linux-firmware grub efibootmgr networkmanager dhcpcd vim htop wget terminus-fonts
if [ "$init_system" = "openrc" ]; then
  pacstrap -K /mnt openrc elogind-openrc
fi

genfstab -U /mnt >> /mnt/etc/fstab

mv ./install-arch-chroot.sh /mnt

arch-chroot /mnt

