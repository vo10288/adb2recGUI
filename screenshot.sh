#!/bin/bash
#
# 20250515h0100
# https://tsurugi-linux.org 


TIME=$(date +%Y%m%d%H%M%S)
BASE_DIRECTORY="${HOME}/02.computer_vision/04.video2ocr"
WORKING_DIRECTORY="${BASE_DIRECTORY}/screenshot/${TIME}"

mkdir -p "${WORKING_DIRECTORY}"

x=1
echo -e "You have chosen Screenshot option\nPress ctrl-c to quit"

while [ $x -lt 1000000000 ]
do
	adb exec-out screencap -p > "${WORKING_DIRECTORY}"/${x}.png
	# up
	if [[ "$1" == 'up' ]]; then 
		adb shell input touchscreen swipe 300 300 500 1000
	fi

	# down
	if [[ "$1" == 'down' ]]; then 
		adb shell input touchscreen swipe 500 800 300 300
	fi

	cp "${WORKING_DIRECTORY}"/${x}.png "${BASE_DIRECTORY}"/temp.png
	ls "${WORKING_DIRECTORY}"/${x}.png
	cp "${BASE_DIRECTORY}"/temp.png "${BASE_DIRECTORY}"/temp1.png
	((x++))
done
