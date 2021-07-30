#!/bin/bash

### This is a drop in code block and some example cases for handing springing a trap and running some code
#   when a pipefail-set script catches a return or exit other than zero.
#
#   Largely inspired by these 2 sources:
#   https://intoli.com/blog/exit-on-errors-in-bash-scripts/
#   https://unix.stackexchange.com/questions/462156/how-do-i-find-the-line-number-in-bash-when-an-error-occured
#
###

# needs to have pipe fail set
set -e

################################### INSERT THIS BLOCK ###################################

sendPingCheck () {
	# This code determines if the ping is needed, forms the output and then sends the ping
	local thisExitCode=$1
	if [ $thisExitCode -eq 0 ] || [[ $stopChecking == true ]]; then
		return 0
	fi
	local badLine=$2
	local thisType=$3
	# this bit handles changes in messages between a return check or a exit check
	if [[ $thisType == r ]]; then
		# this is a return situation
		local badCommand=$(cat "$0" | awk " NR == $badLine ") # find the line number of the offender
		cat <<- EOM1
		Bad Command: $badCommand
		Command returned: $thisExitCode
		Bad return on line: $badLine
		EOM1
		export stopChecking=true # set this so we don't trigger an exit check on an exit caused by finding a bad return
	else
		# this is an exit situation 
		cat <<- EOM2
		Script exited: $thisExitCode
		Exited from line: $badLine
		EOM2
	fi
}

# echo an error message when we catch an exit other than zero
trap 'lastExit=$?; sendPingCheck ${lastExit} ${LINENO} e' EXIT
# echo an error message when we catch something returning non-zero
trap 'lastReturn=$?; sendPingCheck ${lastReturn} ${LINENO} r' ERR

#################################### EXAMPLES ##########################################

echo "I am a successful command..."

false

# This should trigger the trap
printf --fake "I'm a bad command..."

## Comment the above to try the next thing

badBatch () {
	return 1
}

# since this returns other than 0, it should trigger the trap
badBatch

## Comment the above to try the next thing

# this should trigger the trap since it's an exit other than 0
exit 10

## Comment the above to try the next thing

# this command never gets ran because the trap sprang previously
echo "I only run when everything is ok..."

exit 0 
