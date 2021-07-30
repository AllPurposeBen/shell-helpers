#!/bin/bash


urlEscape () {
	local input="$1"
	escaped=$(python - <<- EOP
	import urllib2
	import sys
	reload(sys)
	sys.setdefaultencoding("utf-8")
	print urllib2.quote("$input")
	EOP
	)
	echo "$escaped"
}

urlEscape "$1"