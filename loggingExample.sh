#!/bin/bash

## Arg parsing
scriptArgs=("${@}")
argParse () {
  local index=0
  local ret=1
  for arg in ${scriptArgs[@]}; do
    ((index+=1))
    if [[ "$arg" == "$@" ]]; then
      ret=0
      break
    fi
  done
  if [[ $ret -eq 0 ]]; then
    value=${scriptArgs[@]:$index:1}
    if [[ -n "$value" ]] && [[ "$value" != '--'* ]]; then
      echo "$value"
    fi
  fi
  return $ret
}

#######################

pid=$$
[ -z "$PS1" ] && terminal=true || terminal=false

# logging setup
logfile="$HOME/Desktop/testlog.txt"
touch "$logfile"
exec 3>&1 1>>${logfile}

logit () {
  local logEnum="$2"
  local message="$1"
  local logTime=$(date +"%F %T")
  # decide if we're an interactive shell, if not, don't output to console
  if ${terminal}; then
     out='| tee /dev/fd/3' # log file and console
    else
      out='' # log file only
    fi
  # handle a global debug call, overriding what we're passed
  if argParse '--debug'; then
    local logLevel="DEBUG"
  else
    case "$logEnum" in
      '1')
        local logLevel="INFO"
        ;;
      '2')
        local logLevel="WARN"  # config errors
        local out='>&3'
        ;;
      '3')
        local logLevel="ERROR"
        ;;
      '4')
        local logLevel="DEBUG"
        local out='>&3' # Override previous out method, console out only
        ;;
      *)
        # defaults to info
        local logLevel="INFO"
        ;;
    esac
  fi
  # prep logging string
  logString='$logTime - $pid - [$logLevel] - $message'
  eval echo "$logString" "$out"
}

testFun () {
	echo "banana"
}

########

logit "info type message: console and log" 1
logit "warn (config) error type message: console only" 2
logit "error type message console and log" 3
echo "Terminal var: $terminal"
mytest=$(testFun)
