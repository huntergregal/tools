#!/bin/sh

#Many advanved rootkits will try to prevent detectionby unloading themselves when the 'ldd' command is run.
#This script is designed to be run in the background to permantley unload any of these rootkits
#Effective on vlany -> https://github.com/mempodippy/vlany/wiki/Anti-Detection


while true
do
  ldd /bin/echo
done
