#!/bin/bash

# Expiry Date | Certificate Name | SHA-256 Hash | Keychain Path
#20-Jan-2024 | Manikandan R | 40C6326E5B3458F07A1D2E4DDBEF59728A425C92612FA022263C73BA51FEB8E | "/Users/test/Library/Keychains/login.keychain-db" |test 
#20-Jan-2024 | Manikandan R | B6E53632BDC2A20670CEAF2DCA9FFE92BE130DF100D6B3777646D6541921745 | "/Users/test/Library/Keychains/login.keychain-db" |test

# Output file
output_file="/Users/Shared/expired_certificates_info.txt"
sorted_file="/Users/Shared/sorted_expired_certificates_info.txt"

# Ensure the directory and output files have proper permissions for all users
chmod 777 /Users/Shared
touch "$output_file" "$sorted_file"
chmod 666 "$output_file" "$sorted_file"

# Create or clear the output file and add the header
> "$output_file"

# Current date for comparison
current_date=$(date +"%Y-%m-%d")

# Get the currently logged-in user
currentUser=$( echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ { print $3 }' )

# Global check if there is a user logged in
if [ -z "$currentUser" -o "$currentUser" = "loginwindow" ]; then
  echo "No user logged in, cannot proceed"
  exit 1
fi

# Get the current user's UID
uid=$(id -u "$currentUser")

# Convenience function to run a command as the current user
runAsUser() {
    launchctl asuser "$uid" sudo -u "$currentUser" "$@"
}

# Function to process certificates in a given keychain
process_certificates_in_keychain() {
    local keychain="$1"

    # Extract certificates using the security command
    runAsUser security find-certificate -a -Z "$keychain" | while IFS= read -r line; do
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
            expiry_date=$(runAsUser security find-certificate -a -c "$cert_name" -p -Z | \
                sed -n 'H; /^SHA-256/h; ${g;p;}' | \
                openssl x509 -noout -enddate 2>/dev/null | \
                cut -f2 -d= | xargs -I {} sh -c 'if [ -n "{}" ]; then date -jf "%b %e %T %Y %Z" "{}" +"%Y-%m-%d"; fi')

            # Only print if all information is found and if the certificate is expired
            if [[ -n $expiry_date && "$expiry_date" < "$current_date" ]]; then
                # Format expiry date to DD-MMM-YYYY
                formatted_expiry_date=$(date -jf "%Y-%m-%d" "$expiry_date" +"%d-%b-%Y")
                echo "$formatted_expiry_date | $cert_name | $sha256 | $keychain_path |$currentUser" >> "$output_file"
            fi

            # Reset variables for the next certificate
            expiry_date=""
            cert_name=""
            sha256=""
            keychain_path=""
        fi
    done
}

# Get the list of keychains for the current user
keychains=($(runAsUser security list-keychains | tr -d '"' | tr ' ' '\n'))

# Process each keychain for certificates
for keychain in "${keychains[@]}"; do
    process_certificates_in_keychain "$keychain"
done

# Sort the output file by expiry date (low to high) and save to a temporary file
sort -t '|' -k 1 "$output_file" > "$sorted_file"

# Replace the original output file with the sorted file
mv "$sorted_file" "$output_file"

output=$(cat "$output_file")

# Check if the output file is empty
if [[ -s "$output_file" ]]; then
    # Display output
    echo "<result>$output</result>"
else
    echo "<result>No_Certificate_Found</result>"
fi
