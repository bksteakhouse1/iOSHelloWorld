#!/bin/bash

export APPCENTER_ACCESS_TOKEN=7966e518a0b77b32597e9408c987b1e20a7187a1
export MOBILE_CENTER_CURRENT_APP=brandon-krett-7j1f/HelloWorld
appcenter build queue -b master

FAILED="0"
SUCCESS="0"
STATUS="$(appcenter build branches show -b master | grep 'Build status:')"

while true; do
	STATUS="$(appcenter build branches show -b master | grep 'Build status:')"
	printf "$STATUS\n"
	sleep 5 #sleep for 5 seconds before querying AWS again
	SUCCESS="$(appcenter build branches show -b master | grep -c 'Build result:\s*succeeded')"
	if [ "$SUCCESS" = "1" ]; then 
		break
	fi
	FAILED="$(appcenter build branches show -b master | grep -c 'Build result:\s*failed')"
	if [ "$FAILED" = "1" ]; then 
		break
	fi	
	printf "$SUCCESS $FAILED\n"	

done

FINAL="$(appcenter build branches show -b master)"
printf "$FINAL\n"
if [ "$FAILED" = "1" ]; then 
	exit 1
fi
if [ "$SUCCESS" = "1" ]; then 
	exit 0
fi
