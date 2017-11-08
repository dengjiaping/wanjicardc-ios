//
//  CodeCatalog
//  WanJiCard
//
//  Created by Lynn on 15/8/27.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

版本规则：
    10000 1119 000




推送设置

    别名规则 --- UUID 间隔符为_

    登录时上传 RegistrationID

接入库说明

ShareSDK
    1. 必备
        libicucore.dylib
        libz.dylib
        libstdc++.dylib
        JavaScriptCore.framework

    2. 以下依赖库根据社交平台添加
        (1)新浪微博SDK依赖库
            ImageIO.framework
        (2)QQ好友和QQ空间SDK依赖库
            libsqlite3.dylib
        (3)微信SDK依赖库：
            libsqlite3.dylib

AFNetworking
    SystemConfiguration/System
    MobileCoreServices


Bugly
    SystemConfiguration.framework
    Security.framework
    libz.dylib
    libc++.dylib（如果你的 Xcode 工程的 C++ Standard Library 配置为libstdc++，请选择Bugly_libstdc++目录下的Bugly.framework，并将libc++.dylib替换为libstdc++.dylib）

FMDB
    libsqlite3.dylib

Pingpp
    CFNetwork.framework
    SystemConfiguration.framework
    Security.framework
    libc++.dylib
    libz.dylib
    libsqlite3.dylib


SDWebImage
    ImageIO.framework
    MapKit.framework


SSKeychain
    Security.framework

Umeng
    libz.tbd


JPushSDK
    CFNetwork.framework
    CoreFoundation.framework
    CoreTelephony.framework
    SystemConfiguration.framework
    CoreGraphics.framework
    Foundation.framework
    UIKit.framework
    Security.framework
    libz.dylib

zXing
    AVFoundation
    AudioToolbox
    CoreVideo
    CoreMedia
    libiconv
    AddressBook
    AddressBookUI



=========================================

Config

    App Scheme: wanjikaClient
    

#param -Business

Cards -- 卡包
    "WJCardsViewController"               卡包首页
    "WJCardPackageDetailController"       卡包详情

    "WJProductDetailController"           卡产品详情

Payment
    "WJChangePayPsdController"            输入密码
    "WJPaySettingController"              支付设置
    "WJFindPsdWayViewController"          找回方式

Recharge
    "WJPayCompleteController"               支付完成


QRCode
    "WJQRCodeViewController"              扫一扫
    "WJGeneratedPayCodeController"        付款码生成
    "WJMaxCardViewController"               二维码扫描


Business -- 购卡
    "WJRecommendStoreViewController"        购卡进入推荐商家
    "WJMerchantListViewController"          商家列表
    "WJSearchMerchantViewController"        搜索商家


Login -- 领卡页面
    "WJLoginViewController"                 登录页面


#param -Service

DatabaseServeice
    Datebase
        "SqliteManager"                   数据库操作
        "WJDBTableKeys"                   数据库常量

    DBManager
        "BaseDBManager"
        "WJDBAreaManager"                 数据表-地区操作
        "WJDBCardManager"                 数据表-卡片操作

    Model
        "BaseDBModel"
        "WJModelArea"                     地区模型
        "WJModelCard"                     卡片模型
        "WJModelPerson"                   用户模型

PushService
        "PushManager"
#param -Common

