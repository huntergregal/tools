#Network Interface
INTERFACE="ens160"

# 1. Delete all existing rules
iptables -F

# 2. Set default chain policies
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

# 3. Block a specific ip-address
#BLOCK_THIS_IP="x.x.x.x"
#iptables -A INPUT -s "$BLOCK_THIS_IP" -j DROP

# 4. Allow ALL incoming SSH
iptables -A INPUT -i $INTERFACE -p tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o $INTERFACE -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT

# 5. Allow incoming SSH only from a specific network
#iptables -A INPUT -i $INTERFACE -p tcp -s 192.168.200.0/24 --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
#iptables -A OUTPUT -o $INTERFACE -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT

# 6. Allow incoming HTTP
iptables -A INPUT -i $INTERFACE -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o $INTERFACE -p tcp --sport 80 -m state --state ESTABLISHED -j ACCEPT

# Allow incoming HTTPS
iptables -A INPUT -i $INTERFACE -p tcp --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o $INTERFACE -p tcp --sport 443 -m state --state ESTABLISHED -j ACCEPT

# 7. MultiPorts (Allow incoming SSH, HTTP, and HTTPS)
iptables -A INPUT -i $INTERFACE -p tcp -m multiport --dports 22,80,443 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o $INTERFACE -p tcp -m multiport --sports 22,80,443 -m state --state ESTABLISHED -j ACCEPT

# 8. Allow outgoing SSH
iptables -A OUTPUT -o $INTERFACE -p tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -i $INTERFACE -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT

# 9. Allow outgoing SSH only to a specific network
#iptables -A OUTPUT -o $INTERFACE -p tcp -d 192.168.101.0/24 --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
#iptables -A INPUT -i $INTERFACE -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT

# 10. Allow outgoing HTTPS/HTTP
iptables -A OUTPUT -o $INTERFACE -p tcp --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -i $INTERFACE -p tcp --sport 443 -m state --state ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o $INTERFACE -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -i $INTERFACE -p tcp --sport 80 -m state --state ESTABLISHED -j ACCEPT

# 11. Load balance incoming HTTPS traffic
#iptables -A PREROUTING -i $INTERFACE -p tcp --dport 443 -m state --state NEW -m nth --counter 0 --every 3 --packet 0 -j DNAT --to-destination 192.168.1.101:443
#iptables -A PREROUTING -i $INTERFACE -p tcp --dport 443 -m state --state NEW -m nth --counter 0 --every 3 --packet 1 -j DNAT --to-destination 192.168.1.102:443
#iptables -A PREROUTING -i $INTERFACE -p tcp --dport 443 -m state --state NEW -m nth --counter 0 --every 3 --packet 2 -j DNAT --to-destination 192.168.1.103:443

# 12. Ping from inside to outside
iptables -A OUTPUT -p icmp --icmp-type echo-request -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-reply -j ACCEPT

# 13. Ping from outside to inside
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
iptables -A OUTPUT -p icmp --icmp-type echo-reply -j ACCEPT

# 14. Allow loopback access
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# 15. Allow packets from internal network to reach external network.
# if eth1 is connected to external network (internet)
# if $INTERFACE is connected to internal network (192.168.1.x)
#iptables -A FORWARD -i $INTERFACE -o eth1 -j ACCEPT

# 16. Allow outbound DNS
iptables -A OUTPUT -p udp -o $INTERFACE --dport 53 -j ACCEPT
iptables -A INPUT -p udp -i $INTERFACE --sport 53 -j ACCEPT

# 17. Allow NIS Connections
# rpcinfo -p | grep ypbind ; This port is 853 and 850
#iptables -A INPUT -p tcp --dport 111 -j ACCEPT
#iptables -A INPUT -p udp --dport 111 -j ACCEPT
#iptables -A INPUT -p tcp --dport 853 -j ACCEPT
#iptables -A INPUT -p udp --dport 853 -j ACCEPT
#iptables -A INPUT -p tcp --dport 850 -j ACCEPT
#iptables -A INPUT -p udp --dport 850 -j ACCEPT

# 18. Allow rsync from a specific network
#iptables -A INPUT -i $INTERFACE -p tcp -s 192.168.101.0/24 --dport 873 -m state --state NEW,ESTABLISHED -j ACCEPT
#iptables -A OUTPUT -o $INTERFACE -p tcp --sport 873 -m state --state ESTABLISHED -j ACCEPT

# 19. Allow MySQL connection only from a specific network
#iptables -A INPUT -i $INTERFACE -p tcp -s 192.168.200.0/24 --dport 3306 -m state --state NEW,ESTABLISHED -j ACCEPT
#iptables -A OUTPUT -o $INTERFACE -p tcp --sport 3306 -m state --state ESTABLISHED -j ACCEPT

# 20. Allow Sendmail or Postfix
#iptables -A INPUT -i $INTERFACE -p tcp --dport 25 -m state --state NEW,ESTABLISHED -j ACCEPT
#iptables -A OUTPUT -o $INTERFACE -p tcp --sport 25 -m state --state ESTABLISHED -j ACCEPT

# 21. Allow IMAP and IMAPS
#iptables -A INPUT -i $INTERFACE -p tcp --dport 143 -m state --state NEW,ESTABLISHED -j ACCEPT
#iptables -A OUTPUT -o $INTERFACE -p tcp --sport 143 -m state --state ESTABLISHED -j ACCEPT
#iptables -A INPUT -i $INTERFACE -p tcp --dport 993 -m state --state NEW,ESTABLISHED -j ACCEPT
#iptables -A OUTPUT -o $INTERFACE -p tcp --sport 993 -m state --state ESTABLISHED -j ACCEPT

# 22. Allow POP3 and POP3S
#iptables -A INPUT -i $INTERFACE -p tcp --dport 110 -m state --state NEW,ESTABLISHED -j ACCEPT
#iptables -A OUTPUT -o $INTERFACE -p tcp --sport 110 -m state --state ESTABLISHED -j ACCEPT
#iptables -A INPUT -i $INTERFACE -p tcp --dport 995 -m state --state NEW,ESTABLISHED -j ACCEPT
#iptables -A OUTPUT -o $INTERFACE -p tcp --sport 995 -m state --state ESTABLISHED -j ACCEPT

# 23. Prevent DoS attack
iptables -A INPUT -p tcp --dport 80 -m limit --limit 25/minute --limit-burst 100 -j ACCEPT

# 24. Port forwarding 422 to 22
#iptables -t nat -A PREROUTING -p tcp -d 192.168.102.37 --dport 422 -j DNAT --to 192.168.102.37:22
#iptables -A INPUT -i $INTERFACE -p tcp --dport 422 -m state --state NEW,ESTABLISHED -j ACCEPT
#iptables -A OUTPUT -o $INTERFACE -p tcp --sport 422 -m state --state ESTABLISHED -j ACCEPT

# 25. Log dropped packets, seperate prefix for inbound and outbound
iptables -N LOG-INPUT
iptables -N LOG-OUTPUT
iptables -A INPUT -j LOG-INPUT
iptables -A OUTPUT -j LOG-OUTPUT
iptables -A LOG-INPUT -m limit --limit 2/min -j LOG --log-prefix "DROPPED-INBOUND: " --log-level 4
iptables -A LOG-OUTPUT -m limit --limit 2/min -j LOG --log-prefix "DROPPED-OUTBOUND: " --log-level 4
iptables -A LOG-INPUT -j DROP
iptables -A LOG-OUTPUT -j DROP

#Monitor dropped outboud packets
#tail -f /var/log/messages | grep --color -E 'DROPPED-OUTBOUND:'

#Monitor dropped inbound packets
#tail -f /var/log/messages | grep --color -E 'DROPPED-INBOUND: '

#Save Iptables
iptables-save > iptables.bak

#Restore IPtables
#iptables-restore < iptables.bak
