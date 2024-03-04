#!/bin/sh
# Returns the "Product Version" of the installed client, if found


if [ -d /Applications/TrendMicroSecurity.app ]; then
    AppVersion=$(defaults read /Applications/TrendMicroSecurity.app/Contents/Info.plist CFBundleShortVersionString)
    echo "<result>$AppVersion</result>"
else
    echo "<result>Not-installed</result>"
fi
exit 0
