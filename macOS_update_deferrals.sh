#!/bin/bash
# Script to check enforced software update deferral settings on macOS

# Function to retrieve values from macOS preferences
get_pref() {
    osascript -l JavaScript << EOS
    ObjC.import('Foundation')
    ObjC.unwrap($.NSUserDefaults.alloc.initWithSuiteName('com.apple.applicationaccess').objectForKey('$1'))
EOS
}

# Initialize result variable
RESULT=""

# Check if major OS updates are deferred
forceDelayedMajorSoftwareUpdates=$(get_pref "forceDelayedMajorSoftwareUpdates")
RESULT+="DelayMajorUpdate: $forceDelayedMajorSoftwareUpdates\n"

if [[ "$forceDelayedMajorSoftwareUpdates" == "true" ]]; then
    majorOSDeferralDelay=$(get_pref "enforcedSoftwareUpdateMajorOSDeferredInstallDelay")
    RESULT+="DelayMajorUpdateDays: $majorOSDeferralDelay\n"
fi

# Check if minor OS updates are deferred
forceDelayedMinorSoftwareUpdates=$(get_pref "forceDelayedSoftwareUpdates")
RESULT+="DelayMinorUpdate: $forceDelayedMinorSoftwareUpdates\n"

if [[ "$forceDelayedMinorSoftwareUpdates" == "true" ]]; then
    minorOSDeferralDelay=$(get_pref "enforcedSoftwareUpdateMinorOSDeferredInstallDelay")
    RESULT+="DelayMinorUpdateDays: $minorOSDeferralDelay\n"
fi

# Check if non-OS (app) updates are deferred
forceDelayedAppSoftwareUpdates=$(get_pref "forceDelayedAppSoftwareUpdates")
RESULT+="DelayNonOSUpdate: $forceDelayedAppSoftwareUpdates\n"

if [[ "$forceDelayedAppSoftwareUpdates" == "true" ]]; then
    appOSDeferralDelay=$(get_pref "enforcedSoftwareUpdateNonOSDeferredInstallDelay")
    RESULT+="DelayNonOSUpdateDays: $appOSDeferralDelay\n"
fi

# If no deferrals are applied, indicate that no update deferrals are in place
if [[ "$forceDelayedMajorSoftwareUpdates" != "true" && "$forceDelayedMinorSoftwareUpdates" != "true" && "$forceDelayedAppSoftwareUpdates" != "true" ]]; then
    RESULT+="No_Update_Deferrals\n"
fi

# Output correctly formatted result for Jamf
echo "<result>$(echo -e "$RESULT")</result>"
