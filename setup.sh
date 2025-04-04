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
sudo apt install ultracopier

# Install or Upgrade Git
if ! command -v git &> /dev/null; then
    sudo apt install git -y
else
    echo "Git is already installed. Checking for updates..."
    sudo apt install --only-upgrade git -y
fi

# Install or Upgrade Compilers and Interpreters

sudo add-apt-repository -y ppa:teejee2008/ppa
sudo apt-get update
sudo apt-get install aptik-battery-monitor

sudo sh ./aptik-battery-monitor*amd64.run # 64-bit, or
sudo sh ./aptik-battery-monitor*i386.run  # 32-bit
sudo wget -O /alarm.mp3 "https://github.com/SumanthHegdeG/Ubuntu-Apps-Mine/raw/main/battery%20limiter/alarm.mp3"

sudo apt install python3-mutagen python3-psutil ffmpeg
sudo pip3 install pygame



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
sudo mv /etc/apt/preferences.d/nosnap.pref ~/Documents/nosnap.backup
sudo apt update
# Install Minikube
echo "Installing Minikube..."
if ! command -v minikube &> /dev/null; then
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
    rm minikube-linux-amd64
    echo "Minikube installed successfully."
else
    echo "Minikube is already installed."
fi

# Install kubectl
echo "Installing kubectl..."
if ! command -v kubectl &> /dev/null; then
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
    
    echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    rm kubectl kubectl.sha256
    echo "kubectl installed successfully."
else
    echo "kubectl is already installed."
fi

# Verify installations
echo "Verifying installations..."
if command -v minikube &> /dev/null; then
    echo "Minikube version: $(minikube version)"
else
    echo "Minikube installation failed."
    exit 1
fi

if command -v kubectl &> /dev/null; then
    echo "kubectl version: $(kubectl version --client --short)"
else
    echo "kubectl installation failed."
    exit 1
fi

if command -v snap &> /dev/null; then
    echo "Snap is installed and working correctly."
else
    echo "Snap installation failed."
    exit 1
fi

echo  "installing Snapcraft Deamon"
sudo mv /etc/apt/preferences.d/nosnap.pref ~/Documents/nosnap.backup
sudo apt update
sudo apt install snapd

snap install hello-world
hello-world
echo "Snapcraft installed"

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
sudo apt install curl ca-certificates -y


curl https://repo.waydro.id | sudo bash


sudo apt install waydroid -y


sudo apt update && sudo apt upgrade -y


sudo waydroid init -s GAPPS -c https://ota.waydro.id/system -v https://ota.waydro.id/vendor -f
(If required)


sudo waydroid shell


ANDROID_RUNTIME_ROOT=/apex/com.android.runtime ANDROID_DATA=/data ANDROID_TZDATA_ROOT=/apex/com.android.tzdata ANDROID_I18N_ROOT=/apex/com.android.i18n sqlite3 /data/data/com.google.android.gsf/databases/gservices.db "select * from main where name = \"android_id\";"


https://www.google.com/android/uncertified






#------ Uninstall WayDroid --------


#sudo waydroid session stop

#sudo waydroid container stop

#sudo apt remove waydroid

#sudo rm -rf /var/lib/waydroid /home/.waydroid ~/waydroid ~/.share/waydroid ~/.local/share/applications/aydroid ~/.local/share/waydroid
git clone https://github.com/AdnanHodzic/auto-cpufreq.git
cd auto-cpufreq && sudo ./auto-cpufreq-installer

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


#!/bin/bash

echo "Installing SysMonTask on Linux Mint..."

# Check if SysMonTask is already installed
if command -v sysmontask &>/dev/null; then
    echo "✅ SysMonTask is already installed."
    sysmontask
    exit 0
fi

# Detect Ubuntu/Mint version
UBUNTU_VERSION=$(lsb_release -rs)
echo "Detected Ubuntu/Mint Version: $UBUNTU_VERSION"

# Attempt to install via DEB package
echo "🔹 Trying to install via DEB package..."
wget -q --show-progress https://github.com/KrispyCamel4u/SysMonTask/releases/download/v1.3.1/sysmontask_1.3.1-1_all.deb

if [ -f "sysmontask_1.3.1-1_all.deb" ]; then
    sudo apt install ./sysmontask_1.3.1-1_all.deb -y
    rm -f sysmontask_1.3.1-1_all.deb
    if command -v sysmontask &>/dev/null; then
        echo "✅ SysMonTask installed successfully via DEB package!"
        sysmontask
        exit 0
    fi
else
    echo "❌ Failed to download the DEB package."
fi

# If DEB package fails, try pipx
echo "🔹 Trying to install via pipx..."
sudo apt install pipx -y && pipx install sysmontask

if command -v sysmontask &>/dev/null; then
    echo "✅ SysMonTask installed successfully via pipx!"
    sysmontask
    exit 0
fi

# If pipx fails, try virtual environment
echo "🔹 Trying to install in a virtual environment..."
sudo apt install python3-venv -y
python3 -m venv ~/.venv/sysmontask
source ~/.venv/sysmontask/bin/activate
pip install sysmontask

if command -v sysmontask &>/dev/null; then
    echo "✅ SysMonTask installed successfully in a virtual environment!"
    sysmontask
    exit 0
fi

echo "❌ Installation failed. Please check your internet connection or try manually installing."
exit 1


echo "Setup complete. The battery monitor script will run at startup."
