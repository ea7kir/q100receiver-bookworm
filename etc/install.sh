#!/bin/bash

# Install Q100 Receiver on Raspberry Pi 4
# Orignal design by Michael, EA7KIR

# updated to GO 1.22 on March 2 2024

GOVERSION=1.22.2

whoami | grep -q pi
if [ $? != 0 ]; then
  echo Install must be performed as user pi
  exit
fi

hostname | grep -q rxtouch
if [ $? != 0 ]; then
  echo Install must be performed on host rxtouch
  exit
fi

while true; do
   read -p "Install q100receiver using Go version $GOVERSION (y/n)? " answer
   case ${answer:0:1} in
       y|Y ) break;;
       n|N ) exit;;
       * ) echo "Please answer yes or no.";;
   esac
done

###################################################

echo Update Pi OS
sudo apt update
sudo apt full-upgrade -y
sudo apt autoremove -y
sudo apt clean

###################################################

echo Installing Git
sudo apt -y install git

###################################################

echo Install a minmal Desktop
sudo apt install raspberrypi-ui-mods -y

##################################################

# echo Running rfkill # not sure if this dupicates config.txt
# rfkill block 0
# rfkill block 1

###################################################

# echo Making changes to config.txt

# sudo sh -c "echo '\n# EA7KIR Additions' >> /boot/config.txt"

# echo Disable Wifi
# sudo sh -c "echo 'dtoverlay=disable-wifi' >> /boot/config.txt"

# echo Disable Bluetooth
# sudo sh -c "echo 'dtoverlay=disable-bt' >> /boot/config.txt"

# echo EXPERIMENTAL: raspi-config, select System / Audio, choose 1
# sudo sh -c "echo 'dtparam=audio=off' >> /boot/config.txt"

###################################################

echo Making changes to .profile
sudo sh -c "echo '\n# EA7KIR Additions' >> /home/pi/.profile"

# echo Disbale Screen Blanking in .profile
# echo -e 'export DISPLAY=:0; xset s noblank; xset s off; xset -dpms' >> /home/pi/.profile

echo Adding go path to .profile
echo -e 'export PATH=$PATH:/usr/local/go/bin' >> /home/pi/.profile

###################################################

echo Installing Go $GOVERSION
GOFILE=go$GOVERSION.linux-arm64.tar.gz
cd /usr/local
sudo wget https://go.dev/dl/$GOFILE
sudo tar -C /usr/local -xzf $GOFILE
cd

echo Installing gioui dependencies
sudo apt install pkg-config libwayland-dev libx11-dev libx11-xcb-dev libxkbcommon-x11-dev libgles2-mesa-dev libegl1-mesa-dev libffi-dev libxcursor-dev libvulkan-dev -y

echo Installing gioui tools
# currently, allow 'go mod tidy' to instal gioui v0.6.1
/usr/local/go/bin/go install gioui.org/cmd/gogio@latest

###################################################

echo Install the No Video caption
sudo cp /home/pi/Q100/q100receiver/etc/NoVideo.jpg /usr/share/rpd-wallpaper

###################################################

echo Install longmynd dependencies
#sudo apt install make gcc libusb-1.0-0-dev libasound2-dev
sudo apt install libusb-1.0-0-dev libasound2-dev -y

###################################################

echo Cloning longmynd to /home/pi/Q100
cd /home/pi/Q100
git clone https://github.com/ea7kir/longmynd.git
cd longmynd
make
mkfifo longmynd_main_status
mkfifo longmynd_main_ts
cd

###################################################

# echo Copying q100receiver.service
# cd /home/pi/Q100/q100receiver/etc
# sudo cp q100receiver.service /etc/systemd/system/
# sudo chmod 644 /etc/systemd/system/q100receiver.service
# sudo systemctl daemon-reload
# cd

###################################################

chmod -x /home/pi/Q100/etc/install.sh # to prevent it from being run a second time

echo "
INSTALL HAS COMPLETED
    after rebooting...

    Ues your finger to configure some Desktop settings:

    Screen Layout Editor
	    move DSI-1 to the left of HDMI-1
	    Layout/Screens set DSI-1 to Active, Primary
	    Layout/Screens set HDMI-1 to Active, 1920x1080, 50Hz
    Appearance Settings
	    DSI-1 Layout No Image
	    HDMI-1 Layout NoVideo.jpg
	    Disable Wastebasket & External Disks
    Raspberry Pi Configuration
	    System set Network at Boot to ON

    Then login from your PC, Mc, or Linux computer

    ssh pi@txtouch.local

    Now execute the following commands
    
    cd Q100/q100receiver
    go mod tidy
    go build .
 
"

while true; do
    read -p "I have read the above, so continue (y/n)? " answer
    case ${answer:0:1} in
        y|Y ) break;;
        n|N ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

sudo reboot
