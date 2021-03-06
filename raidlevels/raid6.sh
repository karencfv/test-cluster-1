#!/usr/bin/env bash
# Create RAID6 array
mdadm --create --verbose /dev/md0 --level=6 --raid-devices=4 /dev/sdb /dev/sdc /dev/sdd /dev/sde

# Create filesystem
mkfs.ext4 -F /dev/md0

# Mount point to attach the FS
mkdir -p /mnt/md0

# Mount FS
sudo mount /dev/md0 /mnt/md0

# Scan active array and append mdadm.conf file
mdadm --detail --scan | tee -a /etc/mdadm/mdadm.conf

# Update initial RAM filesystem for the array to be available during early boot process
update-initramfs -u

# Add new FS options to etc/fstab file for automatic mounting at boot
echo '/dev/md0 /mnt/md0 ext4 defaults,nofail,discard 0 0' | tee -a /etc/fstab
