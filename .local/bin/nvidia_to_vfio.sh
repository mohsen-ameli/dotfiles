#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
fi

# confirm with user before proceeding
read -p "This script will unbind the NVIDIA GPU and audio devices from their current drivers and bind them to vfio-pci. Do you want to continue? (Y/n) "
if [[ "$REPLY" =~ ^[Nn]$ ]]; then
    echo "Aborting."
    exit
fi

#
# ## Unbind VGA and audio from "standard" drivers
# echo 0000:01:00.0 > /sys/bus/pci/devices/0000:01:00.0/driver/unbind
# echo 0000:01:00.1 > /sys/bus/pci/devices/0000:01:00.1/driver/unbind
#
# ##Bind VGA and audio to vfio-pci
# echo 0000:01:00.0 > /sys/bus/pci/drivers/vfio-pci/bind
# echo 0000:01:00.1 > /sys/bus/pci/drivers/vfio-pci/bind



display_manager="sddm"

pci_bus_id_nvidia_gpu="0000:01:00.0"
pci_bus_id_nvidia_audio="0000:01:00.1"

device_id_nvidia_gpu="10de 2520"
device_id_nvidia_audio="10de 228e"

# stop xorg
systemctl stop "$display_manager"

modprobe vfio
modprobe vfio_iommu_type1
modprobe vfio_pci

# unbind virtual console
# echo 0 > /sys/class/vtconsole/vtcon1/bind

# unbind efi framebuffer
# echo "efi-framebuffer.0" > /sys/bus/platform/devices/efi-framebuffer.0/driver/unbind

# create new vfio-pci devices with ids of gpu and hdmi audio
# echo "$device_id_nvidia_gpu" > /sys/bus/pci/drivers/vfio-pci/bind
# echo "$device_id_nvidia_audio" > /sys/bus/pci/drivers/vfio-pci/bind

# unbind gpu and hdmi audio
echo "$pci_bus_id_nvidia_gpu" > /sys/bus/pci/devices/"$pci_bus_id_nvidia_gpu"/driver/unbind
echo "$pci_bus_id_nvidia_audio" > /sys/bus/pci/devices/"$pci_bus_id_nvidia_audio"/driver/unbind

# bind gpu and hdmi audio to vfio-pci
echo "$pci_bus_id_nvidia_gpu" > /sys/bus/pci/drivers/vfio-pci/bind
echo "$pci_bus_id_nvidia_audio" > /sys/bus/pci/drivers/vfio-pci/bind

# remove created ids
# echo "$device_id_nvidia_gpu" > /sys/bus/pci/drivers/vfio-pci/remove_id
# echo "$device_id_nvidia_audio" > /sys/bus/pci/drivers/vfio-pci/remove_id

# bind virtual console to internal gpu
# echo 1 > /sys/class/vtconsole/vtcon1/bind

# start xorg again
systemctl start "$display_manager"

lspci -knn | grep -A 3 VGA
