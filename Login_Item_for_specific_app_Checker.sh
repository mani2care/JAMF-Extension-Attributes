#!/bin/bash

# Specify the names of the applications that you want to check are in Enabled login items enable or not.
# You can add or remove app names from the array as needed.

# Created By : Manikandan @mani2care
# On : 29-Mar-2023

appnames=("Microsoft Teams" "Android File Transfer Agent" "SpeechSynthesisServer")

for appname in "${appnames[@]}"
do
  if osascript -e "tell application \"System Events\" to get the name of every login item whose name is \"${appname}\" and hidden is false" | grep -q "${appname}"; then
      echo "<result>${appname} is in Enabled Login Items</result>"
  elif osascript -e "tell application \"System Events\" to get the name of every login item whose name is \"${appname}\" and hidden is true" | grep -q "${appname}"; then
      echo "<result>${appname} is in Hidden Login Items</result>"
  else
      echo "<result>${appname} is not found</result>"
  fi
done
