#!/bin/sh

##Break maK_it 
# https://github.com/maK-/maK_it-Linux-Rootkit
rm -rf /dev/.maK_it

##Break Colonel
#https://github.com/bones-codes/the_colonel
# kill irc bot
echo -n sp >> /proc/colonel
echo -n sp >> /proc/colonel
sudo pkill -f col_bot

# remove keylogger
cd lkm/
sudo killall col_kl
sudo rm col_kl

# cleanup the rootkit
echo -n ms >> /proc/colonel
sudo rmmod rootkit

##Break Diamorphine
#https://github.com/m0nad/Diamorphine
#make visible
kill -63 0
#unload
rmmod diamorphine


##Many advanved rootkits will try to prevent detectionby unloading themselves when the 'ldd' command is run.
#This script is designed to be run in the background to permantley unload any of these rootkits

#Effective on vlany -> https://github.com/mempodippy/vlany/wiki/Anti-Detection

while true
do
  ldd /bin/echo
done
