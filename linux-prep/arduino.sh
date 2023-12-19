#!/bin/bash
#################### Program install and update function #################
# check for program install
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