# Author: hdmn.net
# Purpose: Add leading 0 to single-digit variables, like dates.

:if ($day < 10) do={:set day ("0" . $day)} 
