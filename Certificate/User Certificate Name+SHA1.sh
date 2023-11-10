#!/bin/bash

# Grabs the expired certificate information
cert_info=$(security find-identity | grep EXPIRED | awk '{gsub(/"/, ""); print $3 "=" $2}' | sort | uniq)

if [ -z "$cert_info" ]; then
    echo "<result>Not_expired</result>"
else
    echo "<result>$cert_info</result>"
fi

exit 0 # Success
