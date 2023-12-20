#!/bin/bash

apps_installed=0

# Move To Another directory To Store Downloadeded Package files
mkdir ~/Desktop/linux-prep-packages
cd ~/Desktop/linux-prep-packages

# #################################### #
# 			Install Essentials		   #
# #################################### #
#				wget				#

if [ "$(command -v wget)" ]; then
	echo " wget is installed"
else
	sudo apt install wget
	sudo apt update
	if [ "$(command -v wget)" ]; then
		echo "Installed critical app 'wget'"
	else
		echo " ## Error installing wget ..."
	fi
fi
#				git					#
if [ "$(command -v git)" ]; then
	echo "git is installed"
else
	sudo apt install git
	sudo apt update
	if [ "$(command -v git)" ]; then
		echo "installed essential app 'git'"
	else
		echo " ## Error installing git ..."
	fi
fi


# declare the array of programs and the related functions
declare -A programs

# Defining a structure for each program
programs[1]="Katoolin:installKatoolin"
programs[2]="Snap-store:installSnapStore"
programs[3]="chrome:installChrome"
programs[4]="Arduino:installProgram 'Arduino'"
programs[5]="MetaTrader5:installMT"
programs[6]="Visual Studio Code:installVsCode"

AskToInstall(){
	# Displaying Options
	echo " Chose A Program To Install:"
	for key in "${!programs[@]}"; do
		IFS=':' read -r Program_name functionName <<< "${programs[$key]}"
		IFS=':' echo "	#$key |- $Program_name"
	done

	# Read User's Choice
	# shellcheck disable=SC2162
	read -p " Enter A number corresponding to the program you wish to install: " choice

	# Chek if the choice is vaid
	if [[ ${programs[$choice]} ]]; then
		# Extract Name and install funcion
		IFS=':' read -r programName installFunction <<< "${programs[$choice]}"

		# call the function to install
		$installFunction
	else
		echo " Invalid Choice. Enter The valid program Number"
		AskToInstall
	fi
}

# ########################################### #
# Defining Install Functions For the Programs #
# ########################################### #

#			Katoolin			#
############################### #
installKatoolin()
{
	echo "

		#### Installing Katoolin - (A KALI LINUX TOOLS INSTALLER) ####"
		# shellcheck disable=$C2162
		read -p "Do You Wanto to proceed with katoolin install? [y/n]: " choice1
		if [ "$choice1" == "y" ] || [ "$choice1" == "Y" ]; then
			git clone https://github.com/LionSec/katoolin.git
			sudo cp katoolin/katoolin.py /usr/bin/katoolin
			sudo chmod +x /usr/bin/katoolin
			if [ "$(command -v katoolin)" ]; then
				$apps_installed++
				echo " katoolin Installed Successfully ..."
			else
				echo " ## Error executing 'katoolin', Try Manualy installing it ..."
			fi
		else
			echo " Skipping Katoolin Install ..."
			AskToInstall
		fi
}

#			Snap Store			#
# ############################# #
installSnapStore()
{
	echo "

		#### Installing Snap Store ####"
		# shellcheck disable=#C2162
		read -p "Do you want to proceed with Snap-Store install? [y/n]: " choice2
		if [ "$choice2" == "y" ] || [ "$choice2" == "Y" ]; then
			sudo apt install snapd
			sudo snap install snap-store
			if [ "$(command -v snap-store)" ]; then
				$apps_installed++
				echo "Snap-Store installed Successfully ..."
			else
				echo " ## Error installing Snap-Store ..."
			fi
		else
			echo " Skipping Katoolin Install ..."
			AskToInstall
		fi
}

#			chrome			#
# ######################### #
installChrome()
{
	echo "
	
		#### Installing Chrome ###"
		read -p "Do You want to proceed with chrome install? [y/n] " choice3
		if [ "$choice3" == "y" ] || [ "$choice3" == "Y" ]; then
			echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
			wget -qO - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
			sudo apt update
			#install
			sudo apt install google-chrome-stable -y
			if [ "$(command -v google-chrome)" ]; then
				$apps_installed++
				echo " google-chrome Installed ..."
			else
				echo " ## Error Installing google-chrome"
			fi
		else
			echo " skipping Chrome Install ..."
		fi
}


# start The Script
AskToInstall
