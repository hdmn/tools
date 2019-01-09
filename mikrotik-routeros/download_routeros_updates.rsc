# Author: hdmn.net
# Purpose: Download specific Version of RouterOS NPK from MikroTik for use of central upgrade in The Dude.
#   Edit version, platforms and dstpath.
#
# Caution: Device needs Internet access! You may need to temporarily add some firewall rules: 
#   /ip firewall filter add chain=input protocol=tcp src-port=443 comment="TEMP web access!" place-before=0;
#   /ip firewall filter add chain=output protocol=tcp dst-port=443 comment="TEMP web access!" place-before=0;

:local version "6.43.8"
:local platforms {rb2011="mipsbe"; rb3011="arm"; hex="mmips"; ccr="tile"; chr="x86"}
:local dstpath "disk1/dude/files/updates"

:foreach platform in=$platforms do={ 
	:local filename "routeros-$platform-$version.npk"
	/tool fetch url="https://download.mikrotik.com/routeros/$version/$filename" dst-path="$dstpath/$version/$filename";
};

# CCR/tile: NTP
	/tool fetch url="https://download.mikrotik.com/routeros/$version/ntp-$version-tile.npk" dst-path="$dstpath/$version/ntp-$version-tile.npk";
# CHR/x86: Dude + NTP
	/tool fetch url="https://download.mikrotik.com/routeros/$version/dude-$version.npk" dst-path="$dstpath/$version/dude-$version.npk";
	/tool fetch url="https://download.mikrotik.com/routeros/$version/ntp-$version.npk" dst-path="$dstpath/$version/ntp-$version.npk";
