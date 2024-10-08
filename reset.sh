#!/bin/bash

# Script to Reset Ubuntu Without Reinstalling and Without Losing /home Data

# Step 1: Back Up Your Data (Reminder)
echo "Reminder: Make sure to back up your data before proceeding."

# Step 2: Update package lists
echo "Updating package lists..."
sudo apt-get update

# Step 3: List all installed packages
echo "Listing all installed packages..."
installed_packages=$(dpkg --get-selections | grep -v deinstall | awk '{print $1}')

# Step 4: Remove all non-essential packages
echo "Removing all non-essential packages..."
sudo apt-get purge -y $installed_packages

# Step 5: Clean up dependencies and cache
echo "Cleaning up the system..."
sudo apt-get autoremove --purge -y
sudo apt-get clean

# Step 6: Reinstall core Ubuntu packages
echo "Reinstalling core Ubuntu packages..."
sudo apt-get install --reinstall -y ubuntu-desktop
sudo apt-get install --reinstall -y ubuntu-standard
sudo apt-get install --reinstall -y ubuntu-minimal

# Step 7: Remove User-Specific Configurations (Optional)
read -p "Do you want to remove user-specific configurations (reset user settings)? (y/n): " reset_user_config

if [[ "$reset_user_config" == "y" || "$reset_user_config" == "Y" ]]; then
    echo "Removing user-specific configurations..."
    rm -rf ~/.config
    rm -rf ~/.local
    rm -rf ~/.cache
else
    echo "Skipping user-specific configuration reset."
fi

# Step 8: Check for Broken Packages
echo "Checking for broken packages..."
sudo apt-get install -f

echo "System reset complete!"

# How to use this script:
# 1. Save the script into a file, e.g., reset_ubuntu_complete.sh
# 2. Make the script executable:
#    chmod +x reset_ubuntu_complete.sh
# 3. Run the script:
#    ./reset_ubuntu_complete.sh
