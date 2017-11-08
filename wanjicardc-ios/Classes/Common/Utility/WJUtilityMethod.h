//
//  WJUtilityMethod.h
//  WanJiCard
//
//  Created by Harry Hu on 15/8/28.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJUtilityMethod : NSObject


+ (BOOL) createDirectoryIfNotPresent:(NSString *)dirName;

+ (UIColor *)randomColor;//测试专用

+(UIColor *)colorWithHexColorString:(NSString *)hexColorString;

+ (NSString *)keyChainValue:(BOOL)status;

#pragma mark 图片处理
+ (UIImage *)imageFromColor:(UIColor *)color Width:(int)width Height:(int) height;
+ (UIImage *)imageFromView:(UIView *)view;

+ (NSAttributedString *)convertHtmlTextToAttributedString:(NSString *)htmlText;



#pragma mark - 图片与颜色转化
+ (UIColor *)getColorFromImage:(UIImage *)image;

+ (UIImage *)createImageWithColor:(UIColor *)color;

//图片裁剪
+ (UIImage *)getImageFromImage:(UIImage*)superImage
                  subImageSize:(CGSize)subImageSize
                  subImageRect:(CGRect)subImageRect;

+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size;

#pragma mark -
+ (BOOL)whetherIsFirstLoadAfterInstalled;

+ (NSString *)floatNumberFomatter:(CGFloat)floatNumber;
//金额专用
+ (NSString *)floatNumberForMoneyFomatter:(CGFloat)floatNumber;

//包子数
+ (NSString *)baoziNumberFormatter:(NSString *)numStr;

+ (NSString *)dateStringFromDate:(NSDate *)date
                 withFormatStyle:(NSString *)formatStyle;
+ (NSString *)filterHTML:(NSString *)html;


+ (NSString *)versionNumber;

+ (BOOL)isValidatePhone:(NSString *)phone;

+ (BOOL)isValidateVerifyCode:(NSString *)code;

+ (BOOL)isNotReachable;

/**
 *  @author HZQ, 16-03-15 11:03:58
 *
 *  系统地址反解析城市名处理
 *
 *  @param areaName city名
 *
 *  @return 城市名
 */
+ (NSString *)dealWithAreaName:(NSString *)areaName;


+ (BOOL)isCross;

//生成32位 Device ID
+ (NSString *)encrypDeviceId;

//验证Device ID
+ (BOOL)isValidateDevice:(NSString *)deviceId;

@end

