#!/bin/sh

##Get the wireless port ID
WirelessPort=$(/usr/sbin/networksetup -listallhardwareports | /usr/bin/awk '/Wi-Fi|AirPort/{getline; print $NF}')

##What SSID is the machine connected to
SSID=$(/usr/sbin/ipconfig getsummary "$WirelessPort" | /usr/bin/awk -F ' SSID : ' '/ SSID : / {print $2}')

echo "<result>$SSID</result>"
