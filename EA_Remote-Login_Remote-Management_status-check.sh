#!/bin/sh

sudo launchctl list com.openssh.sshd &> /dev/null;
if [ $? -eq 0 ]
then
  echo "Remote_Login_Enabled"
else
  echo "Remote_Login_Disabled"
fi

# Check if remote management is enabled
agent_process=$(pgrep -x ARDAgent)
if [ -n "$agent_process" ]; then
    echo "Remote_Management_Enabled"
else
    echo "Remote_Management_Disabled"
fi
