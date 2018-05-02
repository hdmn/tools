# Author: hdmn.net
# Purpose: Set the (secondary) NTP server dynamically. 
#   (NTP implementation from MikroTik RouterOS "extra packages" (NTP server) does not support DNS names.) 

/system ntp client set secondary-ntp="$[:resolve 0.de.pool.ntp.org]";


# OR add a scheduler: 

/system scheduler add interval=1h name=ntp-secondary on-event="/system ntp client set secondary-ntp=\"\$[:resolve 4.de.pool.ntp.org]\";"
