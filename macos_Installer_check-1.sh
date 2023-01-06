#!/bin/sh
###############################################################
#Script is checking for mac os Installercheck 
###############################################################
search_path="/Applications/"
test=$(ls /Applications/ | grep "Install macOS*")
if [[ $test == "" ]]; then
    echo "<result>No-Installer</result>" 
else
    echo "<result>$test</result>" 
fi
