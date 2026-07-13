#!/bin/bash
# Unload the VFIO modules and load the NVIDIA drivers

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
fi

display_manager="sddm"
pci_bus_id_nvidia_gpu="0000:01:00.0"
pci_bus_id_nvidia_audio="0000:01:00.1"

# rmmod vfio_pci vfio_pci_core vfio_iommu_type1 vfio

systemctl stop "$display_manager"

## Unload vfio
modprobe -r vfio_pci
modprobe -r vfio_iommu_type1
modprobe -r vfio

modprobe nvidia_drm modeset=1
modprobe nvidia nvidia_modeset nvidia_uvm

##Unbind VGA and audio to vfio-pci
echo "$pci_bus_id_nvidia_gpu" > /sys/bus/pci/devices/"$pci_bus_id_nvidia_gpu"/driver/unbind
echo "$pci_bus_id_nvidia_audio" > /sys/bus/pci/devices/"$pci_bus_id_nvidia_audio"/driver/unbind

##Bind VGA and audio to "standard" drivers
echo "$pci_bus_id_nvidia_gpu" > /sys/bus/pci/drivers/nvidia/bind
echo "$pci_bus_id_nvidia_audio" > /sys/bus/pci/drivers/snd_hda_intel/bind

# start xorg again
systemctl start "$display_manager"

lspci -knn | grep -A 3 VGA
