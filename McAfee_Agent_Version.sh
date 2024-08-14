#!/bin/sh

EPOVersion=$(awk -F'>|<' '/<Version>/{print $3}' /etc/cma.d/EPOAGENT3700MACX/config.xml)

echo "<result>$EPOVersion</result>"
