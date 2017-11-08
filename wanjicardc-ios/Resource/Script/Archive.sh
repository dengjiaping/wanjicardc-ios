#!/bin/sh

#  Archive.sh
#  LESports
#
#  Created by HuHarry on 15/6/2.
#  Copyright (c) 2015年 LETV. All rights reserved.

#xcodebuild [-project <projectname>] [[-target <targetname>]...|-alltargets] [-configuration <configurationname>] [-arch <architecture>]... [-sdk [<sdkname>|<sdkpath>]] [-showBuildSettings] [<buildsetting>=<value>]... [<buildaction>]...


VersionNumber=$(sed -n '$p' $FILENAME)
day=$(date "+%m%d")
channelKey=$PUBLISH_CHANNEL
Version="0.9.2"

distDir="/Users/$USER/Desktop/ipa"
buildDir="${distDir}/build"

PROJECT_PATH="/Users/$USER/Project/LetvSports-iOS"

project_Name="${PROJECT_PATH}/LESports.xcodeproj"

target_Name="LESports"
target_Name_I="LESports_inhouse"

CONFIGURATION="Release"
ARCH="armv7,armv7s,armv64"
SDK="iphoneos8.3"
BUILDFILE="${PROJECT_PATH}/Shell/BuildNumber"

CODE_SIGN_INHOUSE="iPhone Distribution: LeTV Sports Culture Develop (Beijing) Co., Ltd."
PFILE_NAME_INHOUSE="0753a650-e880-4554-b063-b93202f6aa75"

CODE_SIGN_ADHOC="iPhone Distribution: LeTV Sports Culture Develop (Beijing), Co., Ltd."
PFILE_NAME_ADHOC="452a1356-009b-4a22-bb64-47a0f929062d"

CODE_SIGN_APPSTORE="iPhone Distribution: LeTV Sports Culture Develop (Beijing), Co., Ltd."
PFILE_NAME_APPSTORE="70e76c8d-3787-4ed9-9a23-a6dee4608af1"

ROOT_PATH="/Applications/Xcode.app/Contents/Developer/usr/bin"

APP_PATH="$buildDir/${target_Name}.${VersionNumber}.app"
APP_PATH_I="$buildDir/${target_Name_Inhouse}.${VersionNumber}.app"

ARCHIVE_PATH=$distDir/"${target_Name}.${VersionNumber}.ipa"
ARCHIVE_PATH_I=$distDir/"${target_Name}.${VersionNumber}.ipa"

########################################
function setBuildNumber()
{
echo "设定buildNumber"
#buildNumber=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "$INFOPLIST_FILE")


if [ "AppStore" == "$channelKey" ]; then
channel="100";echo "AppStore包";
elif [ "InHouse" == "$channelKey" ]; then
channel="001";echo "Inhouse包";
else channel="000";echo "Adhoc包";
fi

buildNumber=$VersionNumber$day$channel
echo "buildNumber = $buildNumber"
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" "$INFOPLIST_FILE"

}

########################################
function update()
{
echo "*** 开始Update  文件 ***"
svn up $PROJECT_PATH
}

########################################
function clean()
{

echo "*** 开始Clean   文件 ***"

rm -rdf "$distDir"
rm -rdf "$buildDir"
mkdir "$distDir"
mkdir -p "$buildDir"

xcodebuild -project $Project_Name  -target "$targetName" -sdk $SDK  PROVISIONING_PROFILE=$PFILE_NAME_ADHOC  clean OBJROOT=$buildDir SYMROOT=$buildDir -verbose
xcodebuild -project $Project_Name  -target "$targetName" -sdk $SDK  PROVISIONING_PROFILE=$PFILE_NAME_INHOUSE  clean OBJROOT=$buildDir SYMROOT=$buildDir -verbose
}

########################################
function build()
{
echo "*** 开始build app文件 开发版***"
xcodebuild -project $Project_Name  -target "$targetName" -sdk $SDK  PROVISIONING_PROFILE=$PFILE_NAME_DEV   build OBJROOT=$buildDir SYMROOT=$buildDir GCC_PREPROCESSOR_DEFINITIONS='${inherited} wapservertype=3' -verbose
echo "*****  build 开发版 完毕*******"

}

########################################
function archive()
{
echo "*** 开始archive ipa包      ***"
$ROOT_PATH/xcrun  -sdk $SDK PackageApplication -v "$APP_PATH" -o $ARCHIVE_PATH --sign "$CODE_SIGN_ADHOC"
echo "**** 打包完毕 ****"
}


########################################开始执行
update
clean
setBuildNumber
build
archive
upload
