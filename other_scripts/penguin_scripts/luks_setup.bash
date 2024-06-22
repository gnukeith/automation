#!/bin/bash

# chmod +x luks_setup.bash

# Check if run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Install necessary tools
echo "Installing necessary tools..."
apt update && apt install -y cryptsetup lvm2

# Function to encrypt a disk
encrypt_disk() {
  read -p "Enter the disk to encrypt (e.g., /dev/sdX): " disk
  if [ ! -b "$disk" ]; then
    echo "Invalid disk. Please ensure the disk exists."
    exit 1
  fi

  echo "Creating a new partition table on $disk..."
  parted "$disk" --script mklabel gpt

  echo "Creating a new partition on $disk..."
  parted "$disk" --script mkpart primary 0% 100%

  partition="${disk}1"

  echo "Encrypting $partition with LUKS..."
  cryptsetup luksFormat "$partition"

  echo "Opening the encrypted partition..."
  cryptsetup luksOpen "$partition" encrypted_disk

  echo "Creating a physical volume on the encrypted partition..."
  pvcreate /dev/mapper/encrypted_disk

  echo "Creating a volume group on the physical volume..."
  vgcreate encrypted_vg /dev/mapper/encrypted_disk

  echo "Creating a logical volume within the volume group..."
  lvcreate -n encrypted_lv -l 100%FREE encrypted_vg

  echo "Formatting the logical volume with ext4..."
  mkfs.ext4 /dev/encrypted_vg/encrypted_lv

  echo "Encryption and setup complete."
}

# Function to mount the encrypted disk
mount_disk() {
  read -p "Enter the disk to mount (e.g., /dev/sdX): " disk
  partition="${disk}1"

  echo "Opening the encrypted partition..."
  cryptsetup luksOpen "$partition" encrypted_disk

  echo "Mounting the logical volume..."
  mkdir -p /mnt/encrypted_disk
  mount /dev/encrypted_vg/encrypted_lv /mnt/encrypted_disk

  echo "Encrypted disk mounted at /mnt/encrypted_disk."
}

# Function to unmount the encrypted disk
unmount_disk() {
  echo "Unmounting the encrypted disk..."
  umount /mnt/encrypted_disk

  echo "Closing the encrypted partition..."
  cryptsetup luksClose encrypted_disk

  echo "Encrypted disk unmounted."
}

# Main menu
while true; do
  echo "LUKS Disk Encryption Management"
  echo "1. Encrypt a disk"
  echo "2. Mount an encrypted disk"
  echo "3. Unmount an encrypted disk"
  echo "4. Exit"
  read -p "Choose an option: " option

  case $option in
    1)
      encrypt_disk
      ;;
    2)
      mount_disk
      ;;
    3)
      unmount_disk
      ;;
    4)
      exit 0
      ;;
    *)
      echo "Invalid option. Please try again."
      ;;
  esac
done
