#!/bin/bash

# Start XML output for Jamf Extension Attribute
echo "<result>"

# Get a list of network services, handling spaces correctly
network_services=$(networksetup -listallnetworkservices | grep -v '*')

# Loop through each network service
while IFS= read -r service; do
    # Get the current IPv6 configuration for the service
    ipv6_status=$(networksetup -getinfo "$service" | grep "IPv6:" | awk '{print $2}')

    # If ipv6_status is empty, treat it as "Link-Local"
    if [[ -z "$ipv6_status" ]]; then
        ipv6_status="Link-Local"
    elif [[ "$ipv6_status" =~ ^(Off|Automatic|Manual)$ ]]; then
        ipv6_status="$ipv6_status"
    else
        # If ipv6_status has any other value or unexpected output, treat it as "Error"
        ipv6_status="Error"
    fi

    echo "$service:$ipv6_status"
done <<< "$network_services"

# Close XML output
echo "</result>"

exit 0
