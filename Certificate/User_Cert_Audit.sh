#!/bin/zsh

CERT_NAME=$(sudo profiles -P -o stdout | grep -i -A 20 "User Info" | grep "full_name" | awk -F'=' '{gsub(/^ *| *$/,"",$2); print $2}' | tr -d ';' | tr -d '"' 2>/dev/null)

[ -z "$CERT_NAME" ] && { echo "<result>Name_not_found</result>"; exit 0; }

FOUND=0

dscl . -list /Users UniqueID | awk '$2 >= 500 { print $1 }' | while read -r user; do
    home_dir=$(dscl . -read /Users/"$user" NFSHomeDirectory 2>/dev/null | awk '{print $2}')
    [ -z "$home_dir" ] && continue

    keychain="$home_dir/Library/Keychains/login.keychain-db"
    [ ! -f "$keychain" ] && continue

    if sudo -u "$user" security find-certificate -c "$CERT_NAME" "$keychain" &>/dev/null; then
        FOUND=1
        break
    fi
done

if [ "$FOUND" -eq 1 ]; then
    echo "<result>Cert-Found</result>"
else
    echo "<result>Cert-Notfound</result>"
fi
