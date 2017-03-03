#! /bin/bash

while true
do
echo "Hostname:   "$(hostname)
echo "IP Address: "$(/sbin/ifconfig | grep "inet addr:" | head -n1 | cut -d: -f2 | cut -d' ' -f1)
echo
echo "Logged-in users:"
echo "----------------"
w
echo
echo "Active Network Connections:"
echo "---------------------------"
netstat -A inet
echo
echo "Recent web server error log:"
echo "----------------------"
tail /var/log/apache2/error.log
sleep 3
clear
done

