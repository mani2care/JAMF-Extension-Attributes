#!/bin/sh
arch=$(/usr/bin/arch)
if [ "$arch" == "arm64" ]; then # is rosetta 2 installed? 
    arch -x86_64 /usr/bin/true 2> /dev/null
    if [ $? -eq 1 ];
        then result="Rosetta_Missing"
    else result="Rosetta_Installed"
    fi
else result="Not-a-arm64"
fi
echo "<result>$result</result>"
