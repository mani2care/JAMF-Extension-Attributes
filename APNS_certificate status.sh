#!/bin/bash

APNS_certificate=$( /usr/sbin/system_profiler SPConfigurationProfileDataType | awk '/Topic =/{ print $NF }' | sed 's/[";]//g' )

  if [[ "$APNS_certificate" = "" ]]; then
      result="N/A"
  else
      result="$APNS_certificate"
  fi

/bin/echo "<result>$result</result>"
