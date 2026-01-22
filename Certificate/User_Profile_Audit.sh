#!/bin/bash

## check only profile status 

PROFILE_ID="B0959CAA-74CB-A491-7AC271CE4AE4"
LOGGED_IN_USER=$(stat -f%Su /dev/console)

PROFILE_MATCH=$(profiles show -user "$LOGGED_IN_USER" 2>/dev/null \
| grep -i -A 10 "$PROFILE_ID" \
| grep -i "attribute: profileIdentifier:" \
| sed 's/.*attribute: profileIdentifier: //')

if [[ "$PROFILE_MATCH" == "$PROFILE_ID" ]]; then
    echo "<result>Profile-Installed</result>"
    
else
    echo "<result>Profile-Not-Installed</result>"
fi
