//
//  WJModelPerson.m
//  WanJiCard
//
//  Created by Harry Hu on 15/8/28.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJModelPerson.h"
#import "WJDBTableKeys.h"
#import "WJDBAreaManager.h"



#define kSTR(key)       [NSString stringWithFormat:@"%@",data[key]]

//{
//    Code = 0;
//    Msg = "";
//    Toast = "<null>";
//    Type = 0;
//    Val =     {
//        Code = "<null>";
//        Id = 40;
//        IsSetPayPassword = 1;
//        Merid = 0;
//        Name = "<null>";
//        Phone = 15010301103;
//        Pwd = "<null>";
//        Regid = "<null>";
//        Token = b04261d5d89b41952e4b9b0a192e66e1;
//    };
//}

/***********************************************/
/*之后要换新的接口*/
/***********************************************/

@implementation WJModelPerson

- (instancetype)initWithData:(id)data
{
    if (self = [super init]) {
        
        self.userID = ToString(data[@"id"]);
        self.userName = ToString(data[@"userPhone"]);
        self.token = ToString(data[@"token"]);
        self.isSetPayPassword = [ToNSNumber(data[@"isSetpaypwd"])  boolValue];
        self.phone = ToString(data[@"userPhone"]);
        self.isNewUser = [ToNSNumber(data[@"isNewUser"]) boolValue];
        self.payPsdSalt = ToString(data[@"userPasswordSalt"])?:@"";
        self.isSetPsdQuestion = [ToNSNumber(data[@"isSetsecurity"]) boolValue];
        self.hasVerifyPayPassword = NO;
        self.appealStatus = (AppealStatus)[ToString(data[@"appealStatus"]) integerValue];
        self.authentication = (AuthenticationStatus)[ToString(data[@"isAuthentication"]) integerValue];
        self.realName = ToString(data[@"userRealname"]);
        
        //wzj
        self.couponCount = ToString(data[@"couponCount"]);
       
    }
    return self;
}



-(id)initWithCursor:(FMResultSet *)cursor{
    if (self = [super init]) {
        self.userID         = [cursor stringForColumn:COL_PERSON_ID];
        self.consumerId     = [cursor stringForColumn:COL_PERSON_Consumer]?:@"";
        self.userName       = [cursor stringForColumn:COL_PERSON_UserName];
        self.realName       = [cursor stringForColumn:COL_PERSON_RealName]?:@"";
        self.nickName       = [cursor stringForColumn:COL_PERSON_NichName]?:@"";
        self.phone          = [cursor stringForColumn:COL_PERSON_Phone];
        self.userLevel      = [cursor intForColumn:COL_PERSON_UserLevel]?:0;
        self.headImageUrl   = [cursor stringForColumn:COL_PERSON_HeadImageUrl]?:@"";
        self.IDCard         = [cursor stringForColumn:COL_PERSON_IdCard]?:@"";
        self.gender         = (Gender)[cursor intForColumn:COL_PERSON_Gender];
        self.birthdayYear   = [cursor stringForColumn:COL_PERSON_BirthdayYear];
        self.birthdayMonth  = [cursor stringForColumn:COL_PERSON_BirthdayMonth];
        self.birthdayDay    = [cursor stringForColumn:COL_PERSON_BirthdayDay];
        self.country        = [cursor stringForColumn:COL_PERSON_Country];
        self.province       = [cursor stringForColumn:COL_PERSON_Province];
        self.city           = [cursor stringForColumn:COL_PERSON_City];
        self.token          = [cursor stringForColumn:COL_PERSON_Token];
        self.payPassword    = [cursor stringForColumn:COL_PERSON_PayPassword]?:@"";
        self.isActively     = [cursor boolForColumn:COL_PERSON_IsActively];
        self.isSetPayPassword = [cursor boolForColumn:COL_PERSON_IsSetPayPassword];
        self.authentication = (AuthenticationStatus)[cursor intForColumn:COL_PERSON_Authentication];
        self.isNewUser      = [cursor boolForColumn:COL_PERSON_IsNewUser];
        self.hasVerifyPayPassword = [cursor boolForColumn:COL_PERSON_HasVerifyPayPsd];
        self.payPsdSalt     = [cursor stringForColumn:COL_PERSON_PayPsdSalt]?:@"";
        self.isSetPsdQuestion = [cursor boolForColumn:COL_PERSON_IsSetPsdQuestion];
        self.appealStatus   =     (AppealStatus)[cursor intForColumn:COL_PERSON_AppealStatus];
    }
    return self;
}

- (void)updateWithDic:(NSDictionary *)dic{

    if (dic == nil) {
        return;
    }
    
    self.realName =         ToString(dic[@"userRealname"]);
//wzj-现在server返回没有此字段
//    self.nickName =         ToString(dic[@"NickName"]);
    self.gender =           (Gender)[ToString(dic[@"userSex"]) integerValue];
//    self.country =          ToString(dic[@"Country"]);
//    self.province =         ToString(dic[@"Province"]);
//    self.city =             ToString(dic[@"City"]);
//    self.birthdayYear =     ToString(dic[@"Birthyear"]);
//    self.birthdayMonth =    ToString(dic[@"Birthmonth"]);
//    self.birthdayDay =      ToString(dic[@"Birthday"]);
    
    
    NSString *addressid = ToString(dic[@"address"]);
    self.country = @"";
    self.province = @"";
    self.city = @"";
    
    if (![self IsChinese:addressid] && ![addressid isEqualToString:@""] && addressid != nil) {
    
        WJModelArea *area = [[WJDBAreaManager new] getAreaByAreaId:addressid];
        WJModelArea *province = [[WJDBAreaManager new] getAreaByAreaId:area.parentid];
        self.city = area.name;
        self.province = province.name;
        self.country = @"中国";
    }
    
    NSString *birthData = ToString(dic[@"userBirthday"]);
    self.birthdayYear = @"";
    self.birthdayMonth = @"";
    self.birthdayDay = @"";
    
    if (![birthData isEqualToString:@""] && birthData != nil) {
       
        if IOS8_LATER {
        
           if ([birthData containsString:@","]) {
               //兼容线上的后台版本带逗号
               self.birthdayYear =     [[birthData componentsSeparatedByString:@","] firstObject];
               self.birthdayMonth =    [birthData componentsSeparatedByString:@","][1];
               self.birthdayDay =      [[birthData componentsSeparatedByString:@","] lastObject];

            }else{
                //所有不带逗号的，且长度小于8的
                if (birthData.length < 8){
                    self.birthdayYear  = @"2016";
                    self.birthdayMonth = @"01";
                    self.birthdayDay   = @"01";
                    
                }else{
                   //兼容部分不带逗号的
                   self.birthdayYear  =     [birthData substringWithRange:NSMakeRange(0,4)];
                   self.birthdayMonth =     [birthData substringWithRange:NSMakeRange(4,2)];
                   self.birthdayDay   =     [birthData substringWithRange:NSMakeRange(6,2)];
                }
            }
        }else{
            NSRange range = [birthData rangeOfString:@","];
            if (range.location != NSNotFound){
                //兼容线上的后台版本带逗号
                self.birthdayYear =     [[birthData componentsSeparatedByString:@","] firstObject];
                self.birthdayMonth =    [birthData componentsSeparatedByString:@","][1];
                self.birthdayDay =      [[birthData componentsSeparatedByString:@","] lastObject];
            }else{
                //兼容部分不带逗号的
                self.birthdayYear  =     [birthData substringWithRange:NSMakeRange(0,4)];
                self.birthdayMonth =     [birthData substringWithRange:NSMakeRange(4,2)];
                self.birthdayDay   =     [birthData substringWithRange:NSMakeRange(6,2)];
            }
        }
        
    }

    self.headImageUrl =     ToString(dic[@"userPhoto"]);
    //wzj -现在server返回没有此字段
    //self.userLevel =        [dic[@"UserLevel"] integerValue];
    
    //wzj-现在server返回userIdcard字段代替院线的Idno
    self.IDCard =           ToString(dic[@"userIdcard"]);
     //wzj-现在server返回没有此字段
    //self.consumerId =       ToString(dic[@"Consumerid"]);
    self.authentication =   (AuthenticationStatus)[ToString(dic[@"isAuthentication"]) integerValue];
    self.isSetPsdQuestion = [dic[@"isSetsecurity"] boolValue];
    self.appealStatus =     [dic[@"appealStatus"] integerValue];
    self.baoziNumber = ToString(dic[@"walletCount"]);

}

-(BOOL)IsChinese:(NSString *)str
{
    for(int i=0; i< [str length];i++)
    {
        int a = [str characterAtIndex:i];
        
        if( a > 0x4e00 && a < 0x9fff){
            
            return YES;
        }
    
    }
    
    return NO;
    
}

-(NSString *)description{
    return [NSString stringWithFormat:@"(userID = %@ userName = %@ nickName = %@ realName = %@  phone = %@)",
            self.userID, self.userName, self.nickName, self.realName, self.phone];
}


- (void)saveSAH1WithString:(NSString *)sal1
{
    [[NSUserDefaults standardUserDefaults] setObject:sal1 forKey:[NSString stringWithFormat:@"sal1_%@_sal1",self.userID]];
}

- (NSString *)sal1WithPersonID
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"sal1_%@_sal1",self.userID]];
}

- (void)logout{

    self.isActively = NO;
    self.hasVerifyPayPassword = NO;
    [[WJDBPersonManager new] updatePerson:self];
    [WJGlobalVariable sharedInstance].defaultPerson = nil;
    
}

@end
