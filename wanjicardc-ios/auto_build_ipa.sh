#!/bin/sh
 
#  build.Script.sh
#  xxxx
#
#  Created by luyu on 13-9-25.
#  Copyright (c) 2013年 xxxx. All rights reserved.

Version=$2                                                 #发布的版本号



#参数设定
Configuration="Release"
#CONFIGURATION="Debug"
AppName="WanJiCard"
targetName="WanJiCard"
Scheme="WanJiCard"

CurrentDate=`date "+%m%d"`


distDir="/Users/$USER/Desktop/ipa"
buildDir="$distDir/Build/Products/${Configuration}-iphoneos"
AppPath="$buildDir/${AppName}.app"
IpaPath="$distDir/${AppName}${Version}${CurrentDate}001.ipa"

Project_Path="/Users/$USER/Project/wanjicardc-ios"
Project_Name="./WanJiCard.xcodeproj"
Workspace_Name="./WanJiCard.xcworkspace"



SDK="iphoneos9.3"
ARCHS_CONFIG="armv7,armv7s,armv64"


CODE_SIGN="iPhone Distribution: Wanji Integration of Information Technology (Beijing) Co., Ltd. (L7L8VJ3NEY)"
Provision_Adhoc="faa4b512-6284-4331-a21c-88d7cf6c3e6c"
Provision_Store="0686a5ad-fd07-4142-bd6e-ab5d5b5d689d"


ROOT_PATH="/Applications/Xcode.app/Contents/Developer/usr/bin"


#######################
#Config of ipa Server
#######################
IPA_SERVER_IP="root@192.168.1.1"
IPA_SERVER_PORT=22
IPA_SERVER_FilePath=""




function update()
{
 echo "*** 开始Update  文件 ***"
 git pull ../
#$Project_Path
}

function clean()
{
echo "*** 开始Clean   文件 ***"

rm -rdf "$distDir"
rm -rdf "$buildDir"
mkdir "$distDir"
mkdir -p "$buildDir"

}

function build()
{
echo "*** 开始build app文件***"

xcodebuild -workspace $Workspace_Name -scheme $Scheme -configuration $Configuration -derivedDataPath $distDir -verbose

echo "*****  build 完毕*******"

}

function archive()
{
    echo "*** 开始archive ipa包      ***"

    rm -rf "Payload"
    mkdir "Payload"

    cp -R $AppPath "Payload"
    zip -q -r $IpaPath "Payload/"
    open $distDir

    rm -rf "Payload"

    echo "**** 打包完毕 ****"
}


function upload()
{
versions="$(defaults read $APP_PATH/Info CFBundleShortVersionString)"

echo "*** 上传ipa包  WanJiWatch_${CurrentDate}001.ipa      ***"

mv "$ARCHIVE_PATH_D" $IPA_SERVER_PATH/Lottery_${CurrentDate}_001.ipa

echo "*** 测试版上传完毕       ***"
}


function checkBuild()
{
    if [ ! -n $2 ]
    then
        echo "error : 输入Build号"
        exit 1
    fi
}




case $1 in

update)     update ;;

clean)      clean ;;

build)      pwd
            checkBuild
            build
            archive  ;;

archive)    archive ;;

upload)     upload ;;

all)
            checkBuild
            update
            clean
            build
            archive
            #upload
                ;;
a*)
        echo $"Usage:  {update|clean|build|upload|all}"
        exit 1
esac

