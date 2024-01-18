#!/bin/sh
###############################################################
#Script is designed to return the 'version number' of Cylance. Verifies the application exists before returning 'version number' or 'not installed'
###############################################################
if [ -d /Applications/Cylance/CylanceUI.app ]; then 
CylanceVersion=$(/usr/bin/defaults read /Applications/Cylance/CylanceUI.app/Contents/Info.plist CFBundleShortVersionString)
echo "<result>$CylanceVersion</result>" 
else 
    echo "<result>Not found</result>" 
fi 
exit 0
