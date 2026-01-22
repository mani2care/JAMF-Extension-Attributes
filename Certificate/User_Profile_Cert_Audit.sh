#!/bin/zsh

## Created : Manikandan (mani2care)
## 1) #Define your certificate profileIdentifier  
## 2) #Define your $CERT_NAME= your name of the certificate im used to fetch the name from profile 


PROFILE_ID="B0959CAA-74CB-4C26-7AC271CE4AE4" #Define your certificate profileIdentifier here  

########################################
# Get certificate common name / check profile
########################################
get_cert_name() {
    LOGGED_IN_USER=$(stat -f%Su /dev/console)

    PROFILE_MATCH=$(profiles show -user "$LOGGED_IN_USER" 2>/dev/null \
        | grep -i -A 10 "$PROFILE_ID" \
        | grep -i "attribute: profileIdentifier:" \
        | sed 's/.*attribute: profileIdentifier: //')

    if [[ "$PROFILE_MATCH" == "$PROFILE_ID" ]]; then
        echo "Profile-Found"
    else
        echo "Profile-Not-Found"
    fi
}

########################################
# Check if certificate is present in any user keychain
########################################
is_profile_present() {
    CERT_NAME=$(sudo profiles -P -o stdout | grep -i -A 20 "User Info" | grep "full_name" | awk -F'=' '{gsub(/^ *| *$/,"",$2); print $2}' | tr -d ';' | tr -d '"' 2>/dev/null)

    [ -z "$CERT_NAME" ] && { echo "Name_not_found"; return; }

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
        echo "Certificate_Found"
    else
        echo "Certificate_Notfound"
    fi
}

########################################
# Compare results and output final result
########################################
PROFILE_RESULT=$(get_cert_name)
CERT_RESULT=$(is_profile_present)

if [[ "$PROFILE_RESULT" == "Profile-Found" && "$CERT_RESULT" == "Certificate_Found" ]]; then
    echo "<result>Both_Profile_and_Certificate_Found</result>"
elif [[ "$PROFILE_RESULT" == "Profile-Found" && "$CERT_RESULT" == "Certificate_Notfound" ]]; then
    echo "<result>Profile_Found_Certificate_NotFound</result>"
elif [[ "$PROFILE_RESULT" == "Profile-Not-Found" && "$CERT_RESULT" == "Certificate_Found" ]]; then
    echo "<result>Profile_NotFound_Certificate_Found</result>"
else
    echo "<result>Both_Profile_and_Certificate_NotFound</result>"
fi
