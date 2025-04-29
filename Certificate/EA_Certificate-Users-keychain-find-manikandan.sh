#!/bin/bash

MyCertificate="Manikandan R"

echo "🔍 Searching for certificates named \"$MyCertificate\" with expiry info and hashes..."

# Get list of users with UID >= 500
users=$(dscl . -list /Users UniqueID | awk '$2 >= 500 { print $1 }')

for user in $users; do
    home_dir=$(dscl . -read /Users/$user NFSHomeDirectory | awk '{print $2}')

    if [ -d "$home_dir" ]; then
        keychains_dir="$home_dir/Library/Keychains"
        keychains=$(find "$keychains_dir" -name "*.keychain-db" 2>/dev/null)

        for keychain in $keychains; do
            echo "🔎 Checking keychain: $keychain for user: $user"

            # Search for matching cert and extract needed details
            result=$(sudo -u "$user" security find-certificate -c "$MyCertificate" -a -Z "$keychain" 2>/dev/null)

            if [ -n "$result" ]; then
                echo "✅ Certificate(s) found:"
                
                # Parse and display SHA-1 and SHA-256
                echo "$result" | awk '
                    /SHA-256/ { sha256=$NF }
                    /SHA-1/   { sha1=$NF }
                    /labl/    { name=$0; gsub(/.*="|"/, "", name) }
                    /"labl"/ && name != "" {
                        print "Name: " name
                        print "SHA-256 hash: " sha256
                        print "SHA-1 hash:   " sha1
                        name=sha1=sha256=""
                    }
                '

                # Try printing expiration date
                sudo -u "$user" security find-certificate -c "$MyCertificate" -p "$keychain" 2>/dev/null | \
                openssl x509 -noout -subject -enddate | while read line; do
                    if [[ "$line" == *"Not After"* ]]; then
                        echo "Expiry Date: ${line#*=}"
                    fi
                done

                echo "--------------------------------------------"
            else
                echo "❌ No matching certificate in: $keychain (user: $user)"
            fi
        done
    else
        echo "⚠️ Home directory not found for user: $user"
    fi
done

echo "✅ Certificate scan completed."
