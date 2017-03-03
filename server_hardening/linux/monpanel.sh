#!/bin/bash

if [ $(whoami) != "root" ];then
  echo "THIS SCRIPT MUST BE RUN AS ROOT!"
  exit
fi

find / -name .bashrc > temp4 &
md5sum /etc/passwd /etc/group /etc/profile /etc/sudoers /etc/hosts /etc/ssh/ssh_config /etc/ssh/sshd_config > temp2
ls -a /etc/ /usr/ /sys/ /home/ /bin/ /etc/ssh/ >> temp2
while true;
do	
	netstat -n -A inet | grep ESTABLISHED > temp
	incoming_ftp=$(cat temp | cut -d ':' -f2 | grep "^21" | wc -l)
	outgoing_ftp=$(cat temp | cut -d ':' -f3 | grep "^21" | wc -l)
	
	incoming_ssh=$(cat temp | cut -d ':' -f2 | grep "^22" | wc -l)
	outgoing_ssh=$(cat temp | cut -d ':' -f3 | grep "^22" | wc -l)

	

	outgoing_telnet=$(cat temp | cut -d ':' -f2 | grep "^23" | wc -l)
	incoming_telnet=$(cat temp | cut -d ':' -f3 | grep "^23" | wc -l)

	incoming_telnet=$(cat temp | cut -d ':' -f2 | grep "^^23" | wc -l)
	outgoing_telnet=$(cat temp | cut -d ':' -f3 | grep "^^23" | wc -l)

	
	echo "ACTIVE NETWORK CONNECTIONS:"
	echo "---------------------------"
	if [ $outgoing_telnet -gt 0 ]; then
		echo $outgoing_telnet successful outgoing telnet connection.
	fi
	
	if [ $incoming_telnet -gt 0 ]; then
		echo $incoming_telnet successful incoming telnet session.
	fi

	if [ $outgoing_ssh -gt 0 ]; then
		echo $outgoing_ssh successful outgoing ssh connection.
	fi
	
	if [ $incoming_ssh -gt 0 ]; then
		echo $incoming_ssh successful incoming ssh session.
	fi
	
	
	if [ $outgoing_ftp -gt 0 ]; then
		echo $outgoing_ftp successful outgoing ftp connection.
	fi
	
	if [ $incoming_ftp -gt 0 ]; then
		echo $incoming_ftp successful incoming ftp session.
	fi

	if [ $incoming_ftp -gt 0 ]; then
		echo $incoming_ftp successful incoming ftp session.
	fi
	cat temp
	sleep 5
	clear

	echo "CURRENT LOGIN SESSIONS:"
	echo "-----------------------"
	w
	echo
	echo "RECENT LOGIN SESSIONS:"
	echo "----------------------"
	last | head -n5
	sleep 5
	clear

	sleepingProcs=$(pstree | grep sleep)
	if [[ ! -z "$sleepingProcs" ]];then
	  echo "SLEEP PROCESSES:"
	  echo "----------------"
	  sleep 5
	  clear
	fi

	#Check for changes to important files.
	
	md5sum /etc/passwd /etc/group /etc/profile /etc/sudoers /etc/hosts /etc/ssh/ssh_config /etc/ssh/sshd_config > temp3
	ls -a /etc/ /usr/ /sys/ /home/ /bin/ /etc/ssh/ >> temp3
	fileChanges=$(diff temp2 temp3)
	if [[ ! -z "$fileChanges" ]];then
  	  echo CHANGE TRACKER:
	  echo -e "\n"
	  echo "$fileChanges"
	  sleep 5
	  clear
	fi

	echo "CRON JOBS:"
	echo "Found Cronjobs for the following users:"
	echo "---------------------------------------"
	ls /var/spool/cron/crontabs
	echo
	echo "Cronjobs in cron.d:"
	echo "-------------------"
	ls /etc/cron.d/
	sleep 5
	clear

	echo "ALIASES:"
	echo "--------"
	alias
	echo
	echo ".BASHRC LOCATIONS:"
	echo "------------------"
	cat temp4 | while read line
	do
		echo $line
	done
	sleep 5
	clear

	echo "USERS ABLE TO LOGIN:"
	echo "--------------------"
	grep -v -e "/bin/false" -e "/sbin/nologin" /etc/passwd | cut -d ':' -f1
	sleep 5
	clear

	echo "CURRENT PROCESS TREE:"
	echo "---------------------"
	pstree
	sleep 7
	clear
done

