#!/bin/sh
###############################################################
#Script is checking for QualysCloudAgent 
###############################################################
if [ -d /Applications/QualysCloudAgent.app ]; then 
    CylanceVersion=$(/usr/bin/defaults read /Applications/QualysCloudAgent.app/Contents/Info.plist CFBundleShortVersionString)
    # Extract only the version number before the hyphen
    CylanceVersion=$(echo "$CylanceVersion" | cut -d '-' -f 1)
    echo "<result>$CylanceVersion</result>" 
else 
    echo "<result>Not-Installed</result>" 
fi
