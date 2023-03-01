#!/bin/bash

# Get a list of installed Java versions
java_versions=$(/usr/libexec/java_home -V 2>&1 | sed '/^$/d;1d;$d')

if [[ "$java_versions" == *"Please visit http://www.java.com for information on installing Java."* ]]; then
  echo "<result>Java not installed</result>"
else
  echo "<result>$java_versions</result>"
fi
exit 0
