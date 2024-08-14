#!/usr/bin/env bash
#
#Description: EA to check FireEye EndPoint Security HX Agent Version.
#
RESULT="Not_Installed"

if [ -f "/Library/FireEye/xagt/xagt.app/Contents/Info.plist" ] ; then
    RESULT=$( defaults read /Library/FireEye/xagt/xagt.app/Contents/Info CFBundleVersion )
fi

echo "<result>$RESULT</result>"
