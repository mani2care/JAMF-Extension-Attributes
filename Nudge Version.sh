#!/bin/sh
# Returns the "Product Version" of the installed client, if found

if [ -d /Applications/Utilities/Nudge.app ]; then
    AppVersion=$(defaults read /Applications/Utilities/Nudge.app/Contents/Info.plist CFBundleShortVersionString)
    echo "<result>$AppVersion</result>"
else
    echo "<result>Not-installed</result>"
fi
exit
