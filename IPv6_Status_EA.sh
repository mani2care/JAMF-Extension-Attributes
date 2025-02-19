#!/bin/bash

# Start XML output for Jamf Extension Attribute
echo "<result>"

# Get a list of network services, handling spaces correctly
network_services=$(networksetup -listallnetworkservices | grep -v '*')

# Loop through each network service
while IFS= read -r service; do
    # Get the current IPv6 configuration for the service
    ipv6_status=$(networksetup -getinfo "$service" | grep "IPv6:" | awk '{print $2}')

    case "$ipv6_status" in
        Off|Automatic|Manual)
            echo "$service:$ipv6_status"
            ;;
        *)
            echo "$service:Link-Local"
            ;;
    esac
done <<< "$network_services"

# Close XML output
echo "</result>"

exit 0
