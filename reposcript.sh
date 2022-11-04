#!/bin/zsh

# Variables
eclipsePath=/Applications/Eclipse.app/Contents/MacOS/eclipse
gitAccessMethod='HTTPS'

# Color
RED='\033[1;31m'
CYAN='\033[1;36m'
BLUE='\033[1;34m'
NC='\033[0m'

# DO NOT CHANGE
dirPath=$(mktemp -d)
input=""

trap "rm -rf ${dirPath} & exit" INT

execute () {
	mkdir -p ${dirPath}/tmp_workspace

	echo -n "${CYAN}Which repository do you want to clone (Format: XX)? ${NC}"; read repoNum
	# echo -e '\033[42;40mWhich Repository do you want to clone? Format: XX\033[0m'

	echo "Cloning repository..."

	if [[ "${gitAccessMethod}" == "SSH" || "${gitAccessMethod}" == "ssh" ]]
	then
		(cd ${dirPath}; git clone -q "git@git.informatik.hs-mannheim.de:PR1_CSB_WS22/Team-${repoNum}.git") > /dev/null # SSH
	elif [[ "${gitAccessMethod}" == "HTTPS" || "${gitAccessMethod}" == "https" ]]
	then
		(cd ${dirPath}; git clone -q "https://git.informatik.hs-mannheim.de/PR1_CSB_WS22/Team-${repoNum}.git") > /dev/null # HTTPS
	else 
	echo
		echo "${RED}You did not choose a valid Git access method. Terminating...${NC}"
		exit
	fi

	echo "Initializing workspace and opening eclipse..."
	${eclipsePath} -data ${dirPath}/tmp_workspace -nosplash -application org.eclipse.cdt.managedbuilder.core.headlessbuild -import ${dirPath}/Team-${repoNum}/PR1-WS22-Stud > /dev/null 
	${eclipsePath} -data ${dirPath}/tmp_workspace > /dev/null

}

if [ "$(ps cax | grep eclipse)" = "" ]
then
	while [[ ("${input}" == "Y") ||  ("${input}" == "y") || ("${input}" ==  "") ]]
	do
		execute
		if [ -d "$dirPath" ];
		then
			rm -rf ${dirPath}
		fi
		echo -n "${CYAN}Do you want to examine another repository? [Y/n]${NC}"
		read input
	done
	exit
else 
	echo "${RED}An Instance of eclipse is still running. Please kill the process and try again${NC}"
fi
