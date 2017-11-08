//
//  WJGlobalVariable.m
//  WanJiCard
//
//  Created by Angie on 15/9/24.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJGlobalVariable.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "WJModelPerson.h"

@implementation WJGlobalVariable

static WJGlobalVariable *s = nil;

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s = [[WJGlobalVariable alloc] init];
        
#if TestAPI
        [[NSUserDefaults standardUserDefaults] setObject:@"cbd" forKey:@"netstatus"];
#else
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"netstatus"];
#endif
        
    });
    return s;
}


- (WJModelPerson *)defaultPerson{
    
    if (!_defaultPerson) {
        
          WJDBPersonManager *manager = [WJDBPersonManager new];
   
          FMResultSet *cursor = [manager queryInTable:TABLE_PERSON
                                     withWhereClauses:@"WJK_COLUMN19 = ?"
                                   withWhereArguments:@[@(YES)]
                                          withOrderBy:COL_PERSON_ID
                                        withOrderType:ORDER_BY_NONE];
    
           while ([cursor next]) {
               
               _defaultPerson = [[WJModelPerson alloc] initWithCursor:cursor];
               
               break;
               
           }
        
        [cursor close];
    }
    
    return _defaultPerson;
    
}


+ (UIImage *)cardBgImageByType:(NSInteger)type{
    
    if (type >= 1) {
        type--;
    }
    NSArray *imageNames = @[@"card_red",@"card_orange", @"card_blue", @"card_green"];
    return [UIImage imageNamed:imageNames[MIN(type, 3)]];

}


+ (UIImage *)cardBgImageWithBgByType:(NSInteger)type{

    if (type >= 1) {
         type--;
    }
    NSArray *imageNames = @[@"card_red_bg",@"card_orange_bg", @"card_blue_bg", @"card_green_bg"];
    return [UIImage imageNamed:imageNames[MIN(type, 3)]];
}

+ (UIColor *)cardBackgroundColorByType:(NSInteger)type{
    
    UIColor *tempColor;
    switch (type) {
        case 1:
            tempColor = WJColorCardRed;
            break;
        case 2:
            tempColor = WJColorCardOrange;
            break;
        case 3:
            tempColor = WJColorCardBlue;
            break;
        case 4:
            tempColor = WJColorCardGreen;
            break;
            
        default:
            break;
    }
    return tempColor;
}

//+ (NSString *)generateSM3TOTPTokenSeed{
//    
//    WJModelPerson *person = [WJGlobalVariable sharedInstance].defaultPerson;
//    
//    NSString *seed = [NSString stringWithFormat:@"%@%@", person.token, person.payPassword];
//    
//    return seed;
//}


+ (NSString *)generatePayCodeToken{
    
    WJModelPerson *person = [WJGlobalVariable sharedInstance].defaultPerson;
    
    NSString *first = [person.phone stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"86"];
    
    NSString *payCodeToken = [NSString stringWithFormat:@"%@%@", first, person.token];
    
    printf("payCodeToken -- %s\n", [payCodeToken UTF8String]);

    return payCodeToken;

}

//
//+ (ResetPsyType)getResetPayPasswordType{
//    
//    WJModelPerson *person = [WJGlobalVariable sharedInstance].defaultPerson;
//    if (person.isSetPayPassword) {
//        return ResetPsyTypeReset;
//    }
//    
//    return ResetPsyTypeInit;
//}


+ (BOOL)serverBaseUrlIsTest{
    
    NSString *netstatus = [[NSUserDefaults standardUserDefaults] objectForKey:@"netstatus"];

    return [netstatus isEqualToString:@"cbd"];
    
}


#pragma mark- TouchID Authenticate

+ (BOOL)touchIDIsAvailable
{
    if (IOS8_LATER) {
        
        LAContext *context = [LAContext new];
        NSError *error = nil;
        context.localizedFallbackTitle = @"输入密码";
        
        //检查设备是否支持Touch ID
        if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
            NSLog(@"恭喜，支持指纹验证！");
            return YES;
            
        }else{
            //不支持指纹识别，LOG出错误详情
            //失败的情况可能是设备本身不支持，例如旧版本的iPhone与iPad；运行在模拟器上；或者用户未开启Touch ID功能等。
            //可根据LAError枚举判断
            
            switch (error.code) {
                case LAErrorTouchIDNotEnrolled:
                {
                    //没有录入指纹
                    NSLog(@"TouchID is not enrolled");
                    break;
                }
                case LAErrorPasscodeNotSet:
                {
                    //添加指纹但是没有设置在指纹不可用时的解锁密码
                    NSLog(@"A passcode has not been set");
                    break;
                }
                default:
                {
                    NSLog(@"TouchID not available");
                    break;
                }
            }
            
            return NO;
        }
        
    }else{
        return NO;
    }
    
}

+ (NSString *)recordRequestUrlFilePath{

    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/requestInfo.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    }
    NSLog(@"路径：%@",filePath);
    return filePath;
}


+ (void)payPasswordVerifySuccess{
    NSString *filePath = [self payPasswordVerifyFailedErrorFilePatch];
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]initWithContentsOfFile:filePath];
    [dataDic setObject:@"0" forKey:@"errorCount"];
    [dataDic setObject:@"0" forKey:@"time"];
    [dataDic setObject:@"0" forKey:@"lockTime"];
    [dataDic writeToFile:filePath atomically:YES];
}


+ (NSString *)payPasswordVerifyFailedErrorFilePatch{
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray objectAtIndex:0];
    WJModelPerson *person = [WJGlobalVariable sharedInstance].defaultPerson;
    NSString *filePatch = [path stringByAppendingPathComponent:[person.userID stringByAppendingString:@"errorInformation.plist"]];
    NSLog(@"路径：%@",filePatch);
    return filePatch;
}

//处理金额字符串
+ (NSString *)changeMoneyString:(NSString *)money
{
    NSRange range = [money rangeOfString:@"."];
    if (range.length) {
        NSArray *moneyArray = [money componentsSeparatedByString:@"."];
        NSString *str_1 = [moneyArray objectAtIndex:0];
        NSString *str_2 = [moneyArray lastObject];
        if (str_2 == nil || [str_2 isEqualToString:@""] || [str_2 length] == 1 || [str_2 length] == 0) {
            return money;
        }else{
            if ([str_2 length] == 2) {
                NSString *subStr = [str_2 substringWithRange:NSMakeRange(1, 1)];
                if ([subStr isEqualToString:@"0"]) {
                    NSString *tmpStr = [str_2 substringWithRange:NSMakeRange(0, 1)];
                    if (![tmpStr isEqualToString:@"0"]) {
                        str_1 = [NSString stringWithFormat:@"%@.%@",str_1,str_2];
                    }
                }else{
                    str_1 = [NSString stringWithFormat:@"%@.%@",str_1,str_2];
                }
            }else{
                str_1 = [self roundBankers:[money floatValue] afterPoint:2];
            }
            return str_1;
        }
    }else{
        return money;
    }
    return @"";
}

//浮点型数据四舍五入
+ (NSString *)roundBankers:(float)number afterPoint:(int)position
{
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers
                                                                                                      scale:position
                                                                                           raiseOnExactness:NO
                                                                                            raiseOnOverflow:NO
                                                                                           raiseOnUnderflow:NO
                                                                                        raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:number];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

@end
