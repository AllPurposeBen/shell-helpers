#!/bin/bash

# Detect an app using active display assertion. Basically looking for an app running that's holding the screen from sleeping, like a presentation.
# Inspired from: https://github.com/Installomator/Installomator/blob/0ff286b7017dd7baf6a6cfc953a44b65d9d0ef78/Installomator.sh#L1144
# returning 0 == no apps, returning 1 == app running and echos the names of the apps
hasDisplaySleepAssertion() {
	# Get the names of all apps with active display sleep assertions
	local apps=''
	apps="$(/usr/bin/pmset -g assertions | /usr/bin/awk '/NoDisplaySleepAssertion | PreventUserIdleDisplaySleep/ && match($0,/\(.+\)/) && ! /coreaudiod/ {gsub(/^.*\(/,"",$0); gsub(/\).*$/,"",$0); print};')"

	if [[ ! "${apps}" ]]; then
		# No display sleep assertions detected
		return 0
	else
		# something is holding the display
		echo "$apps"
		return 1
	fi
}
