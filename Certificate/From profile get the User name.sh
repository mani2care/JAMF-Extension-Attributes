#!/bin/zsh

CERT_NAME=$(sudo profiles -P -o stdout | grep -i -A 20 "User Info" | grep "full_name" | awk -F'=' '{gsub(/^ *| *$/,"",$2); print $2}' | tr -d ';' | tr -d '"' 2>/dev/null)

# Check if CERT_NAME is found

if [ -n "$CERT_NAME" ]; then
    echo "<result>$CERT_NAME</result>"
else
    echo "<result>Name_not_found</result>"
fi
