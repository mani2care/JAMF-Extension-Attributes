#!/bin/sh

# Displays whether or not the user has enabled the New Outlook.
# Script will return the info as an extension attribute.

loggedInUser=$( scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }' )

NewOutlook=$(/usr/bin/defaults read /Users/$loggedInUser/Library/Containers/com.microsoft.Outlook/Data/Library/Preferences/com.microsoft.Outlook.plist IsRunningNewOutlook)

if [ $NewOutlook -eq 1 ]; then
 echo "<result>New Outlook</result>"

else echo "<result>Old Outlook</result>"

fi
