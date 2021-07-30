#!/bin/bash


# function returns 0 if flag is present, 1 if it is not
# echo the the value to the argument if there is one, else echo nothing

## version 21.4.0 - Adds ability to use multiple / delimited flags in one call, eg argParse '--test/-t'

# Arg handling function, version 21.4.0
scriptArgs=("${@}")
argParse () {
	local index=0
	local ret=1
	local flag="$1"
	local option="$2"
	for arg in ${scriptArgs[@]}; do
		((index+=1))
		for subArg in $(echo "$flag"); do
			if [[ "$arg" == "$subArg" ]]; then
				#check for a value
				value=${scriptArgs[@]:$index:1}
				if [[ -n "$value" ]] && [[ "$value" != '-'* ]]; then
					vals+=( "$value" )
				fi
				ret=0
			fi
		done
		if [[ "$option" == '__single-match' ]] && [[ $ret -eq 0 ]]; then
			break
		fi
	done
	if [[ -n "$vals" ]]; then
		printf '%s\n' "${vals[@]}"
	fi
	return $ret
}

## Testing, here the arg we're looking for is "--test" or "-t"
if testvar=$(argParse '--test -t'); then
	echo "test flag true"
	if [[ -n "$testvar" ]]; then
		echo "Value: $testvar"
	fi
else
	echo "No --test flag"
fi

## Multiple instances of a flag with a value included will output a variable with each instance on a new line:
