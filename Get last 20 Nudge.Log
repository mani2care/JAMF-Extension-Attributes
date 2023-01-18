#!/bin/sh
###############################################################
#Script is designed to return the Nudge logs
###############################################################
if [ -f /private/var/log/Nudge.log ]; then 
Version=$(/usr/bin/grep com.github.macadmins.Nudge /var/log/Nudge.log | /usr/bin/tail -20 | /usr/bin/awk '{ split($2, split_time, "."); $2 = split_time[1]; print }' | /usr/bin/cut -d ' ' -f -2,6-)
echo "<result>$Version</result>" 
else 
	echo "<result>Not-found</result>" 
fi 
exit
