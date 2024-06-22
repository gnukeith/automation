#!/bin/bash

# Check if run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Function to find Firefox profiles
find_firefox_profiles() {
  if [ -d "$HOME/.mozilla/firefox" ]; then
    echo "$HOME/.mozilla/firefox"
  elif [ -d "$HOME/snap/firefox/common/.mozilla/firefox" ]; then
    echo "$HOME/snap/firefox/common/.mozilla/firefox"
  else
    echo "Firefox profile directory not found. Ensure Firefox is installed."
    exit 1
  fi
}

# Function to download and apply arkenfox user.js
apply_arkenfox_userjs() {
  firefox_profiles_dir=$(find_firefox_profiles)
  user_js_url="https://raw.githubusercontent.com/arkenfox/user.js/master/user.js"

  # Download the user.js file
  echo "Downloading arkenfox user.js..."
  wget -q -O /tmp/user.js "$user_js_url"

  # Apply user.js to all Firefox profiles
  for profile in "$firefox_profiles_dir"/*.default*; do
    if [ -d "$profile" ]; then
      echo "Applying user.js to profile: $profile"
      cp /tmp/user.js "$profile"
    fi
  done

  # Clean up
  rm /tmp/user.js
  echo "Arkenfox user.js has been applied to all Firefox profiles."
}

# Function to install necessary tools
install_tools() {
  echo "Installing necessary tools..."
  apt update && apt install -y wget
}

# Main script
install_tools
apply_arkenfox_userjs

echo "Firefox has been hardened with arkenfox user.js. Restart Firefox to apply the changes."
