#!/bin/bash

# Print the Enabled Login Items & Hidden Login Items 
# Created By : Manikandan @mani2care
# On : 29-Mar-2023


osascript -e 'tell application "System Events" to get the name of every login item whose hidden is false' | sort | while read login_item; do
    echo "<resutl>Enabled Login Items:$login_item</resutl>"
done

osascript -e 'tell application "System Events" to get the name of every login item whose hidden is true' | sort | while read login_item; do
    echo "<resutl>Hidden Login Items:$login_item</resutl>"
done