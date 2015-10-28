# colors
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
reset=$(tput sgr0)

# icons
checkmark="\xE2\x9C\x93"
warning="\xE2\x9A\xA0"
error="\xE2\x9C\x97"

# helpers todo this should be somewhere else; or rename the settings file into 'common.sh'
function check_rc {
	success_message=$1
	error_message=$2
	if [ $? -eq 0 ]; then
		printf "\n${green}   ${checkmark} $success_message ${reset}\n\n"
	else
		printf "\n${red}   ${error} $error_message ${reset}\n\n"
	fi
}
