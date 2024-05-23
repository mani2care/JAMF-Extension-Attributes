#!/bin/sh
# If Microsoft Defender for Endpoint is installed, then get app version

if [ -d "/Applications/Microsoft Defender.app" ]; then
    AppVersion=$(defaults read /Applications/Microsoft\ Defender.app/Contents/Info.plist CFBundleShortVersionString)
    echo "<result>$AppVersion</result>"
else
    echo "<result>Not-installed</result>"
fi