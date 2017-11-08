//
//  WJGlobalVariable.h
//  WanJiCard
//
//  Created by Angie on 15/9/24.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;

//typedef enum
//{
//    ResetPsyTypeUnKnow,
//    ResetPsyTypeInit,
//    ResetPsyTypeReset
//} ResetPsyType;

typedef NS_ENUM(NSInteger,ComeFrom){
    ComeFromPayCode = -1,    //付款页
    ComeFromNone = 0,
    ComeFromLogin = 1,       //登录页
    ComeFromModifyPsd,       //修改支付密码
    ComeFromRetrievePsd,     //找回支付密码
    ComeFromSafetyQuestion,  //设置安全问题
    ComeFromChangePhone,     //修改手机号
    ComeFromOpenNoPsd,       //开启无密
    ComeFromTouchID

};

//typedef enum
//{
//    ComeFromPayCode = -1,    //付款页
//    ComeFromNone = 0,
//    ComeFromLogin = 1,       //登录页
//    ComeFromModifyPsd,       //修改支付密码
//    ComeFromRetrievePsd,     //找回支付密码
//    ComeFromSafetyQuestion,  //设置安全问题
//    ComeFromChangePhone,     //修改手机号
//    ComeFromOpenNoPsd,       //开启无密
//    ComeFromTouchID
//} ComeFrom;


typedef enum
{
    LoginFromNone = 0,
    LoginFromCardPack,           //卡包
    LoginFromPersonal,           //个人中心
    LoginFromBuyCard,            //购卡
    LoginFromHomeMessage,        //首页消息
    LoginFromPersonalMessage,    //个人中心消息
    LoginFromFair,               //市集
    LoginFromBuyElectronicCard,  //购买电子卡
    LoginFromWebView,             //web活动
    LoginFromHomeMyBaoziView,      //首页我的包子
    LoginFrom3DTouchPayCode,       //3Dtouch进入卡包
    LoginFromCardExchange          //卡兑换进入卡包
    
} LoginFrom;

typedef enum
{
    LoginFromCashAccount = 0,    //账户进入
    
} CashLoginFrom;


@class WJModelPerson;

@interface WJGlobalVariable : NSObject

@property (nonatomic, strong) WJViewController *fromController;  //验证的前一个controller
@property (nonatomic, strong) WJViewController *payfromController;  //确认订单前一个controller
@property (nonatomic, strong) WJViewController *findPwdFromController;  //记录从登录页进入找回支付密码
@property (nonatomic, strong) WJViewController *realAuthenfromController;  //记录实名前一个controller
@property (nonatomic, strong) WJViewController *realAuthenReciveMoneyfromController;//记录小额鉴权controller
@property (nonatomic, assign) CLLocationCoordinate2D appLocation;
@property (nonatomic, strong) NSString *currentID;
@property (nonatomic, assign) NSInteger tabBarIndex;
@property (nonatomic, strong) WJModelPerson *defaultPerson;
@property (nonatomic, assign) NSInteger homeCardClickCount;
+ (instancetype)sharedInstance;

+ (UIImage *)cardBgImageByType:(NSInteger)type;

+ (UIImage *)cardBgImageWithBgByType:(NSInteger)type;

+ (UIColor *)cardBackgroundColorByType:(NSInteger)type;

//+ (NSString *)generateSM3TOTPTokenSeed;

//+ (ResetPsyType)getResetPayPasswordType;

+ (BOOL)touchIDIsAvailable;

+ (NSString *)recordRequestUrlFilePath;

+ (BOOL)serverBaseUrlIsTest;

+ (void)payPasswordVerifySuccess;

+ (NSString *)payPasswordVerifyFailedErrorFilePatch;

//处理金额字符串
+ (NSString *)changeMoneyString:(NSString *)money;

@end

