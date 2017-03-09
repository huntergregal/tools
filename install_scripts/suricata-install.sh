#!/bin/bash
#Suricata install script
#Author: Hunter Gregal

#CONFIG
INSTALLDIR="/opt"
INT="ens32"
IP="192.168.2.75"
#SURICATA
SURICATA_VER="3.2"
#ELASTICSEARCH
#KIBANA
HTUSER="admin"
HTPASSWD="admin"

#deps
apt-get -y install libpcre3 libpcre3-dbg libpcre3-dev build-essential autoconf automake libtool libnet1-dev libyaml-0-2 libyaml-dev zlib1g zlib1g-dev libcap-ng0 make libmagic-dev libjansson-dev libjansson4 pkg-config libpcap-dev tmux vim software-properties-common

#suricata
if [ ! -d "/etc/suricata" ]
	then
		echo 'Suricata NOT installed.....installing...'
		#Download
		cd $INSTALLDIR
		wget https://www.openinfosecfoundation.org/download/suricata-$SURICATA_VER.tar.gz -O $INSTALLDIR/suricata.tar.gz
		tar -zxvf $INSTALLDIR/suricata.tar.gz

		#Make + install
		cd $INSTALLDIR/suricata-$SURICATA_VER
		./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var
		make
		make install-full
		ldconfig
fi

#SETUP SCIRIUS
if [ ! -d "$INSTALLDIR/scirius" ]
	then
		apt-get install python-pip python-dev git
		pip install pynotify gitdb gitpython==0.3.1-beta2
		cd $INSTALLDIR
		git clone https://github.com/StamusNetworks/scirius
		cd scirius
		pip install -r requirements.txt
		sed -i "s/ALLOWED_HOSTS\ =\ \[\]/ALLOWED_HOSTS\ =\ \[\"$IP\"\]/g" /opt/scirius/scirius/settings.py
		sed -i "s/rule-files:/rule-files:\n - scirius.rules/g" /etc/suricata/suricata.yaml
fi

#Java install for Elasticsearch
echo 'Installing / Updating Java...'
add-apt-repository ppa:webupd8team/java
apt-get update
apt-get install oracle-java8-installer

#SETUP ELASTICSEARCH
if [ ! -d "/etc/elasticsearch" ]
	then
		wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
		echo "deb http://packages.elastic.co/elasticsearch/2.x/debian stable main" | sudo tee -a /etc/apt/sources.list.d/elasticsearch-2.x.list
		apt-get update
		apt-get -y install elasticsearch
		sed -i "s/#\ network\.host\:\ 192\.168\.0\.1/network\.host\:\ localhost/g" /etc/elasticsearch/elasticsearch.yml
		#elastic search on boot
		update-rc.d elasticsearch defaults 95 10
		
		#start, sleep 5 seconds, create index for suricata
		service elasticsearch restart

fi

#SETUP KIBANA w/ nginx proxy
if [ ! -d "/opt/kibana" ]
	then
		echo "deb http://packages.elastic.co/kibana/4.4/debian stable main" | sudo tee -a /etc/apt/sources.list.d/kibana-4.4.x.list
		apt-get update
		apt-get -y install kibana
		#localhost only
		sed -i "s/server\.host\:\ \"0\.0\.0\.0\"/server\.host\:\ \"localhost\"/g" /opt/kibana/config/kibana.yml
		#on boot
		update-rc.d kibana defaults 96 9

		#Nginx proxy security
		apt-get install -y nginx apache2-utils
		htpasswd -c -b /etc/nginx/htpasswd.users $HTUSER $HTPASSWD
		mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak
		echo 'server {
    listen 80;

    server_name kibana.local;

    auth_basic "Restricted Access";
    auth_basic_user_file /etc/nginx/htpasswd.users;

    location / {
        proxy_pass http://localhost:5601;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}' > /etc/nginx/sites-available/default
fi

#Install Logstash
if [ ! -d "/etc/logstash" ]
	then
		echo 'deb http://packages.elastic.co/logstash/2.2/debian stable main' | sudo tee /etc/apt/sources.list.d/logstash-2.2.x.list
		apt-get update
		apt-get install logstash
		#onboot
		update-rc.d logstash defaults 96 9
fi
if [ ! -e "/etc/logstash/01-suricata-eve.conf" ]
	then
		#configure suricata eve.json listener to elasticsearch
		echo $'input {
  file { 
    path => ["/var/log/suricata/*.json"]
    #sincedb_path => ["/var/lib/logstash/"]
    sincedb_path => ["/var/cache/logstash/sincedbs/since.db"]
    codec =>   json 
    type => "SELKS" 
  }

}

filter {
  if [type] == "SELKS" {
    
    date {
      match => [ "timestamp", "ISO8601" ]
    }
    
    ruby {
      code => "if event[\'event_type\'] == \'fileinfo\'; event[\'fileinfo\'][\'type\']=event[\'fileinfo\'][\'magic\'].to_s.split(\',\')[0]; end;"
    }
  
    metrics {
      meter => [ "eve_insert" ]
      add_tag => "metric"
      flush_interval => 30
    }
  }

  if [http] {
    useragent {
       source => "[http][http_user_agent]"
       target => "[http][user_agent]"
    }
  }
  if [src_ip]  {
    if [src_ip] !~ ":" {
      mutate {
        add_field => [ "[src_ip4]", "%{src_ip}" ]
      }
    }
    geoip {
      source => "src_ip" 
      target => "geoip" 
      #database => "/opt/logstash/vendor/geoip/GeoLiteCity.dat" 
      add_field => [ "[geoip][coordinates]", "%{[geoip][longitude]}" ]
      add_field => [ "[geoip][coordinates]", "%{[geoip][latitude]}"  ]
    }
    mutate {
      convert => [ "[geoip][coordinates]", "float" ]
    }
    if ![geoip.ip] {
      if [dest_ip]  {
        geoip {
          source => "dest_ip"
          target => "geoip"
          #database => "/opt/logstash/vendor/geoip/GeoLiteCity.dat"
          add_field => [ "[geoip][coordinates]", "%{[geoip][longitude]}" ]
          add_field => [ "[geoip][coordinates]", "%{[geoip][latitude]}"  ]
        }
        mutate {
          convert => [ "[geoip][coordinates]", "float" ]
        }
      }
    }
  }
  if [dest_ip] {
    if [dest_ip] !~ ":" {
      mutate {
        add_field => [ "[dest_ip4]", "%{dest_ip}" ]
      }
    }
  }
}

output {
  if [event_type] and [event_type] != \'stats\' {
    elasticsearch {
      hosts => "127.0.0.1"
      index => "logstash-%{event_type}-%{+YYYY.MM.dd}"
    }
  } else {
    elasticsearch {
      hosts => "127.0.0.1"
      index => "logstash-%{+YYYY.MM.dd}"
    }
  }
}' > /etc/logstash/conf.d/01-suricata-eve.conf
fi


#RUN SERVICES
#Run Scirius server
killall python
cd $INSTALLDIR/scirius
python manage.py syncdb
python manage.py runserver $IP:8000 &
echo '#!/bin/sh' > ~/run-scirius-server.sh
echo 'python manage.py runserver $IP:8000 &' >> ~/run-scirius-server.sh

#Run suricata w/ config
kill -9 `ps aux | grep "suricata" | head -n 1 |cut -d' ' -f 6`
suricata -c /etc/suricata/suricata.yaml -i $INT &

#Run elasticsearch
service elasticsearch restart
#run kibana
service kibana restart
#nginx
service nginx restart
#logstash
service logstash restart

echo 'RESTARTING SERVICES - 30 SECONDS'
sleep 30

#Install templates
if [ ! -d "/opt/KTS" ]
	then
		cd /opt
		git clone  https://github.com/StamusNetworks/KTS.git
		chmod -R 777 KTS
		cd KTS
		bash load.sh
fi
#fix perms error
chmod 755 /var/log/suricata/eve.json

##Elasticsearch API calls - START

#Fix node replications error - set replication to 0
curl -XPUT 'localhost:9200/_all/_settings' -d '{"number_of_replicas": 0}'

##Elasticsearch API calls - END

#COMPLETE
echo 'SERVICES'
service --status-all | grep -E 'elasticsearch|logstash|kibana|nginx'
echo 'LISTENERS (all)'
netstat -tulpn
echo ''
echo "Run suricata w/ suricata -c /etc/suricata/suricata.yaml -i $INT &"
echo "Emerging Threat Rules Managed via Scirius"
echo "Logs @ /var/suricata/"
echo "Logstash confs @ /etc/logstash"
echo "Scirius at http://$IP:8000"
echo "Kibana @ http://$IP using creds $HTUSER:$HTPASSWD"


