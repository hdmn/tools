# Author: hdmn.net
# Purpose: Check if a file is present on a MikroTik Router.

:if ([:len [/file find name="disk1/example"]] > 0) do={:put "disk1/example is present!";}
