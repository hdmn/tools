# Author: hdmn.net
# Purpose: Get the current IP address of an interface and pass them to an HTTP-API for simple DynDNS.
#   Change url and interface (2x)! 
# Caution: Device needs Internet access! You may need to temporarily add some firewall rules: 
#   /ip firewall filter add chain=input protocol=tcp src-port=443 comment="TEMP web access!" place-before=0;
#   /ip firewall filter add chain=output protocol=tcp dst-port=443 comment="TEMP web access!" place-before=0;

/tool fetch mode=https url="https://hdmn.net/dyndns/index.php\?host=$[/system identity get name]&ip=$[:pick "$[/ip address get [/ip address find interface=pppoe-out1] address]" 0 [:find [/ip address get [/ip address find interface=pppoe-out1] address] "/"]]" keep-result=no
