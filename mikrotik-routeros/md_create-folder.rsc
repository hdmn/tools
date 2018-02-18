# Author: hdmn.net
# Purpose: An easy way to create a new directory on a MikroTik Router.
# Caution: Device needs Internet access! You may need to temporarily add some firewall rules: 
#   /ip firewall filter add chain=input protocol=tcp src-port=80 comment="TEMP web access!" place-before=0;
#   /ip firewall filter add chain=output protocol=tcp dst-port=80 comment="TEMP web access!" place-before=0;

/tool fetch http://hdmn.net/mt/md dst-path=FOLDER/tmp; :delay 2; /file remove FOLDER/tmp;
