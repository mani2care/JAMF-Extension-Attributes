#!/bin/sh
###############################################################
#Script is designed to return the jamf logs
###############################################################
if [ -f /private/var/log/jamf.log ]; then 
Version=$(tail -n 300 /private/var/log/jamf.log)
echo "<result>$Version</result>" 
else 
	echo "<result>Not-found</result>" 
fi 
exit
