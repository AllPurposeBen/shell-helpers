#!/bin/bash

toggleOScolorMode () {
	# get the current setting, returns either "Dark" or "Light"
	if defaults read -g AppleInterfaceStyle 2>/dev/null; then
		# is currently dark, make light
		setDark=false
	else
		# is light, set dark
		setDark=true
	fi
	# change the setting
	osascript <<- EOS
		tell application "System Events"
			tell appearance preferences
				set dark mode to $setDark  # bool
			end tell
		end tell
	EOS
}

toggleOScolorMode