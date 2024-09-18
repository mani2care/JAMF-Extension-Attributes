#!/bin/bash

# Get current user
current_user=$(ls -l /dev/console | awk '{print $3}')

# Chrome Extensions
chrome_extensions=$(find "/Users/$current_user/Library/Application Support/Google/Chrome" -name "Extensions" -exec find {} -name "manifest.json" \; | xargs grep '"name"' | cut -d'"' -f4)

# Firefox Extensions
firefox_profile=$(find "/Users/$current_user/Library/Application Support/Firefox/Profiles" -name "*.default-release")
firefox_extensions=$(grep -o '"name":\s*"[^"]*"' "$firefox_profile/extensions.json" | cut -d'"' -f4)

# Safari Extensions (Safari 13+)
safari_extensions=$(defaults read "/Users/$current_user/Library/Safari/Extensions/Extensions.plist" | grep -A1 "Bundle Directory Name" | grep -v "Bundle Directory Name" | awk '{print $3}')

# Output for Jamf as XML
echo "<result>"
echo "Chrome Extensions:"
echo "$chrome_extensions"
echo ""
echo "Firefox Extensions:"
echo "$firefox_extensions"
echo ""
echo "Safari Extensions:"
echo "$safari_extensions"
echo "</result>"

exit 0