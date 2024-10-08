#!/bin/bash

# Function to handle errors
handle_error() {
    echo "Error on line $1"
    exit 1
}

# Trap errors
trap 'handle_error $LINENO' ERR

# Update and Upgrade the System
sudo apt update && sudo apt upgrade -y

# Install or Upgrade Git
if ! command -v git &> /dev/null; then
    sudo apt install git -y
else
    echo "Git is already installed. Checking for updates..."
    sudo apt install --only-upgrade git -y
fi

# Install or Upgrade Compilers and Interpreters

## GCC (C/C++ Compiler)
if ! command -v gcc &> /dev/null; then
    sudo apt install build-essential -y
else
    echo "GCC is already installed. Checking for updates..."
    sudo apt install --only-upgrade build-essential -y
fi

sudo apt-get install acpi
sudo apt-get install pulseaudio-utils
## Python
if ! command -v python3 &> /dev/null; then
    sudo apt install python3 python3-pip -y
else
    echo "Python is already installed. Checking for updates..."
    sudo apt install --only-upgrade python3 python3-pip -y
fi

## Java (OpenJDK)
if ! command -v java &> /dev/null; then
    sudo apt install openjdk-11-jdk -y
else
    echo "Java is already installed. Checking for updates..."
    sudo apt install --only-upgrade openjdk-11-jdk -y
fi

## Node.js and npm
if ! command -v node &> /dev/null; then
    sudo apt install nodejs npm -y
else
    echo "Node.js is already installed. Checking for updates..."
    sudo apt install --only-upgrade nodejs npm -y
fi

## Ruby
if ! command -v ruby &> /dev/null; then
    sudo apt install ruby-full -y
else
    echo "Ruby is already installed. Checking for updates..."
    sudo apt install --only-upgrade ruby-full -y
fi

## Go
if ! command -v go &> /dev/null; then
    sudo apt install golang-go -y
else
    echo "Go is already installed. Checking for updates..."
    sudo apt install --only-upgrade golang-go -y
fi

## PHP
if ! command -v php &> /dev/null; then
    sudo apt install php php-cli -y
else
    echo "PHP is already installed. Checking for updates..."
    sudo apt install --only-upgrade php php-cli -y
fi

# Install or Upgrade Docker
if ! command -v docker &> /dev/null; then
    sudo apt install docker.io -y
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker $USER
else
    echo "Docker is already installed. Checking for updates..."
    sudo apt install --only-upgrade docker.io -y
fi

# Install Kubernetes Tools

## kubectl
if ! command -v kubectl &> /dev/null; then
    sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl
    sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
    echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo apt-get update
    sudo apt-get install -y kubectl
else
    echo "kubectl is already installed. Checking for updates..."
    sudo apt-get install --only-upgrade kubectl -y
fi

## Minikube
if ! command -v minikube &> /dev/null; then
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
else
    echo "Minikube is already installed. Checking for updates..."
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
fi

# Snap Package Installations

sudo snap install android-studio --classic
sudo snap install code --classic
sudo snap install ark
sudo snap install bare
sudo snap install bing-wall
sudo snap install bmi-calculator
sudo snap install brave
sudo snap install core
sudo snap install core18
sudo snap install core20
sudo snap install core22
sudo snap install core24
sudo snap install eclipse --classic
sudo apt update -y && sudo apt upgrade -y
sudo apt install handbrake -y
sudo snap install ffmpeg
sudo snap install firefox
sudo snap install firmware-updater
sudo snap install flutter --classic
sudo snap install git-ubuntu --classic
sudo snap install gnome-3-28-1804
sudo snap install gnome-3-38-2004
sudo snap install gnome-42-2204
sudo snap install gnome-46-2404
sudo snap install gnome-calculator
sudo snap install gnome-calendar
sudo snap install gnome-system-monitor
sudo snap install gtk-common-themes
sudo snap install kf6-core22
sudo snap install mesa-2404
sudo snap install node --classic
sudo snap install obs-studio
sudo snap install photoscape
sudo snap install postman
sudo snap install pycharm-community --classic
sudo snap install qt-common-themes
sudo snap install qt5-core22
sudo snap install snap-store
sudo snap install snapd
sudo snap install snapd-desktop-integration
sudo snap install transmission
sudo snap install vlc
sudo snap install winamp
sudo snap install wine-platform-5-stable
sudo snap install wine-platform-7-devel-core20
sudo snap install wine-platform-runtime
sudo snap install wine-platform-runtime-core20

sudo snap install whatsapp-for-linux

# Git Configuration
git config --global user.name "SumanthHegdeG"
git config --global user.email "sumanthyashu@gmail.com"

# List Repositories and Clone Selected One
echo "Fetching list of repositories..."
repos=$(curl -s https://api.github.com/users/SumanthHegdeG/repos | jq -r '.[].name')

echo "Available Repositories:"
select repo in $repos; do
    if [ -n "$repo" ]; then
        git clone https://github.com/SumanthHegdeG/$repo.git
        break
    else
        echo "Invalid selection. Try again."
    fi
done

# Add Git Safe Directories
git config --global --add safe.directory D:/s/devops_notes_Scaler
git config --global --add safe.directory /
git config --global --add safe.directory C:/
git config --global --add safe.directory D:/
git config --global --add safe.directory E:/

# Clean Up
sudo apt autoremove -y
sudo apt clean

# Battery Monitoring Script
BATTERY_THRESHOLD=20
CHECK_INTERVAL=60

battery_monitor_script="$HOME/Documents/battery_monitor.sh"

cat << 'EOF' > $battery_monitor_script
#!/bin/bash

BATTERY_THRESHOLD=20
CHECK_INTERVAL=60

while true; do
    battery_level=\$(acpi -b | grep -P -o '[0-9]+(?=%)')
    
    if [ \$battery_level -le \$BATTERY_THRESHOLD ]; then
        notify-send "Battery Low" "Battery level is \${battery_level}%. Please connect your charger."
    fi

    if on_ac_power; then
        if [ "\$battery_level" -gt 89 ]; then
            notify-send -i "\$PWD/batteryfull.png" "Battery full." "Level: \${battery_level}% "
            
            # Loop until the charger is unplugged
            while on_ac_power; do
                paplay /usr/share/sounds/ubuntu/ringtones/Alarm\ clock.ogg
                sleep 1 # Adjust the sleep duration if needed
            done
        fi
    fi

    sleep 5 # Short sleep to avoid excessive CPU usage
done
EOF

chmod +x $battery_monitor_script

# Create a systemd service for running the script at startup
cat << 'EOF' | sudo tee /etc/systemd/system/battery_monitor.service > /dev/null
[Unit]
Description=Battery Monitor Service
After=multi-user.target

[Service]
Type=simple
ExecStart=/bin/bash /home/$USER/Documents/battery_monitor.sh
Restart=on-failure
User=$USER

[Install]
WantedBy=multi-user.target
EOF

# Enable the service to run on startup
sudo systemctl daemon-reload
sudo systemctl enable battery_monitor.service
sudo systemctl start battery_monitor.service

echo "Setup complete. The battery monitor script will run at startup."
