#!/bin/sh

###
#
#            Name:  Default Browser.sh
#     Description:  Returns default browser of currently logged-in user.

########## variable-ing ##########



loggedInUser=$(/usr/bin/stat -f%Su "/dev/console")
loggedInUserHome=$(/usr/bin/dscl . -read "/Users/${loggedInUser}" NFSHomeDirectory | /usr/bin/awk '{print $NF}')
defaultBrowser=$(/usr/bin/defaults read "${loggedInUserHome}/Library/Preferences/com.apple.LaunchServices/com.apple.launchservices.secure.plist" LSHandlers | /usr/bin/grep -B1 https | /usr/bin/awk -F\" '/LSHandlerRoleAll/ {print $2}' 2>"/dev/null")



########## main process ##########



# Report result.
echo "<result>${defaultBrowser}</result>"



exit 0
