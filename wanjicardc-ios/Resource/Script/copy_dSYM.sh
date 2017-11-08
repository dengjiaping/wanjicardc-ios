#!/bin/sh

#  copy_dSYM.sh
#  LESports
#
#  Created by HuHarry on 15/6/2.
#  Copyright (c) 2015年 LETV. All rights reserved.


echo "copy dsym文件"

#debug模式
if [ "$CONFIGURATION" == "Debug" ]; then
    echo "Skipping debug"
    exit 0;
fi

#模拟器模式
if [ "$EFFECTIVE_PLATFORM_NAME" == "-iphonesimulator" ]; then
    echo "Skipping simulator build"
    exit 0;
fi

buildNumber=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "$INFOPLIST_FILE")
VersionNumber=${buildNumber:0:5}

echo "Start -- "
#FILENAME=${SRCROOT}/Shell/BuildNumber
#VersionNumber=$(sed -n '$p' $FILENAME)
SRC_PATH=${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}
RELATIVE_DEST_PATH=~/Desktop/dSYM
DEST_PATH=${RELATIVE_DEST_PATH}/${EXECUTABLE_NAME}.$VersionNumber.app.dSYM
echo "SRC_PATH = $SRC_PATH, DEST_PATH = $DEST_PATH"


if [ ! -d "$RELATIVE_DEST_PATH" ]; then
    mkdir "$RELATIVE_DEST_PATH"
    cp ${SRCROOT}/Resource/Script/buglySymbolIOS.jar $RELATIVE_DEST_PATH/
fi

if [ -f "${DEST_PATH}" ];then
    mv ${DEST_PATH} ${DEST_PATH}.old
fi

cp -R ${SRC_PATH} ${DEST_PATH}
cd $RELATIVE_DEST_PATH
java -jar buglySymbolIOS.jar -i ${DEST_PATH}/Contents/Resources/DWARF/${EXECUTABLE_NAME} -o ${EXECUTABLE_NAME}.$VersionNumber.app.symbol.zip;
rm -rf $DEST_PATH
mv ${EXECUTABLE_NAME}.$VersionNumber.app.* ${EXECUTABLE_NAME}.$VersionNumber.zip



