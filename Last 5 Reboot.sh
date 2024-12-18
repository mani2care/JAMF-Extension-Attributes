#!/bin/bash
​
# Get the last 5 reboot events, extracting formatted dates and times only
last5=$(last reboot | grep -m 5 reboot | awk '{print $3, $4, $5, $6}')
​
# Open the result tag and process each line without adding an extra newline at the start
echo -n "<result>"
​
# Use printf to output each line without adding the leading blank line
while IFS= read -r line; do
    printf "%s\n" "$line"
done <<<"$last5"
​
# Close the result tag
echo "</result>"
​
exit 0
