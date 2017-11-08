#!/bin/sh

#  LeSports-Achive.sh
#  LESports
#
#  Created by HuHarry on 15/6/1.
#  Copyright (c) 2015年 LETV. All rights reserved.

exit 0;

if [ "$CONFIGURATION" == "Debug" ]; then
    echo "Skipping debug"
exit 0;
fi

if [ "$EFFECTIVE_PLATFORM_NAME" == "-iphonesimulator" ]; then
    echo "Skipping simulator build"
exit 0;
fi

echo "设定buildNumber"
#buildNumber=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "$INFOPLIST_FILE")

FILENAME="./Shell/BuildNumber"
VersionNumber=$(sed -n '$p' $FILENAME)
echo "VersionNumber = $VersionNumber"
day=$(date "+%m%d")

channelKey=$PUBLISH_CHANNEL

if [ "AppStore" == "$channelKey" ]; then
    channel="100";echo "AppStore包";
elif [ "InHouse" == "$channelKey" ]; then
    channel="001";echo "Inhouse包";
else channel="000";echo "Adhoc包";
fi

buildNumber=$VersionNumber$day$channel
echo "buildNumber = $buildNumber"
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" "$INFOPLIST_FILE"


#echo $(($VersionNumber+1)) > FILENAME
echo "FileNumber = $(sed -n '$p' $FILENAME)"


