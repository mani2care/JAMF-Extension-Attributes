#!/bin/bash

# Get a list of installed Java versions and extract only the version numbers
java_versions=$(/usr/libexec/java_home -V 2>&1 | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+' | sort -u -r)
#java_versions=$(/usr/libexec/java_home -V 2>&1 | awk -F/ '/jdk/{print $5}' | sort -u -r)

if [[ -z "$java_versions" ]]; then
  echo "<result>Java not installed</result>"
else
  java=${java_versions//\"/}
  echo "<result>$java</result>"
fi
