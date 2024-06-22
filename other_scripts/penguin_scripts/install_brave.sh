#!/bin/bash

# chmod +x install_brave.sh

# Check if run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Install curl if not already installed
if ! command -v curl &> /dev/null; then
  echo "Installing curl..."
  apt update
  apt install -y curl
fi

# Download and add Brave browser GPG key
echo "Adding Brave browser GPG key..."
curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

# Add Brave browser repository
echo "Adding Brave browser repository..."
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | tee /etc/apt/sources.list.d/brave-browser-release.list
# arch=amd64: The architecture of the system, this fixes i386 architecture error

# Update package list
echo "Updating package list..."
apt update

# Install Brave browser
echo "Installing Brave browser..."
apt install -y brave-browser

echo "Brave browser installation complete."
