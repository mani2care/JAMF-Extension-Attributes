#!/bin/sh

sudo launchctl list com.openssh.sshd &> /dev/null;
if [ $? -eq 0 ]
then
	echo "<result>Remote_Login_Enabled</result>"
	sudo systemsetup -f -setremotelogin off
else
	echo "<result>Remote_Login_Disabled</result>"
fi

# Check if remote management is enabled
agent_process=$(pgrep -x ARDAgent)
if [ -n "$agent_process" ]; then
    echo "<result>Remote_Management_Enabled</result>"
    sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -deactivate -configure -access -off >> /dev/null 2>&1
else
	echo "<result>Remote_Management_Disabled</result>"
fi