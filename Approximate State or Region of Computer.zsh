#!/bin/zsh
#
# Gets the approximated State or Region the system is currently physically locatted in by using its current external facing IP
# based on ip-api.com
####################################
#
# Get the current external IP address
myIP=$(curl -L -s --max-time 10 http://checkip.dyndns.org | egrep -o -m 1 '([[:digit:]]{1,3}.){3}[[:digit:]]{1,3}')
# Use the IP address to identify the current State or Region
State=$(curl -L -s --max-time 10 "http://ip-api.com/line/$myIP?fields=regionName")
#
# Display the results in a format that can be used as an extension attribute
echo "<result>$State</result>"
