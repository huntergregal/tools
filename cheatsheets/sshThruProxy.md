#Tunnel SSH through a Proxy (aka tor hehe)
* apt-get install tor connect-proxy
* service start tor
* Top of ~/.ssh/config
```
Host *
CheckHostIP no
Compression yes
Protocol 2
ProxyCommand connect -4 -S localhost:9050 $(tor-resolve %h localhost:9050) %p
```
