#!/bin/sh

loggedInUser=$(stat -f%Su /dev/console)

icloudaccount=$( defaults read /Users/$loggedInUser/Library/Preferences/MobileMeAccounts.plist Accounts | grep AccountID | cut -d '"' -f 2)

if [ -z "$icloudaccount" ] 
then
    echo "<result>Null</result>"
else
    echo "<result>$icloudaccount</result>"
fi
