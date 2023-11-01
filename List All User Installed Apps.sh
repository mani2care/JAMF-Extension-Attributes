#!/bin/zsh
#######################
#
# List_All_User_Installed_Apps.sh v1.2
#
# Finds and lists all installed applications on a Mac within the /Applications/ and /Users/ directories.
#       Short script to list all .app bundles on a Mac using Spotlight to search the contents of the /Applications/ and /Users/ directories.
#       Apple applications are excluded using the com.apple.* bundle identifier.
# Greg Knackstedt
# 6.10.2022
#
######################
#
mdfind -onlyin /Applications/ -onlyin /Users/ '(kMDItemCFBundleIdentifier != "com.apple.*" && kMDItemKind == "Application")' | sort -g
