#!/bin/bash

# This extension attribute lists the installed Java JDKs and their respective vendors and versions.

result="<result>"

# Get the paths to all installed JDKs using the ls command
jdk_paths=$(ls /Library/Java/JavaVirtualMachines)

for jdk_path in $jdk_paths; do

    vendor=""
    version=""
    
    # Get vendor
    if echo "$jdk_path" | grep -qE "Adoptopenjdk"; then
        vendor="AdoptOpenJDK"
    elif echo "$jdk_path" | grep -qE "Amazon"; then
        vendor="Amazon"
    elif echo "$jdk_path" | grep -qE "Apple"; then
        vendor="Apple"
    elif echo "$jdk_path" | grep -qE "Azul"; then
        vendor="Azul"
    elif echo "$jdk_path" | grep -qE "Openjdk"; then
        vendor="OpenJDK"
    elif echo "$jdk_path" | grep -qE "Oracle"; then
        vendor="Oracle"
    elif echo "$jdk_path" | grep -qE "Sapmachine"; then
        vendor="SAP"
    else
        vendor="Unknown"
    fi
    
    # Get version and vendor using the java command
    version_output=$(java -XshowSettings:properties -version 2>&1)
    if echo "$version_output" | grep -qE "java.version ="; then
        version=$(echo "$version_output" | grep -E "java.version =" | awk '{print $3}')
    fi
    if echo "$version_output" | grep -qE "java.vendor ="; then
        vendor=$(echo "$version_output" | grep -E "java.vendor =" | awk '{print $3}')
    fi
    
    result+="$jdk_path - [$vendor] - $version "
    
done

result+="</result>"
echo "$result"
exit 0
