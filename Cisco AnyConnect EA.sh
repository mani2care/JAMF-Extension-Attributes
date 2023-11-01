#!/bin/sh
###############################################################
#Script is designed to return the 'version number' of /Applications/Cisco/Cisco AnyConnect Secure Mobility Client.app/Contents/Info.plist. Verifies the application exists before returning 'version number' or 'not installed'
###############################################################
if [ -d /Applications/Cisco/Cisco\ AnyConnect\ Secure\ Mobility\ Client.app ]; then 
Version=$(/usr/bin/defaults read /Applications/Cisco/Cisco\ AnyConnect\ Secure\ Mobility\ Client.app/Contents/Info.plist CFBundleShortVersionString)
echo "<result>$Version</result>" 
else 
	echo "<result>Not-found</result>" 
fi 
exit 0
