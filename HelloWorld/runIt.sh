#!/bin/bash

export APPCENTER_ACCESS_TOKEN=7966e518a0b77b32597e9408c987b1e20a7187a1
export MOBILE_CENTER_CURRENT_APP=brandon-krett-7j1f/HelloWorld
appcenter build queue -b master

FAILED="0"
SUCCESS="0"
STATUS="$(appcenter build branches show -b master | grep 'Build status:')"

while [ "$FAILED" != "1" ] | [ "$SUCCESS" != "1" ]; do
	printf "$STATUS\n"
	sleep 5 #sleep for 5 seconds before querying AWS again
	SUCCESS="$(appcenter build branches show -b master | grep -c 'Build result:   succeeded')"
	FAILED="$(appcenter build branches show -b master | grep -c 'Build result:   failed')"
	STATUS="$(appcenter build branches show -b master | grep 'Build status:')"

done

FINAL="$(appcenter build branches show -b master)"
if [ "$FAILED" = "1" ]; then 
	exit 1
fi
if [ "$SUCCESS" = "1" ]; then 
	exit 0
fi
