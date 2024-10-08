#!/bin/bash

# Purpose: Check iCloud Drive status and its Desktop/Documents sync settings for the logged-in user.

# Get the logged-in user
loggedInUser=$(scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }')

# Check the iCloud Drive enabled status
iCloudDriveEnabled=$(defaults read /Users/"$loggedInUser"/Library/Preferences/com.apple.finder.plist FXICloudDriveEnabled 2>/dev/null)

if [[ "$iCloudDriveEnabled" == "1" ]]; then
    # If iCloud Drive is enabled, check Desktop and Documents sync
    iCloudDesktop=$(defaults read /Users/"$loggedInUser"/Library/Preferences/com.apple.finder.plist FXICloudDriveDesktop 2>/dev/null)
    iCloudDocuments=$(defaults read /Users/"$loggedInUser"/Library/Preferences/com.apple.finder.plist FXICloudDriveDocuments 2>/dev/null)

    if [[ "$iCloudDesktop" == "1" ]] && [[ "$iCloudDocuments" == "1" ]]; then
        syncStatus="iCloud_Drive_Desktop-and-Documents_Enabled"
    else
        syncStatus="iCloud_Drive_Desktop-and-Documents_Disabled"
    fi
else
    syncStatus="iCloud_Drive-sync_Disabled"
fi

# Output the result
/bin/echo "<result>$syncStatus</result>"