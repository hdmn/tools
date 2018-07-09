# Author: hdmn.net
# Purpose: Download specific Version of RouterOS NPK from MikroTik for use of central upgrade in The Dude
#   Change version and platforms
# Caution: Device needs Internet access! You may need to temporarily add some firewall rules: 
#   /ip firewall filter add chain=input protocol=tcp src-port=443 comment="TEMP web access!" place-before=0;
#   /ip firewall filter add chain=output protocol=tcp dst-port=443 comment="TEMP web access!" place-before=0;

:local version "6.42.5"
:local platforms {rb2011="mipsbe"; rb3011="arm"; hex="mmips"; ccr="tile"}

:foreach platform in=$platforms do={ 
	:local filename "routeros-$platform-$version.npk"
	/tool fetch url="https://download.mikrotik.com/routeros/$version/$filename" dst-path="disk1/dude/files/updates/$version/$filename";
};

