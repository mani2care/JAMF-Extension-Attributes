#!/bin/bash
# very simple Extension Attribute to collect Bootstrap information
# copy script to an EA in Jamf Pro Settings -> Computer -> Extension Attribute
# EA input type: script
# 28th of January 2020 
bootstrap=$(profiles status -type bootstraptoken)
if [[ $bootstrap == *"escrowed to server: YES"* ]]; then
	echo "YES, Bootstrap escrowed"
 	result="YES"
else
	echo "NO, Bootstrap not escrowed"
	result="NO"
fi
echo "<result>$result</result>"
