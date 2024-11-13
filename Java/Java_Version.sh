#!/usr/bin/env bash

######################################################################################
# Collects information to determine which version of the Java 8 SE JDK is installed  # 
# and returns that version back.  Builds the result as FEATURE.INTERIM.UPDATE        #                                                                          
######################################################################################

PATH_EXPR=/Library/Java/JavaVirtualMachines/jdk1.8*.jdk/Contents/Info.plist
KEY="CFBundleVersion"

RESULTS=()
IFS=$'\n'
for PLIST in ${PATH_EXPR}; do
	VERSION=$(/usr/bin/defaults read "${PLIST}" "${KEY}" 2>/dev/null)
	RESULTS+=( ${VERSION/0_/} )
done
RESULTS=( $(/usr/bin/sort -V -r <<< "${RESULTS[*]}") )
unset IFS

if [[ ${#RESULTS[@]} -eq 0 ]]; then
	/bin/echo "<result>Not_Installed</result>"
else
	/bin/echo "<result>${RESULTS[0]}</result>"
fi

exit 0
