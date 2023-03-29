#!/bin/zsh

# Extension attribute that will display the status of Siri (enabled or disabled) on the system.

# Created By : Manikandan @mani2care
# On : 29-Mar-2023


if [[ $(/usr/bin/pgrep -x "Siri") ]]; then
  echo "<result>Siri is enabled</result>"
else
  echo "<result>Siri is disabled</result>"
fi
