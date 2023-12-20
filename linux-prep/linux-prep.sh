#!/bin/bash
cd ~/Desktop || return
mkdir linux-prep
cd linux-prep || return

# List Of Programs
git="git"
wget="wget"
kat="katoolin"
arduino="arduino"

## Counter To inform number of programs installed
apps_installed=0

# User Notification
echo "The Following Programs Will Be Installed....
You will Be Prompted To choose To install Each Program ..."

# List Each Program
echo "
 #1 |- $git
 #2 |- $kat
 #3 |- $wget
 #4 |- Arduino
 #5 |- Meta Trader-5
 #6 |- Visual Studio Code
 #7 |- Snap Store
 
 "

#ESSENTIALS
########### WGET ###########
if command -v wget &>/dev/null; then
	echo " $wget Is already installed ..."
else
	sudo apt install wget
	sudo apt update
	if command -v wget &>/dev/null; then
		$apps_installed++
		echo " $wget installed succesfully ..."
	else
		echo " ## Error installing Wget ..."
	fi
fi

############ GIT ############
if command -v git &>/dev/null; then
	echo " git is already Installed ..."
else
	sudo apt install git
	sudo apt update
	if command -v git &>/dev/null; then
		$apps_installed++
		echo " git installed succesfully ..."
	else
		echo " ##Error: Installing git ..."
	fi
fi

############### KATOOLIN ###########
echo "

	#### Installing KATOOLING - (A KALI LINUX TOOLS INSTALL) ####"
# shellcheck disable=SC2162
read -p " Would You Like To Install $kat? [y/n]" user_input
if [ "$user_input" == "y" ] || [ "$user_input" == "Y" ]; then
	git clone https://github.com/LionSec/katoolin.git
	sudo cp katoolin/katoolin.py /usr/bin/katoolin
	sudo chmod +x /usr/bin/katoolin
	if command -v "sudo $kat" &>/dev/null; then
		$apps_installed++
		echo " $kat Installed successfully ..."
	else
		echo " ## Error: executing $kat, Try Manualy installing it ...!"
	fi
else
	echo " skipping Katoolin Install"
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
			echo " ##Error: Config not found for $name_of_program."
			return
		fi

		# If program Exixts, Check for updates
		latest_release=$(curl -s "$program_url")
		if [ "$current_version" != "$latest_release" ]; then
			echo " $name_of_program $current_version has an update $latest_release."
			# request update
			# shellcheck disable=SC2162
			read -p " Would You like to update to $latest_release? [y/n]: " user_choice
			if [ "$user_choice" == "y" ] || [ "$user_choice" == "Y" ]; then
				echo " Updating $name_of_program..."
				sudo apt update "$name_of_program"
			else
				echo " Skipping $name_of_program Update."
			fi
		else
			echo " $name_of_program is up-to-date."
		fi
	# if program does not exist, install it
	else
		# shellcheck disable=SC2162
		echo "
	#### Installing $name_of_program ####"
		# shellcheck disable=SC2162
		read -p " Would You Like to install $name_of_program? [y/n]" user_choose
		if [ "$user_choose" == "y" ] || [ "$user_choose" == "Y" ]; then
			sudo apt update
			sudo apt install "$name_of_program"
			if command -v "$name_of_program" &>/dev/null; then
				Install_version=$($name_of_program --version | awk 'NR==1{print $3}')
				$apps_installed++
				echo "$name_of_program Version $Install_version Installed ... :)"
				return
			else
				echo " ## Error: $name_of_program could not be installed. Try Installing it manualy"
				return
			fi
		else
			echo " Skipping $name_of_program Install ..."
			return
		fi
	fi
}
############################ FUNCTION CALLS ##################################
############# Arduino ############
install_update_program "$arduino"


###### End of Function Calls #####
#
#
############## Snap-Store ################
echo "  
	#### Installimg snap ####"
# shellcheck disable=SC2162
read -p " Would You Like to proceed with snapstore installation? [y/n]" choice
if [ "$choice" == "y" ] || [ "$choice" == "Y" ]; then
	sudo apt install snapd
	sudo snap install snap-store
	$apps_installed++
else
	echo " Skipping snap store install ..."
fi

############## Chrome ##############
echo "
	#### Installing chrome ####"
# shellcheck disable=SC2162
read -p " would you like to install chrome? [y/n] " choice2
if [ "$choice2" == "y" ] || [ "$choice2" == "Y"	]; then
	# Add Google Chrome repository
	echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
	# Import Google Chrome signing key
	wget -qO - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
	sudo apt update
	# Install Google Chrome
	sudo apt install google-chrome-stable -y
	$apps_installed++
else
	echo " skipping Chrome IInstall ..."
fi

######### Installing VISUAL STUDIO CODE ###########
echo "
	#### Installing Visual Studio Code IDE ####"
# shellcheck disable=SC2162
read -p " Would you to proceed with Visual studio Code install? [y/n] " choice3
if [ "$choice3" == "y" ] || [ "$choice3" == "Y" ]; then
	echo "Importing microsoft GPG KEy ..."
	# Import Microsoft GPG key
	wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >microsoft.gpg
	sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
	#dd Visual Studio Code repository
	echo "deb [arch=amd64] http://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
	sudo apt update
	# install Vscode
	sudo apt install code -y
	if  command -v "code" &>dev/null; then
		$apps_installed++
		echo " Visual Studio Code Installed Succesfully ..."
	fi
	
else
	echo " Skipping VsCode Install ..."
fi

############### Meta-Trader 5 ###############
echo "
	#### Installing MetaTrader5 ####"
# shellcheck disable=SC2162
read -p "Would You Like To proceed With MT5 Install? [y/n] " choice4
if [ "$choice4" == "y" ] || [ "$choice4" == "Y" ]; then
	wget https://download.mql5.com/cdn/web/metaquotes.software.corp/mt5/mt5ubuntu.sh
	sudo chmod +x mt5ubuntu.sh
	./mt5ubuntu.sh
	$apps_installed++
else
	echo " Skippping MT5 install ..."
fi

## Autoremove un-needed
echo "
	#### Removing Unused Packages
	"
sudo apt autoremove
########### Install Finish #########
echo " ## $apps_installed Apps Installed ..."
echo " ## Downloaded packages used to install these appsare found inside 'linux-prep' folder in your desktop"
