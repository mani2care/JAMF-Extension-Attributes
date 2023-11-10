#!/bin/bash

# Grabs the expired certificate information
cert_info=$(security find-identity | grep EXPIRED | awk '{gsub(/"/, ""); print $3 "=" $2}' | sort | uniq)

# Check each certificate
IFS=$'\n'
for CompName in $(security find-identity | grep EXPIRED | awk '{gsub(/"/, ""); print $3 }' | sort | uniq); do

    ExpDate=$(/usr/bin/security find-certificate -a -c "$CompName" -p -Z | sed -n 'H; /^SHA-256/h; ${g;p;}' | /usr/bin/openssl x509 -noout -enddate 2>/dev/null | cut -f2 -d= | xargs -I {} sh -c 'if [ -n "{}" ]; then date -jf "%b %e %T %Y %Z" "{}" +"%e-%b-%Y"; fi')

    if [ -z "$ExpDate" ]; then
        echo "<result>Not_expired</result>"
    else
        echo "<result>$CompName=$ExpDate</result>"
    fi
done

exit 0 # Success
