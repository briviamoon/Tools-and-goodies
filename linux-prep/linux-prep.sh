#!/bin/bash

$git = 'git'
$wget = 'wget'
$kat = 'katoolin'


#ESSENTIALS
# WGET
sudo apt install $wget
# GIT
sudo apt install $git
# KATOOLIN
sudo apt-get install $kat

sudo apt update

cd ~/Desktop | mkdir Essentials-Dump | cd Essentials-Dump

#Meta trader
echo "Installing MetaTrader5 ##########"

wget https://download.mql5.com/cdn/web/metaquotes.software.corp/mt5/mt5ubuntu.sh
sudo chmod +x mt5ubuntu.sh
./mt5ubuntu.sh

# install snap store
echo "installimg snap now ############"
sudo apt install snapd
sudo snap install snap-store

# installing chrome
echo "installing chrome ##############"

# Add Google Chrome repository
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list

# Import Google Chrome signing key
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -

sudo apt update

# Install Google Chrome
sudo apt install google-chrome-stable -y

# VISUAL STUDIO CODE
echo "Installing VisualStudio Code #############"

# Import Microsoft GPG key
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg

# Add Visual Studio Code repository
echo "deb [arch=amd64] http://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list

sudo apt update

# Install Visual Studio Code
sudo apt install code -y

sudo apt update

echo "Install complete"
echo "Youll find the downloaded packages used to install the apps inside 'Essentials-Dump' folder in your desktop"

