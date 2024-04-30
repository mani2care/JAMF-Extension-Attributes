#!/bin/zsh

signInStatus=0

DOMAIN="INSERT_DOMAIN_HERE"

currentUser=$(/usr/bin/stat -f %Su /dev/console)

filePath="/Users/$currentUser/Library/Group Containers/group.com.apple.KerberosExtension/Library/Preferences/group.com.apple.KerberosExtension.plist"

ssoUser=$(/usr/bin/defaults read $filePath "$DOMAIN":userPrincipalName) 2>/dev/null

if [ -n "$ssoUser" ]
then
	signInStatus=1
	/bin/echo "<result>$signInStatus</result>"
else
	/bin/echo "<result>$signInStatus</result>"
fi
