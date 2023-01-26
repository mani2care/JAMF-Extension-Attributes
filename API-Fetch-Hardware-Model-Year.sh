#!/bin/sh

#This script is to develop to fetch Hardware Model & year details from end point and populate Custom Model Extension Attribute
# Created by Samstar
# Date - 2nd September 2021
# Edited Manikandan - @mani2care
# Date - 26th Jan -2023


#Define Variables:
jssUser="$4"
jssPass="$5"
serial=$(ioreg -c IOPlatformExpertDevice -d 2 | awk -F\" '/IOPlatformSerialNumber/{print $(NF-1)}')
response=$(curl -s -k -u ${jssUser}:${jssPass} -H "Accept: application/xml" -H "Content-Type: text/xml" https://sanofi.jamfcloud.com/JSSResource/computers/serialnumber/${serial})
jssID=$(echo $response | /usr/bin/awk -F'<id>|</id>' '{print $2}')
#Model=$(defaults read ~/Library/Preferences/com.apple.SystemProfiler.plist 'CPU Names' | cut -sd '"' -f 4 | uniq)


Last4Ser=$(ioreg -rd1 -c IOPlatformExpertDevice | awk -F'"' '/IOPlatformSerialNumber/{print $4}' | tail -c 5)
Last3Ser=$(ioreg -rd1 -c IOPlatformExpertDevice | awk -F'"' '/IOPlatformSerialNumber/{print $4}' | tail -c 4)

#Get the hardware model 
CustomModel=$(curl -s -o - "https://support-sp.apple.com/sp/product?cc=$Last4Ser&lang=en_US" xpath //root/configCode[1] 2>&1 | awk -F'<configCode>|</configCode>' '{print $2}' | sed '/^$/d')

if [[ "$CustomModel" == "" ]]; then
#Get the hardware model 
CustomModel=$(curl -s -o - "https://support-sp.apple.com/sp/product?cc=$Last3Ser&lang=en_US" xpath //root/configCode[1] 2>&1 | awk -F'<configCode>|</configCode>' '{print $2}' | sed '/^$/d')
fi
#Get only year.
mdlyear="$(echo "$CustomModel" | /usr/bin/sed 's/)//;s/(//;s/,//' | /usr/bin/grep -E -o '2[0-9]{3}')"

# get the model name only.
#echo "<result>"$CustomModel"</result>"
echo "<result>"$mdlyear"</result>"
