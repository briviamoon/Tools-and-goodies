#!/bin/bash
cd ~/Desktop || return
mkdir linux-prep || return
cd linux-prep || return

git="git"
wget="wget"
kat="katoolin"

echo "You are about to install The Following Programs...."

echo "$git
$kat
$wget
Arduino
Meta Trader-5
Visual Studio Code
Snap Store"

#ESSENTIALS
# WGET
sudo apt install $wget
# GIT
sudo apt install $git

####### Installing KATOOLIN
echo "KATOOLING - (A KALI LINUX TOOLS INSTALL)"
# shellcheck disable=SC2162
read -p "Would You Like To Install $kat? [y/n]" user_input
if [ "$user_input" == "y" ] || [ "$user_input" == "Y" ]; then
	git clone https://github.com/LionSec/katoolin.git
	sudo cp katoolin/katoolin.py /usr/bin/katoolin
	sudo chmod +x /usr/bin/katoolin
	sudo katoolin
else
	echo "skipping Katoolin Install"
fi

install_update_program() {
	local name_of_program=$1
	local config_file
	local program_url

	if command -v "$name_of_program" &>/dev/null; then
		current_version=$($name_of_program --version | awk 'NR==1{print $3}')
		echo "$name_of_program Already Installed (Version $current_version)."

		config_file=$(find ~/.config/ -name "$name_of_program")
		program_url=$(grep "^$name_of_program=" "$config_file" | cut -d'=' -f2)

		if [ -z "$program_url" ]; then
			echo "Error: Config not found for $name_of_program."
			return
		fi

		# If program Exixts, Check for updates
		latest_release=$(curl -s "$program_url")
		if [ "$current_version" != "$latest_release" ]; then
			echo "$name_of_program $current_version has an update $latest_release."
			# request update
			# shellcheck disable=SC2162
			read -p "Would You like to update to $latest_release? [y/n]: " user_choice
			if [ "$user_choice" == "y" ] || [ "$user_choice" == "Y" ]; then
				echo "Updating $name_of_program..."
				sudo apt update "$name_of_program"
			else
				echo "Skipping $name_of_program Update."
			fi
		else
			echo "$name_of_program is up-to-date."
		fi
	# if program does not exist, install it
	else
		# shellcheck disable=SC2162
		read -p "Would You Like to install $name_of_program? [y/n]" user_choose
		if [ "$user_choose" == "y" ] || [ "$user_choose" == "Y" ]; then
			echo "Installing $name_of_program..."
			sudo apt update
			sudo apt install "$name_of_program"
			if command -v "$name_of_program" &>/dev/null; then
				Install_version=$($name_of_program --version | awk 'NR==1{print $3}')
				echo "$name_of_program Version $Install_version Installed ... :)"
				return
			else
				echo "Error: $name_of_program could not be installed. Try Installing it manualy"
				return
			fi
		else
			echo "Skipping $name_of_program Install ..."
			return
		fi
	fi
}
# function calls
# Arduino
install_update_program "arduino"

######### installing snap store
echo "installimg snap now ############"
sudo apt install snapd
sudo snap install snap-store

######### installing chrome
echo "installing chrome ##############"

# Add Google Chrome repository
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list

# Import Google Chrome signing key
wget -qO - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -

sudo apt update

# Install Google Chrome
sudo apt install google-chrome-stable -y

######### Installing VISUAL STUDIO CODE
echo "Installing VisualStudio Code #############"

# Import Microsoft GPG key
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg

# Add Visual Studio Code repository
echo "deb [arch=amd64] http://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list

sudo apt update

# Install Visual Studio Code
sudo apt install code -y

sudo apt update

######## Installing Meta trader
echo "Installing MetaTrader5 ##########"

wget https://download.mql5.com/cdn/web/metaquotes.software.corp/mt5/mt5ubuntu.sh
sudo chmod +x mt5ubuntu.sh
./mt5ubuntu.sh

########### Prompt Install Finish #########
echo "Install complete"
echo "Youll find the downloaded packages used to install the apps inside 'Essentials-Dump' folder in your desktop"
