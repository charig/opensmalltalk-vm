#!/usr/bin/env bash
set -e
set +v

source envvars.sh

if [ "$1" = -vm -a -n "$2" -a -x "`which "$2"`" ]; then
	VM="$2"
else
	case $OS in
	Darwin) 
		RELEASE=`find . -name 'squeak.cog.spur_macos64x64_*' | head -n 1 | sed -E "s/\.\/squeak.cog.spur_macos64x64_(.*).dmg/\1/"`
		VM=Squeak64.$RELEASE.app
		VM=$VM/Contents/MacOS/Squeak;;
	Linux) # This needs to be split by $CPU to work on RPi also
		# TODO: Adapt the sed command to linux squeak version
		RELEASE=`find . -name 'squeak.cog.spur_macos64x64_*' | head -n 1 | sed -E "s/\.\/squeak.cog.spur_macos64x64_(.*).dmg/\1/"`
		VM=sqlinux.$RELEASE
		VM=$VM/squeak;;
	esac
fi