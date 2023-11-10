#!/bin/bash

# Grabs the all certificate information
#cert_info=$(security find-identity | grep EXPIRED | awk '{gsub(/"/, ""); print $3 "=" $2}' | sort | uniq)
#cert_name=$(security find-identity | grep EXPIRED | awk '{gsub(/"/, ""); print $3}' | sort | uniq)
cert_name=$(security find-identity | grep -v expired | awk -F '"' '/./ {print $2}' | awk 'NF')

# Check each certificate
IFS=$'\n'
output=""
for CompName in $cert_name; do
    ExpDate=$(/usr/bin/security find-certificate -a -c "$CompName" -p -Z | sed -n 'H; /^SHA-256/h; ${g;p;}' | /usr/bin/openssl x509 -noout -enddate 2>/dev/null | cut -f2 -d= | xargs -I {} sh -c 'if [ -n "{}" ]; then date -jf "%b %e %T %Y %Z" "{}" +"%e-%b-%Y"; fi')

    if [ -z "$ExpDate" ]; then
        result="Not_expired"
    else
        result="$CompName=$ExpDate"
    fi

    output="$output$result\n"
done

echo -e "<result>$output</result>"
exit 0 # Success
