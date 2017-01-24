#!/bin/bash
#Suricata install script
#Author: Hunter Gregal

INSTALLDIR="/opt/suricata"
VER="3.2"
INT="ens33"
ETURL="http://rules.emergingthreats.net/open/suricata/emerging.rules.tar.gz"

#deps
apt-get -y install libpcre3 libpcre3-dbg libpcre3-dev build-essential autoconf automake libtool libnet1-dev libyaml-0-2 libyaml-dev zlib1g zlib1g-dev libcap-ng0 make libmagic-dev libjansson-dev libjansson4 pkg-config libpcap-dev

#Download
mkdir $INSTALLDIR
wget https://www.openinfosecfoundation.org/download/suricata-$VER.tar.gz -O $INSTALLDIR/suricata.tar.gz
tar -zxvf $INSTALLDIR/suricata.tar.gz -C $INSTALLDIR

#Make + install
cd $INSTALLDIR/suricata-$VER
./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var
make
make install-full
ldconfig

#Install oinkmaster to manage rules
apt-get install oinkmaster

#Add Emerging Threats Rules
echo "url = $ETURL" >> /etc/oinkmaster.conf

#configure rules in suricata
mkdir /etc/suricata/rules
cd /etc
oinkmaster -C /etc/oinkmaster.conf -o /etc/suricata/rules
sed -i 's/\/etc\/suricata\/classification\.config/\/etc\/suricata\/rules\/classification\.config' /etc/suricata/suricata.yaml
sed -i 's/\/etc\/suricata\/reference\.config/\/etc\/suricata\/rules\/reference\.config' /etc/suricata/suricata.yaml

#cronjob to update rules daily @ 2:30 AM
export CRONTAB_NOHEADER=N
( crontab -l ; echo "30 2 * * * /usr/sbin/oinkmaster -C /etc/oinkmaster.conf -o /etc/suricata/rules" ) | crontab -

#COMPLETE
echo "Suricata installed at $INSTALLDIR"
echo "Emerging Threat Rules Managed via Oinkmaster"
echo "Rules updated everyday @ 2:30AM"
echo "Logs @ /var/suricata/"
echo "To run suricata as root: suricata -c /etc/suricata/suricata.yaml -i $INT"
