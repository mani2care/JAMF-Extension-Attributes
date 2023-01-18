#!/bin/sh
# Reports the installed version of the Nexthink agent, or Not Installed

if [ -f "/Library/Application Support/Nexthink/config.json" ]; then
    tcpStatus=$( grep -i tcp-status /Library/Application\ Support/Nexthink/config.json | cut -d '"' -f4 | cut -d ']' -f3 )
    VERSION=$( /bin/cat /Library/Application\ Support/Nexthink/config.json | grep -i version | cut -d '"' -f4 )
else
    VERSION="Not_Installed"
fi
echo "<result>$VERSION</result>"
