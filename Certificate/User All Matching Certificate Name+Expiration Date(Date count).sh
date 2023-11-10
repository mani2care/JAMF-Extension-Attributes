#!/bin/bash

# Grabs all certificate information
cert_info=$(security find-identity | grep -v expired | awk -F '"' '/./ {print $2}' | awk 'NF')

# Check each certificate
IFS=$'\n'
output=""
current_date=$(date +"%s")

for CompName in $cert_info; do
    ExpDate=$(/usr/bin/security find-certificate -a -c "$CompName" -p -Z | sed -n 'H; /^SHA-256/h; ${g;p;}' | /usr/bin/openssl x509 -noout -enddate 2>/dev/null | cut -f2 -d= | xargs -I {} sh -c 'if [ -n "{}" ]; then date -jf "%b %e %T %Y %Z" "{}" +"%e-%b-%Y"; fi')
    
    if [ -z "$ExpDate" ]; then
        result="Not_expired"
    else
        exp_date_unix=$(date -j -f "%d-%b-%Y" "$ExpDate" +"%s")
        days_until_expiry=$(( ($exp_date_unix - $current_date) / 86400 ))

        if [ "$days_until_expiry" -ge 0 ]; then
            result="$CompName=$ExpDate (+$days_until_expiry days)"
        else
            result="$CompName=$ExpDate (-$((-1 * $days_until_expiry)) days)"
        fi
    fi

    output="$output$result\n"
done

echo -e "<result>$output</result>"
exit 0 # Success
