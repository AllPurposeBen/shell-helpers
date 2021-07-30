#!/bin/bash

valid_ip() {
	local ip=$1
	local stat=1
	if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
		IFS='.'
		ip=($ip)
		unset IFS
		[[ ${ip[0]} -le 255 && ${ip[1]} -le 255 && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
		stat=$?
	fi
	return $stat
}

for thisIP in $(echo "0.0.0.0 4.5.6.7."); do
	if valid_ip $thisIP; then
		echo "$thisIP is good"
	else
		echo "$thisIP is bad"
	fi
done