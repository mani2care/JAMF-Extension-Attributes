#!/bin/bash

# List all network ports

PORTS=$(networksetup -listallhardwareports | awk -F': ' '/Hardware Port:/{print $NF}')

# Read the list of network ports and check the IPv6 status of the following network ports:
#
# * Network port names containing the word "Ethernet"
# * Network port names which are a match for the word "Wi-Fi"
# * Network port names which end in the word "LAN"

while read -r PORT; do
    if [[ "$PORT" == *"Ethernet"* || "$PORT" = "Wi-Fi" || "$PORT" = *" LAN" ]]; then
       IPv6Check=$(networksetup -getinfo "$PORT" | awk '/IPv6:/{print $NF}')
         if [[ "$IPv6Check" == "On" ]] || [[ "$IPv6Check" == "Automatic" ]]; then
            IPv6Enabled+=("$PORT")
         fi
    fi
done < <(printf '%s' "$PORTS")

if [[ -n "${IPv6Enabled[@]}" ]]; then
    echo "<result>1</result>"
else
    echo "<result>0</result>"
fi
