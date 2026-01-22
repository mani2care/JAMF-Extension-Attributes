#!/bin/bash

CERT_NAME=$(profiles -P -o stdout | grep -i -A 20 "User Info" | grep "full_name" | awk -F'=' '{gsub(/^ *| *$/,"",$2); print $2}' | tr -d ';' | tr -d '"' 2>/dev/null)

# If CERT_NAME is empty, return name not found
if [ -z "$CERT_NAME" ]; then
    echo "<result>Name_not_found</result>"
    exit 0
fi

FOUND=0

# Get list of real users (UID >= 500)
users=$(dscl . -list /Users UniqueID | awk '$2 >= 500 { print $1 }')

for user in $users; do
    home_dir=$(dscl . -read /Users/$user NFSHomeDirectory 2>/dev/null | awk '{print $2}')
    
    # Skip if home directory does not exist
    [ ! -d "$home_dir" ] && continue

    keychain_dir="$home_dir/Library/Keychains"

    # Find all keychains
    keychains=$(find "$keychain_dir" -name "*.keychain-db" 2>/dev/null)

    for keychain in $keychains; do
        if sudo -u "$user" security find-certificate -c "$CERT_NAME" "$keychain" &>/dev/null; then
            FOUND=1
            break 2
        fi
    done
done

if [ "$FOUND" -eq 1 ]; then
    echo "<result>Cert-Found</result>"
else
    echo "<result>Cert-Notfound</result>"
fi
