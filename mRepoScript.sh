#!/bin/zsh

# Variables
eclipsePath=/usr/bin/eclipse
gitAccessMethod='HTTPS'

# Color
RED='\033[1;31m'
CYAN='\033[1;36m'
BLUE='\033[1;34m'
NC='\033[0m'

# DO NOT CHANGE
dirPath=$(mktemp -d)
input=""
repoArr=()
repoNum=""

trap "rm -rf ${dirPath} & exit" INT


execute () {
	mkdir -p ${dirPath}/tmp_workspace
	mkdir -p ${dirPath}/repos

	echo "${CYAN}Which repositories do you want to clone (Format: XX)?${NC}" 
	echo "${RED}End input with entering 'end'!${NC}" 

	while [[ ("${repoNum}" != "end") || ("${repoNum}" == "") ]]
	do
		read repoNum
		if [[ ("${repoNum}" =~ ^[0-9]+$) ]]
		then
			repoArr+=("${repoNum}")	
		else
			if [[ "${repoNum}" != "end" ]]
			then
				echo "User Input must be a number"
			fi
		fi
	done

	for repo in "${repoArr[@]}"
	do
		if [[ "${gitAccessMethod}" == "SSH" || "${gitAccessMethod}" == "ssh" ]]
		then
			echo "${BLUE}Cloning repository ${repo}...${NC}"
			(cd ${dirPath}; git clone -q "git@git.informatik.hs-mannheim.de:PR1_CSB_WS22/Team-${repo}.git") > /dev/null # SSH
			cd ${dirPath}; mv Team-${repo}/PR1-WS22-Stud repos/PR1-WS22-Stud-Team-${repo}; sed -i '/<name>/ s/PR1-WS22-Stud/Team-'${repo}'/' repos/PR1-WS22-Stud-Team-${repo}/.project
			${eclipsePath} -data ${dirPath}/tmp_workspace -nosplash -application org.eclipse.cdt.managedbuilder.core.headlessbuild -import ${dirPath}/repos/PR1-WS22-Stud-Team-${repo} > /dev/null 
		elif [[ "${gitAccessMethod}" == "HTTPS" || "${gitAccessMethod}" == "https" ]]
		then
			echo "${BLUE}Cloning repository ${repo}...${NC}"
			(cd ${dirPath}; git clone -q  "https://git.informatik.hs-mannheim.de/PR1_CSB_WS22/Team-${repo}.git")
			cd ${dirPath}; mv Team-${repo}/PR1-WS22-Stud repos/PR1-WS22-Stud-Team-${repo}; sed -i '/<name>/ s/PR1-WS22-Stud/Team-'${repo}'/' repos/PR1-WS22-Stud-Team-${repo}/.project
			${eclipsePath} -data ${dirPath}/tmp_workspace -nosplash -application org.eclipse.cdt.managedbuilder.core.headlessbuild -import ${dirPath}/repos/PR1-WS22-Stud-Team-${repo} > /dev/null 
		else 
			echo "${RED}You did not choose a valid Git access method. Terminating...${NC}"
			exit
		fi
	done

	(cd ${dirPath}; git clone -q "https://git.informatik.hs-mannheim.de/PR1_CSB_WS22/Team-99.git") > /dev/null # SSH
	cd ${dirPath}; mv Team-99/PR1TUT repos/PR1TUT; sed -i '/<name>/ s/PR1TUT/Team-99/' repos/PR1TUT/.project
	${eclipsePath} -data ${dirPath}/tmp_workspace -nosplash -application org.eclipse.cdt.managedbuilder.core.headlessbuild -import ${dirPath}/repos/PR1TUT > /dev/null 

	echo "${BLUE}Initializing workspace and opening eclipse...${NC}"
	${eclipsePath} -data ${dirPath}/tmp_workspace > /dev/null

}

if [ "$(ps cax | grep eclipse)" = "" ]
then
	while [[ ("${input}" == "Y") ||  ("${input}" == "y") || ("${input}" ==  "") ]]
	do
		execute
		repoArr=()
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
