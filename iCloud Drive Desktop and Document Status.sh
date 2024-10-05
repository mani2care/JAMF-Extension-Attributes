If anyone comes accross this thread like I did. I created an updated version of this extension attribute that fixes an issue where if the user is signed in with a Managed AppleID instead of a personal AppleID the script looks in the wrong place on the MobileMeAccounts.plist for the DriveStatus. Here is my version:


I have tested it successfully with both personal and managed AppleIDs on Monterey, Ventura, and Sonoma.
#!/bin/bash


# About this Program: #
# Purpose: to grab iCloud Drive Desktop and Document Sync status.
# If Drive has been set up previously, then values should be: "Enabled" or "Not Enabled"
# If Drive has NOT been set up previously, then values will be: "iCloud Account Enabled, Drive Not Enabled" or "iCloud Account Disabled"
#
# This was created with code from this macadmins slack thread in the #scripting channel: https://macadmins.slack.com/archives/CGXNNJXJ9/p1696853905556089?thread_ts=1656595758.742779&cid=CGXNNJXJ9
# Modifications where added by Quinn to fix an issue with Managed AppleIDs and clean up some code


# Version History
# April 4th 2024: Version 1.0 - Initial Version



# Variable to determine the major OS version
OSverMinor="$(/usr/bin/sw_vers -productVersion | /usr/bin/cut -d . -f 2)"
OSverMajor="$(/usr/bin/sw_vers -productVersion | /usr/bin/cut -d . -f 1)"

# Determine if the OS is 10.12 or greater as Doc Sync is only available on 10.12 to Big Sur
# Added macOS 14 (Sonoma) to the list of supported versions
if [ "$OSverMinor" -ge "12" ] || [ "$OSverMajor" -eq "11" ] || [ "$OSverMajor" -eq "12" ] || [ "$OSverMajor" -eq "13" ] || [ "$OSverMajor" -eq "14" ]; then
	
	# Path to PlistBuddy
	plistBud="/usr/libexec/PlistBuddy"
	
	# Determine the logged-in user
	loggedInUser=$(echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ && ! /loginwindow/ { print $3 }')
	
	# Variable to determine the status of iCloud Drive Desktop & Documents setting
	iCloudDesktop=$(defaults read /Users/$loggedInUser/Library/Preferences/com.apple.finder.plist FXICloudDriveDesktop)
	
	# Determine whether the user is logged into iCloud
	if [[ -e "/Users/$loggedInUser/Library/Preferences/MobileMeAccounts.plist" ]]; then
		
		# To capture iCloudStatus, it's different starting from Monterey
		if [ "$OSverMajor" -ge "12" ] || [ "$OSverMajor" -eq "13" ] || [ "$OSverMajor" -eq "14" ]; then
			iCloudStatus=$("$plistBud" -c "print :Accounts:0" /Users/$loggedInUser/Library/Preferences/MobileMeAccounts.plist 2> /dev/null )
			
			# If the response to the previous command is empty, it means no active iCloud account
			if [ -z "$iCloudStatus" ]; then
				iCloudStatus="false"
			else
				iCloudStatus="true"
			fi
			
			# Capture iCloudStatus for versions before Monterey
		else
			iCloudStatus=$("$plistBud" -c "print :Accounts:0:LoggedIn" /Users/$loggedInUser/Library/Preferences/MobileMeAccounts.plist 2> /dev/null )
		fi
		
		# Determine whether the user has iCloud Drive enabled. Value should be either "False" or "True"
		if [[ "$iCloudStatus" = "true" ]]; then
			
			#determine if the signed in iCloud account is a (MAID) or personal (PAID) AppleID so we can look in the right place for the iCloud Drive Status
			ManagedAppleID=$("$plistBud" -c "print :Accounts:0:isManagedAppleID" /Users/$loggedInUser/Library/Preferences/MobileMeAccounts.plist 2> /dev/null )
			
			if [[ $ManagedAppleID = "false" ]]; then
				DriveStatus=$("$plistBud" -c "print :Accounts:0:Services:2:Enabled" /Users/$loggedInUser/Library/Preferences/MobileMeAccounts.plist 2> /dev/null )
			else
				DriveStatus=$("$plistBud" -c "print :Accounts:0:Services:1:Enabled" /Users/$loggedInUser/Library/Preferences/MobileMeAccounts.plist 2> /dev/null )
			fi
			
			if [[ "$DriveStatus" = "true" ]]; then
				if [[ "$iCloudDesktop" = "1" ]]; then
					DocSyncStatus="Enabled"
				else
					DocSyncStatus="Not Enabled"
				fi
			fi
			
			if [[ "$DriveStatus" = "false" ]] || [[ -z "$DriveStatus" ]]; then
				DocSyncStatus="iCloud Account Enabled, Drive Not Enabled"
			fi
		fi
		if [[ "$iCloudStatus" = "false" ]] || [[ -z "$iCloudStatus" ]]; then
			DocSyncStatus="iCloud Account Disabled (A)"
		fi
	else
		DocSyncStatus="iCloud Account Disabled (B)"
	fi
else
	DocSyncStatus="OS Not Supported"
fi

/bin/echo "<result>$DocSyncStatus</result>"






I took a different approach with the script.
#!/bin/bash
#set -x
# Variable to determine the major OS version
OSverMinor="$(/usr/bin/sw_vers -productVersion | /usr/bin/cut -d . -f 2)"
OSverMajor="$(/usr/bin/sw_vers -productVersion | /usr/bin/cut -d . -f 1)"

# Doc Sync only available on 10.12 or greater.
if [ "$OSverMinor" -ge "12" ] || [ "$OSverMajor" -eq "11" ] || [ "$OSverMajor" -eq "12" ] || [ "$OSverMajor" -eq "13" ] || [ "$OSverMajor" -eq "14" ]; then

	# Path to PlistBuddy
	plistBud="/usr/libexec/PlistBuddy"

	# Verify logged-in user
	loggedInUser=$(echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ && ! /loginwindow/ { print $3 }')

	# Verify status of iCloud Drive Desktop & Documents setting
	mobileMeAccounts=$(ls "/Users/$loggedInUser/Library/Preferences/MobileMeAccounts.plist")

	# Determine whether iCloud account exists
	if [[ -e $mobileMeAccounts ]]; then

		# Determine iCloud status macOS Monterey and above
		if [ "$OSverMajor" -ge "12" ] || [ "$OSverMajor" -eq "13" ] || [ "$OSverMajor" -eq "14" ]; then
			icloudStatus=$("$plistBud" -c "print :Accounts:0" ${mobileMeAccounts} 2>/dev/null)

			# If the response to the previous command is empty, it means no active iCloud account
			if [ -z "$icloudStatus" ]; then
				icloudStatus="false"
			else
				icloudStatus="true"
			fi

			# Determine iCloud status for versions before Monterey
		else
			icloudStatus=$("$plistBud" -c "print :Accounts:0:LoggedIn" ${mobileMeAccounts} 2>/dev/null)
		fi

		# Determine whether the user has iCloud Drive enabled. Value should be either "False" or "True"
		if [[ "$icloudStatus" = "true" ]]; then

			#determine if the signed in iCloud account is a (MAID) or personal (PAID) AppleID so we can look in the right place for the iCloud Drive Status
			managedAppleID=$("$plistBud" -c "print :Accounts:0:isManagedAppleID" ${mobileMeAccounts} 2>/dev/null)
			icloudID=$(${plistBud} -c "print :Accounts:0:AccountID" ${mobileMeAccounts} 2>/dev/null)

			if [[ $managedAppleID = "true" ]]; then
				driveStatus=$("$plistBud" -c "print :Accounts:0:Services:1:Enabled" ${mobileMeAccounts} 2>/dev/null)
				/bin/echo "${icloudID} is MAID"
			fi

			if [[ $managedAppleID = "false" ]]; then
				/bin/echo "${icloudID} is PAID"
				driveStatus=$("$plistBud" -c "print :Accounts:0:Services:2:Enabled" ${mobileMeAccounts} 2>/dev/null)
			else
				driveStatus=$("$plistBud" -c "print :Accounts:0:Services:1:Enabled" ${mobileMeAccounts} 2>/dev/null)
			fi
			
			if [[ "$driveStatus" = "true" ]]; then
				if [[ "$iCloudDesktop" = "1" ]]; then
					docSyncStatus="Drive: Enabled"
				else
					docSyncStatus="Drive: Not Enabled"
				fi
			fi

			if [[ "$driveStatus" = "false" ]] || [[ -z "$driveStatus" ]]; then
				docSyncStatus="iCloud Enabled, Drive: Not Enabled"
			fi
		fi
		if [[ "$icloudStatus" = "false" ]] || [[ -z "$icloudStatus" ]]; then
			docSyncStatus="No Accounts found"
		fi
	else

		docSyncStatus="Previous login acount is now disabled"
	fi
else
	docSyncStatus="OS Not Supported"
fi

/bin/echo "$docSyncStatus"


