#!/bin/sh
# If Microsoft Defender for Endpoint is installed, then get app version

if [ -f "/usr/local/bin/mdatp" ]; then
    result=$(mdatp health --field app_version)
    appversion=$(echo "$result" | sed 's/"//g')
    echo "<result>$appversion</result>"
else
    echo "<result>Not-Installed</result>"
fi