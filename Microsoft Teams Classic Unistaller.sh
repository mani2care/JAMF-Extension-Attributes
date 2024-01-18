#!/bin/bash

# Quit Teams Classic if it's running
if pgrep Microsoft\ Teams\ Classic.app; then
killall "Microsoft Teams Classic.app"
fi

# Remove the Teams Classic app
rm -rf /Applications/Microsoft\ Teams\ Classic.app

# Remove any Teams Classic preferences
rm -rf ~/Library/Preferences/com.microsoft.teamsclassic.plist

# Remove any Teams Classic caches
rm -rf ~/Library/Caches/com.microsoft.teamsclassic

# Remove any Teams Classic logs
rm -rf ~/Library/Logs/com.microsoft.teamsclassic
exit 0
