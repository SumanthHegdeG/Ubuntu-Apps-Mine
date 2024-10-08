#!/bin/bash

# Check if required utilities are installed, install if not
check_prerequisites() {
    required_packages=("acpi" "pulseaudio-utils")

    for package in "${required_packages[@]}"; do
        if ! command -v "$package" &> /dev/null; then
            echo "$package is not installed. Installing..."
            sudo apt-get install "$package" -y
        fi
    done
}

# Function to play alarm tune
play_alarm_tune() {
    paplay "./alarm.mp3"  # Play alarm tune
}

# Function to check battery level and trigger alarm if necessary
check_battery() {
    # Get battery status
    battery_status=$(acpi -b)
    charging_status=$(acpi -a | grep -o "on-line\|off-line")

    # Extract battery percentage
    battery_level=$(echo $battery_status | grep -P -o '[0-9]+(?=%)')

    # Check if battery level is below or equal to 10% and discharging
    if [ $battery_level -le 10 ] && [ "$charging_status" == "off-line" ]; then
        # Trigger battery alarm if not already ringing
        if [ $alarm_ringing -eq 0 ]; then
            notify-send "Low Battery" "Battery level is ${battery_level}%." -u critical
            play_alarm_tune &  # Play alarm in the background
            alarm_ringing=1
        fi
    elif [ $battery_level -ge 90 ] && [ "$charging_status" == "on-line" ]; then
        # Trigger battery alarm if not already ringing
        if [ $alarm_ringing -eq 0 ]; then
            notify-send "High Battery" "Battery level is ${battery_level}%." -u critical
            play_alarm_tune &  # Play alarm in the background
            alarm_ringing=1
        fi
    else
        # If battery level is within limits, stop the alarm if it's ringing
        if [ $alarm_ringing -eq 1 ]; then
            notify-send "Battery Level Normal" "Battery level is ${battery_level}%." -u low
            pkill -f "paplay"  # Stop the alarm
            alarm_ringing=0
        fi
    fi
}

# Main script
alarm_ringing=0
scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"  # Directory where the script resides

# Check prerequisites
check_prerequisites

# Continuously monitor battery status
while true; do
    check_battery  # Check battery status
    sleep 10       # Check every 10 seconds
done
