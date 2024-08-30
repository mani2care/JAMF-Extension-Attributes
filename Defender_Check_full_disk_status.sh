#!/bin/bash

# Check if Microsoft Defender ATP has full disk access enabled
mdatp_full_disk_access=$(mdatp health --field full_disk_access_enabled)

# Output the result in the format required by Jamf
if [[ "$mdatp_full_disk_access" == "true" ]]; then
    echo "<result>Enabled</result>"
else
    # If the first check does not return "Enabled", perform a secondary check using grep and awk
    mdatp_full_disk_access_secondary=$(mdatp health | grep full_disk_access_enabled | awk -F": " '{print $2}')
    
    if [[ "$mdatp_full_disk_access_secondary" == "true" ]]; then
        echo "<result>Enabled</result>"
    else
        echo "<result>$mdatp_full_disk_access</result>"
    fi
fi