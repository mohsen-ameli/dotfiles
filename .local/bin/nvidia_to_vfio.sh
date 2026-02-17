#!/bin/bash
# Switches to vfio drivers

# echo "0000:01:00.0" | sudo tee /sys/bus/pci/devices/0000:01:00.0/driver/unbind
# echo "0000:01:00.1" | sudo tee /sys/bus/pci/devices/0000:01:00.1/driver/unbind

echo -n "remove" | sudo tee /sys/bus/pci/devices/0000:01:00.0/drm/card1/uevent
# udevadm trigger --action=remove /dev/dri/card1
# killall /usr/lib/org_kde_powerdevil #idk why, but this binds to some obscure file which not tested yet
# lsof /dev/nvidia0 | awk '{print $2}' | xargs -I {} kill {}
# lsof /dev/dri/card1 | awk '{print $2}' | xargs -I {} kill {}
# lsof /dev/dri/renderD129 | awk '{print $2}' | xargs -I {} kill {}
# sleep 5s #allow graceful shutdown
# #if still alive
lsof /dev/nvidia0 | awk '{print $2}' | xargs -I {} kill -9 {}
lsof /dev/dri/card1 | awk '{print $2}' | xargs -I {} kill -9 {}
lsof /dev/dri/renderD129 | awk '{print $2}' | xargs -I {} kill -9 {}
sleep 2s #prevent unloading breaking
rmmod nvidia_drm
rmmod nvidia_modeset
rmmod nvidia_uvm
rmmod nvidia
modprobe vfio_pci ids=10de:2520,10de:228e 
modprobe vfio_pci_core vfio_iommu_type1 vfio
#setup currentenv for gpuloder script
# echo -n "__GLX_VENDOR_LIBRARY_NAME=mesa
# __EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/50_mesa.json
# VK_DRIVER_FILES=/usr/share/vulkan/icd.d/radeon_icd.x86_64.json" > /tmp/gpuloader_currentenv
# #replace above with your preffered path
