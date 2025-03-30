#!/bin/bash

# Define file paths
PYTHON_SCRIPT="/battery-limiter.py"
SCRIPT_URL="https://raw.githubusercontent.com/SumanthHegdeG/Ubuntu-Apps-Mine/main/battery-limiter.py"
SERVICE_FILE="/etc/systemd/system/battery_limiter.service"
STARTUP_FILE="$HOME/.config/autostart/battery_limiter.desktop"
SHELL_SCRIPT="/usr/local/bin/start_battery_limiter.sh"

# Ensure necessary packages are installed
echo "Installing required packages..."
sudo apt update && sudo apt install -y curl python3 python3-pip

# Download the Python script
echo "Downloading battery limiter script..."
curl -L $SCRIPT_URL -o $PYTHON_SCRIPT

# Print the saved file location
if [ -f "$PYTHON_SCRIPT" ]; then
    echo "File successfully downloaded to: $PYTHON_SCRIPT"
else
    echo "Error: File download failed!"
    exit 1
fi

chmod +x $PYTHON_SCRIPT

# Create a shell script to run the Python script continuously
echo "Creating shell script..."
cat <<EOL | sudo tee $SHELL_SCRIPT
#!/bin/bash
while true; do
    python3 $PYTHON_SCRIPT
    sleep 5
done
EOL
sudo chmod +x $SHELL_SCRIPT

# Create a systemd service
echo "Setting up systemd service..."
cat <<EOL | sudo tee $SERVICE_FILE
[Unit]
Description=Battery Limiter Service
After=network.target

[Service]
ExecStart=$SHELL_SCRIPT
Restart=always
User=$USER

[Install]
WantedBy=multi-user.target
EOL

# Reload systemd and enable service
sudo systemctl daemon-reload
sudo systemctl enable battery_limiter.service
sudo systemctl start battery_limiter.service

# Add cron job as a fallback
echo "Adding cron job..."
(crontab -l 2>/dev/null; echo "@reboot $SHELL_SCRIPT") | crontab -

# Ensure GNOME Startup Applications exists
mkdir -p "$HOME/.config/autostart"

# Create a GNOME Startup Application entry
echo "Adding to GNOME Startup Applications..."
cat <<EOL > "$STARTUP_FILE"
[Desktop Entry]
Type=Application
Exec=$SHELL_SCRIPT
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Battery Limiter
Comment=Auto-start Battery Limiter
EOL

echo "Setup complete! Reboot your system to apply changes."
