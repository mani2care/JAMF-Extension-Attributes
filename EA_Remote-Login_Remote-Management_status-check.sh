#!/bin/sh

sudo launchctl list com.openssh.sshd &> /dev/null;
if [ $? -eq 0 ]
then
  echo "<result>Remote_Login_Enabled</result>"
else
  echo "<result>Remote_Login_Disabled</result>"
fi

# Check if remote management is enabled
agent_process=$(pgrep -x ARDAgent)
if [ -n "$agent_process" ]; then
    echo "<result>Remote_Management_Enabled</result>"
else
    echo "<result>Remote_Management_Disabled</result>"
fi
