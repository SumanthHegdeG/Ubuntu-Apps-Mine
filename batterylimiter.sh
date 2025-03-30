#!/bin/bash


sudo pip3 install playsound==1.2.2 --break-system-packages
sudo add-apt-repository -y ppa:teejee2008/ppa
sudo apt-get update
sudo apt-get install aptik-battery-monitor

sudo sh ./aptik-battery-monitor*amd64.run # 64-bit, or
sudo sh ./aptik-battery-monitor*i386.run  # 32-bit
sudo wget -O /alarm.mp3 "https://github.com/SumanthHegdeG/Ubuntu-Apps-Mine/raw/main/battery%20limiter/alarm.mp3"

sudo apt install python3-mutagen python3-psutil ffmpeg
sudo pip3 install pygame


# Define paths and URLs
SCRIPT_URL="https://raw.githubusercontent.com/SumanthHegdeG/Ubuntu-Apps-Mine/main/battery-limiter.py"
SCRIPT_PATH="/battery-limiter.py"
ALARM_FILE="/alarm.mp3"
ALARM_URL="https://raw.githubusercontent.com/SumanthHegdeG/Ubuntu-Apps-Mine/main/alarm.mp3"

# Function to check and install required system packages
install_system_packages() {
    echo "Installing required system packages..."
    sudo apt update
    sudo apt install -y python3 python3-pip libnotify-bin
}

# Function to install required Python packages
install_python_packages() {
    echo "Installing required Python packages..."
    pip3 install --break-system-packages psutil mutagen
}

# Function to download the battery limiter script
download_script() {
    echo "Downloading battery limiter script..."
    wget -O "$SCRIPT_PATH" "$SCRIPT_URL"
    chmod +x "$SCRIPT_PATH"
    echo "Script saved at: $SCRIPT_PATH"
}

# Function to ensure the alarm sound file exists
ensure_alarm_file() {
    if [ ! -f "$ALARM_FILE" ]; then
        echo "Downloading alarm sound file..."
        wget -O "$ALARM_FILE" "$ALARM_URL"
        echo "Alarm sound saved at: $ALARM_FILE"
    fi
}

# Function to add script to system startup using cron
add_cron_job() {
    echo "Adding script to startup cron job..."
    (crontab -l 2>/dev/null; echo "@reboot python3 $SCRIPT_PATH &") | crontab -
}

# Function to add script to GNOME Startup Applications
add_to_gnome_startup() {
    AUTOSTART_DIR="$HOME/.config/autostart"
    mkdir -p "$AUTOSTART_DIR"
    AUTOSTART_FILE="$AUTOSTART_DIR/battery-limiter.desktop"

    cat <<EOF > "$AUTOSTART_FILE"
[Desktop Entry]
Type=Application
Exec=python3 $SCRIPT_PATH
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Battery Limiter
Comment=Battery charge and low battery alarm
EOF

    echo "Script successfully added to GNOME Startup Applications."
}

# Function to start the script in the background
start_script() {
    echo "Starting battery-limiter script..."
    nohup python3 "$SCRIPT_PATH" > /dev/null 2>&1 &
}

# Run all functions
install_system_packages
install_python_packages
download_script
ensure_alarm_file
add_cron_job
add_to_gnome_startup
start_script

echo "Setup complete. Battery limiter is now running."


chmod +x battery-limiter.sh
