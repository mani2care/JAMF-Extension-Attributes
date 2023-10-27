#!/bin/bash
#############

# Installs collect the iCloudPrivateRelay status 
# Created By : Manikandan @mani2care

# FUNCTIONS # 
#############

#include this self-contained function in your script
function iCloudPrivateRelay(){

	#only for Moneterey and up, 11 and under need not apply
	[ "$(sw_vers -productVersion | cut -d. -f1)" -le 11 ] && return 1
	
	#parent pref domain
	domain="com.apple.networkserviceproxy"
	#key that contains base64 encoded Plist within parent domain
	key="NSPServiceStatusManagerInfo"

	#child key within base64 embedded plist
	childKey="PrivacyProxyServiceStatus"

	#get the top level data from the main domain
	parentData=$(launchctl asuser "$(stat -f %u /dev/console)" sudo -u "$(stat -f %Su /dev/console)" defaults export "${domain}" -)

	#if domain does not exist, fail
	[ -z "${parentData}" ] && return 1

	#export the base64 encoded data within the key as PlistBuddy CF style for grepping (it resists JSON extraction)
	childData=$(/usr/libexec/PlistBuddy -c "print :" /dev/stdin 2>/dev/null <<< "$(plutil -extract "${key}" xml1 -o - /dev/stdin <<< "${parentData}" | xmllint --xpath "string(//data)" - | base64 --decode | plutil -convert xml1 - -o -)")

	#if child key does not exist, fail
	[ -z "${childData}" ] && return 1

	#match the status string, then get the value using awk (quicker than complex walk, this is sufficient), sometimes written in multiple places
	keyStatusCF=$(awk -F '= ' '/'${childKey}' =/{print $2}' <<< "${childData}" | uniq)
	
	#if we have differing results that don't uniq down to one line, throw an error
	[ $(wc -l <<< "${keyStatusCF}") -gt 1 ] && return 2
	
	#if true/1 it is on, 0/off (value is integer btw not boolean)
	[ "${keyStatusCF}" = "1" ] && return 0 || return 1
}

########
# MAIN #
########

#example - one line calling with && and ||
#iCloudPrivateRelay && echo "iCloud Private Relay is: ON" || echo "iCloud Private Relay is: OFF"

#example - multi-line if/else calling
if iCloudPrivateRelay; then
    echo "<result>iCloud Private Relay is: ON</result>"
else
    echo "<result>iCloud Private Relay is: OFF</result>"
fi
