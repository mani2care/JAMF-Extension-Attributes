#!/bin/bash

# List users with UniqueID greater than 500, excluding 'casperadmin' and 'JAMFCONNECT'
users=$(dscl . list /Users UniqueID | awk '$2 > 500 && $1 != "casperadmin" && $1 != "JAMFCONNECT" {print $1}')

# Get OS major and minor version numbers
osvers_major=$(/usr/bin/sw_vers -productVersion | awk -F. '{print $1}')
osvers_minor=$(/usr/bin/sw_vers -productVersion | awk -F. '{print $2}')

# Check if macOS version is 12 or above, or minor version is 13 or above
if [[ ${osvers_major} -ge 12 ]] || [[ ${osvers_minor} -ge 13 ]]; then
    result=$(for each in $users
    do
        stcheck=$(sysadminctl -secureTokenStatus "$each" 2>&1 | awk '{print $7}')
        userstatus="User $each is $stcheck"
        echo "$userstatus"
    done)

    echo "<result>$result</result>"
else
    echo "<result>No_SecureToken</result>"
fi
