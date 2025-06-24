#!/bin/bash
#
# 20250515h0100
# https://tsurugi-linux.org
 
TIME=$(date +%Y%m%d%H%M%S)
WORKING_DIRECTORY="$HOME/02.computer_vision/04.video2ocr/screenrecord/$TIME"
mkdir -p "$WORKING_DIRECTORY"

x=1
echo -e "You have chosen Screenrecord\nPress ctrl-c to quit"

while [ $x -lt 1000000000 ]
do
	adb shell screenrecord /sdcard/${x}.mp4
	adb pull /sdcard/${x}.mp4 "$WORKING_DIRECTORY"/${x}.mp4
	ls "$WORKING_DIRECTORY"/${x}.mp4
	adb shell rm /sdcard/${x}.mp4
	((x++))
done
