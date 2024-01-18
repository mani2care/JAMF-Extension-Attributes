#!/bin/sh
###############################################################
#Script is checking for python version 
###############################################################
if [ -f /usr/bin/python ]; then 
py2version=$(/usr/bin/python --version 2>&1 | awk '{ print $2 }')
echo "<result>$py2version</result>" 
    else 
        if [ -f /usr/local/bin/python3 ]; then 
        py3version=$(/usr/local/bin/python3 --version | awk '{print $2}')
        echo "<result>$py3version</result>" 
            else
            echo "<result>Not-Installed</result>" 
        fi
fi 
exit 0
