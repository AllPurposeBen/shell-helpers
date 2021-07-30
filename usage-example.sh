#!/bin/bash

usage () {
	fold -s -w $(stty size | awk '{print $2}') <<- EOU
	Placeholder Text
	EOU
	exit 1
}