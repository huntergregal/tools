#!/bin/bash
#@author JaminB
#Will report any process started after the script is iniciated. 
ps -A | cut -d ':' -f3 | cut -d ' ' -f2 | sort -k2 > snapshot
while true;
do
	current_proc=`ps -A | cut -d ':' -f3 | cut -d ' ' -f2 | sort -k2`
	snapshot_proc=`cat snapshot`
	echo NEW PROCESSES:
	diff -w <(echo "$current_proc") <(echo "$snapshot_proc") > possiblyBad
	i=1
	cat possiblyBad | while read line
	do
		if [ $(( $i%2 )) == 0 ]; then
			echo $line | cut -d '<' -f2
		fi
		(( i=i+1 ))
	done 
	sleep 3
	clear
done
