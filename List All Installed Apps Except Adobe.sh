#!/bin/zsh
#######################
#
# List_All_Installed_Apps_Except_Adobe.sh v1.3
#
# Finds and lists all installed applications on a Mac.
#       Short script to list all .app bundles on a Mac using Spotlight to search the contents of /Applications/.
#       Apple applications are excluded using the com.apple.* bundle identifier.
#       Adobe applications are excluded using the com.adobe.* bundle identifier.
# Greg Knackstedt
# 6.10.2022
#
######################
#
mdfind -onlyin /Applications/ '(kMDItemCFBundleIdentifier != "com.apple.*" && kMDItemCFBundleIdentifier != "com.adobe.*") && kMDItemKind == "Application"' | sort -g
