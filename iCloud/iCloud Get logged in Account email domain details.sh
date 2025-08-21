#!/bin/bash

# Script for: iCloud Account Type (Jamf Extension Attribute)
# Author: Manikandan R
# Purpose: Fetch all Apple ID accounts from MobileMeAccounts.plist and classify as Company or Personal
# Output: Personal:xxx.gmail.com

# Get the currently logged-in user
CURRENT_USER=$(stat -f "%Su" /dev/console)

Domain="company.com"
# Get user's home directory
USER_HOME=$(dscl . -read "/Users/$CURRENT_USER" NFSHomeDirectory 2>/dev/null | awk '{print $2}')

# Path to plist
PLIST="$USER_HOME/Library/Preferences/MobileMeAccounts.plist"

# Check if plist exists
if [[ ! -f "$PLIST" ]]; then
    echo "<result>iCloud Account not found</result>"
    exit 0
fi

# Get the number of accounts
ACCOUNT_COUNT=$(/usr/libexec/PlistBuddy -c "Print :Accounts" "$PLIST" 2>/dev/null | grep "Dict" | wc -l)

if [[ "$ACCOUNT_COUNT" -eq 0 ]]; then
    echo "<result>iCloud Account not found</result>"
    exit 0
fi

# Prepare result string
RESULTS=()

# Loop through each account index
for (( i=0; i<ACCOUNT_COUNT; i++ )); do
    ID=$(/usr/libexec/PlistBuddy -c "Print :Accounts:$i:AccountID" "$PLIST" 2>/dev/null)
    ID=${ID:-""}

    if [[ -z "$ID" || "$ID" != *@* ]]; then
        continue
    fi

    DOMAIN="${ID##*@}"

    if [[ "$DOMAIN" == *"$Domain"* ]]; then
        RESULTS+=("$Domain:XXX@$DOMAIN")
    else
        RESULTS+=("Personal:XXX@$DOMAIN")
    fi
done

# Final output
if [[ ${#RESULTS[@]} -eq 0 ]]; then
    echo "<result>iCloud Account not found</result>"
else
    echo "<result>${RESULTS[*]}</result>"
fi
