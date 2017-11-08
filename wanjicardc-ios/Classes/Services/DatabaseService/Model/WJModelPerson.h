//
//  WJModelPerson.h
//  WanJiCard
//
//  Created by Harry Hu on 15/8/28.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDBModel.h"

typedef NS_ENUM(NSInteger, Gender) {
    GenderUnkown,//0
    GenderMale, // 1男
    GenderFemale //2女
    
    
};

typedef NS_ENUM(NSInteger, AppealStatus) {
    AppealNoInfo = 0,   //没有申诉信息
    AppealProcessing = 10,  // 处理中
    AppealCompleted = 30    //已处理
    
};

typedef NS_ENUM(NSInteger, AuthenticationStatus) {
    
    AuthenticationNo = 0,   //未认证
    AuthenticationCompleted = 2    //已认证
    
};


@interface WJModelPerson : BaseDBModel

@property (nonatomic, strong) NSString *userID;            //用户ID
@property (nonatomic, strong) NSString *consumerId;
@property (nonatomic, strong) NSString *couponCount;     // wzj,优惠券数量
@property (nonatomic, strong) NSString *userName;           //登录用户名
@property (nonatomic, strong) NSString *realName;           //真实名字
@property (nonatomic, strong) NSString *nickName;           //昵称
@property (nonatomic, strong) NSString *phone;              //手机
@property (nonatomic, assign) NSInteger userLevel;          //用户级别
@property (nonatomic, strong) NSString *headImageUrl;       //头像地址
@property (nonatomic, strong) NSString *IDCard;             //身份证
@property (nonatomic, assign) Gender gender;                //性别
@property (nonatomic, strong) NSString *birthdayYear;       //生日年
@property (nonatomic, strong) NSString *birthdayMonth;      //生日月
@property (nonatomic, strong) NSString *birthdayDay;        //生日日
@property (nonatomic, strong) NSString *country;            //国家
@property (nonatomic, strong) NSString *province;           //省份
@property (nonatomic, strong) NSString *city;               //城市
@property (nonatomic, strong) NSString *token;              //与后台认证的Token
@property (nonatomic, strong) NSString *payPassword;        //支付密码
@property (nonatomic, assign) BOOL isActively;              //当前用户
@property (nonatomic, assign) BOOL isSetPayPassword;        //用户是否设置支付密码
@property (nonatomic, strong) NSString *payPsdSalt;         //支付密码哈希秘钥；
@property (nonatomic, assign) AuthenticationStatus authentication;     //验证, 0未认证,1审核中,2已认证
@property (nonatomic, assign) BOOL isNewUser;               //新用户
@property (nonatomic, assign) BOOL isSetPsdQuestion;        //用户是否设置安全问题
@property (nonatomic, assign) BOOL  hasVerifyPayPassword;   //是否验证过支付密码；
@property (nonatomic, assign) AppealStatus appealStatus;    //申诉状态

@property (nonatomic, strong) NSString *baoziNumber;


- (instancetype)initWithData:(id)data;

- (void)updateWithDic:(NSDictionary *)dic;

- (void)saveSAH1WithString:(NSString *)sal1;

- (NSString *)sal1WithPersonID;

- (void)logout;

@end
