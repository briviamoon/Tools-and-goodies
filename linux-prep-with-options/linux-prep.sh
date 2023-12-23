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
programs[4]="Arduino:installProgram "arduino""
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

#		Install Any Other Program		#
# ##################################### #
installProgram()
{
	local name_of_program=$1
	local config_file
	local program_url

	if [ "$(command -v $name_of_program)" ]; then
		current_version=$($name_of_program -- version)
		echo "$name_of_program Already Installed (Version $current_version)..."

		# This Attempts to Locate the Url To the source of the app from it configuration file.
		# However I cannot seem To correctly Telll where it.
		# It would be great if I could Do It dynamicaly across the whole system and save on time.
		config_file=$(sudo find ~/.config/ -name "$name_of_program")
		program_url=$(grep "^$name_of_program=" "$config_file" | cut -d'=' -f2)

		if [ -z "$program_url" ]; then
			echo " ## Error Config file not found for $name_of_program"
			return
		fi

		# check For updates
		latest_release=$(curl -s "$program_url")
		if [ "$current_version" != "$latest_release" ]; then
			echo "$name_of_program  $current_release has an update ($latest_release) avilable ..."
			#request User To Update
			read -p " Do You Want To proceed eith $latest_release update? [Y/n]: " user_choice
			if [ "$user_choice" == "y" ] || [ "$user_choice" == "Y" ]; then
				echo " Updating to $latest_release ..."
				sudo apt update "$name_of_program"
			else
				echo " Skipping $name_of_program update ..."
			fi
		else
			echo " $name_of_program is Up to date"
		fi

		# Program Does not Exist SO install
	else
		echo "
			#### Installing $name_of_program ####"
			read -p " Would You Like To proceed with $name_of_program install? [y/n]: " user_choice
			if [ "$user_choice" == "y" ] || [ "$user_choice" == "Y" ]; then
				sudo apt update
				sudo apt-get install "$name_of_program"
				if [ "$(command -v $name_of_program )" ]; then
					install_version=$($name_of_program --version)
					$apps_installed++
					echo " $name_of_program version $install_version Installed Successfully ..."
				else
					echo " ## Error Installing $name_of_program, Try Manualy installing it ..."
				fi
			else
				echo " Skipping $name_of_program Install ..."
			fi
	fi
}

#			MT5			#
# ##################### #
installMT()
{
	echo "
		#### Insyalling MT5 ####"
	read -p "Do You Want to proceed with MT5 Install? [y/n] " user_choice
	if [ "$user_choice" == "y" ] || [ "$user_choice" == "Y" ]; then
		wget https://download.mql5.com/cdn/web/metaquotes.software.corp/mt5/mt5ubuntu.sh
		sudo chmod +x mt5ubuntu.sh
		./mt5ubuntu.sh
		$apps_installed++
	else
		echo "Skpping MT5 install ..."
	fi
}

#		Visual Studio Code		#
# ############################# #
installVsCode()
{
	echo "
		#### Installing Visual studio code IDE ####"
		read -p " Do you wanna proceed with VsCode Install? [y/n] " user_choice
		if [ "$user_choice" == "y" ] || [ "$user_choice" == "Y"  ]; then
			echo " Importing microdoft GPG KEY"
			#Import Microsoft GPG key
			wget -q -O https://packages.microsoft.com/keys/microsoft.asc | grep --dearmor >microsoft.gpg
			sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
			#add VsCode repo
			echo "deb [arch=amd64] http://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
			sudo apt update
			# install Vscode
			sudo apt install code -y
			if [ "$(command -v code)" ]; then
				$app_installed++
				echo " Visial Studio Code Installed Succesfully ..."
			fi
		else
			echo " Skipping VsCode Install ..."
		fi
}
AskToInstall
echo " ## $apps_installed Installed ... 
Find The Downloadable packages in the linux-prep-dump Folder in your desktop"

