#!/bin/sh

if [[ -e /Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin ]]; then
    echo "<result>$(defaults read /Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin/Contents/Info CFBundleShortVersionString)</result>"
        else
    echo "<result>Not_installed</result>"
fi
