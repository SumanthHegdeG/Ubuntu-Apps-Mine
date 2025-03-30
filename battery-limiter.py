#!/usr/bin/env python3

import psutil
import time
import os
from playsound import playsound
import subprocess  # For Linux desktop notifications
import threading
from mutagen.mp3 import MP3  # To get audio length
import sys
import urllib.request

# Ensure required packages are installed
def install_packages():
    required_packages = ["psutil", "playsound", "mutagen"]
    for package in required_packages:
        try:
            __import__(package)
        except ImportError:
            print(f"Installing missing package: {package}")
            subprocess.run(["sudo", sys.executable, "-m", "pip", "install", package])

install_packages()

# Set your sound file's absolute path here
ALARM_SOUND_PATH = "/alarm.mp3"
LOW_BATTERY_ALARM_PATH = "/alarm.mp3"  # Low battery alarm sound
CHARGE_LIMIT = 90  # Upper battery limit
LOW_BATTERY_LIMIT = 10  # Lower battery limit
ALARM_DOWNLOAD_URL = "https://github.com/SumanthHegdeG/Ubuntu-Apps-Mine/blob/main/battery%20limiter/alarm.mp3"

# Check if alarm sound file exists, if not, download it
def ensure_alarm_file():
    if not os.path.exists(ALARM_SOUND_PATH):
        print("Alarm sound file missing. Downloading...")
        try:
            urllib.request.urlretrieve(ALARM_DOWNLOAD_URL, ALARM_SOUND_PATH)
            print("Download complete: /alarm.mp3")
        except Exception as e:
            print("Error downloading alarm sound:", e)

ensure_alarm_file()

# Get the duration of the alarm sounds
def get_audio_length(file_path):
    try:
        audio = MP3(file_path)
        return audio.info.length
    except Exception as e:
        print("Error reading audio file:", e)
        return 10  # Default to 10 seconds if error

alert_active = True  # Flag to control alarm and notification
ALARM_DURATION = get_audio_length(ALARM_SOUND_PATH)
LOW_BATTERY_ALARM_DURATION = get_audio_length(LOW_BATTERY_ALARM_PATH)

def show_notification(message):
    while alert_active:
        subprocess.run(["notify-send", "Battery Alert", message])
        time.sleep(ALARM_DURATION)  # Repeat notification based on alarm length

def play_alarm(sound_path, duration):
    while alert_active:
        playsound(sound_path)
        time.sleep(0.5)  # Wait for alarm to finish before playing again

def battery_alert():
    global alert_active
    
    while True:
        battery = psutil.sensors_battery()
        charge_percent = battery.percent
        is_plugged = battery.power_plugged
        
        # Print charge status every 10 seconds
        print(f"Current battery level: {charge_percent}% - {'Plugged in' if is_plugged else 'Not plugged in'}")

        # High battery alarm
        if charge_percent >= CHARGE_LIMIT and is_plugged:
            print("Battery at {}%. Unplug charger!".format(charge_percent))
            alert_active = True
            notification_thread = threading.Thread(target=show_notification, args=("Battery at {}%. Unplug charger!".format(charge_percent),))
            alarm_thread = threading.Thread(target=play_alarm, args=(ALARM_SOUND_PATH, ALARM_DURATION))
            
            notification_thread.start()
            alarm_thread.start()
            
            while is_plugged:
                time.sleep(ALARM_DURATION)
                battery = psutil.sensors_battery()
                is_plugged = battery.power_plugged
            
            alert_active = False
            print("Charger unplugged. Exiting alert.")

        # Low battery alarm
        elif charge_percent <= LOW_BATTERY_LIMIT and not is_plugged:
            print("Battery at {}%. Plug in the charger!".format(charge_percent))
            alert_active = True
            notification_thread = threading.Thread(target=show_notification, args=("Battery at {}%. Plug in the charger!".format(charge_percent),))
            alarm_thread = threading.Thread(target=play_alarm, args=(LOW_BATTERY_ALARM_PATH, LOW_BATTERY_ALARM_DURATION))
            
            notification_thread.start()
            alarm_thread.start()
            
            while not is_plugged:
                time.sleep(LOW_BATTERY_ALARM_DURATION)
                battery = psutil.sensors_battery()
                is_plugged = battery.power_plugged
            
            alert_active = False
            print("Charger plugged in. Exiting low battery alert.")
        
        time.sleep(1)  # Check battery status every 1 seconds

if __name__ == "__main__":
    battery_alert()
