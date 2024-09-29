#!/bin/bash

# Expiry Date | Certificate Name | SHA-256 Hash | Keychain Path

# Output file
output_file="expired_certificates_info.txt"

# Create or clear the output file and add the header
> "$output_file"

# Current date for comparison
current_date=$(date +"%Y-%m-%d")

# Use security command to find all certificates and process each one
/usr/bin/security find-certificate -a -Z | while IFS= read -r line; do
    # Extract the SHA-256 hash
    if [[ $line == *"SHA-256 hash:"* ]]; then 
        sha256=$(echo "$line" | awk '{print $3}')
    fi

    # Extract the certificate name
    if [[ $line == *"alis"* ]]; then 
        cert_name=$(echo "$line" | sed 's/.*"alis"<blob>="\([^"]*\)".*/\1/')
    fi

    # Extract the keychain path
    if [[ $line == *"keychain"* ]]; then 
        keychain_path=$(echo "$line" | awk -F' ' '{print $NF}')
    fi

    # Once we have both the SHA-256 hash and certificate name, fetch the expiry date
    if [[ -n $cert_name && -n $sha256 ]]; then
        expiry_date=$(/usr/bin/security find-certificate -a -c "$cert_name" -p -Z | \
            sed -n 'H; /^SHA-256/h; ${g;p;}' | \
            /usr/bin/openssl x509 -noout -enddate 2>/dev/null | \
            cut -f2 -d= | xargs -I {} sh -c 'if [ -n "{}" ]; then date -jf "%b %e %T %Y %Z" "{}" +"%Y-%m-%d"; fi')

        # Only print if all information is found and if the certificate is expired
        if [[ -n $expiry_date && "$expiry_date" < "$current_date" ]]; then
            # Format expiry date to DD-MMM-YYYY
            formatted_expiry_date=$(date -jf "%Y-%m-%d" "$expiry_date" +"%d-%b-%Y")
            printf "%s | %s | %s | %s\n" "$formatted_expiry_date" "$cert_name" "$sha256" "$keychain_path" >> "$output_file"
        fi

        # Reset variables for the next certificate
        expiry_date=""
        cert_name=""
        sha256=""
        keychain_path=""
    fi
done

# Sort the output file by expiry date (low to high) and save to a temporary file
sorted_file="sorted_expired_certificates_info.txt"
sort -t '|' -k 1 "$output_file" > "$sorted_file"

# Replace the original output file with the sorted file
mv "$sorted_file" "$output_file"

# Check if the output file is empty
if [[ ! -s "$output_file" ]]; then
    echo "No_Certificate_Found" > "$output_file"
fi

# Display output
echo "<result>$(cat "$output_file")</result>"
