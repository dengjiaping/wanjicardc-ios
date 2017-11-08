//
//  WJUtilityMethod.m
//  WanJiCard
//
//  Created by Harry Hu on 15/8/28.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJUtilityMethod.h"
#import "SSKeychain.h"

#import "Reachability.h"
#import "WJDBAreaManager.h"


@implementation WJUtilityMethod

+ (BOOL) createDirectoryIfNotPresent:(NSString *)dirName
{
    //创建一个目录
    if (![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@", NSHomeDirectory(), dirName]]) {
        return [[NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithFormat:@"%@/%@", NSHomeDirectory(), dirName]
                                         withIntermediateDirectories:NO
                                                          attributes:nil
                                                               error:nil];
    }
    
    return YES;
}


+ (NSString *)keyChainValue:(BOOL)status{
    
    NSString *strUUID = nil;
    
    strUUID = [SSKeychain passwordForService:KeychainService account:KeychainAccount];
    if (status && (nil == strUUID || 1 > strUUID.length))
    {
        strUUID = [WJUtilityMethod encrypDeviceId];
        [SSKeychain setPassword:strUUID forService:KeychainService account:KeychainAccount];
    }
    
    
    return strUUID;
}

#pragma mark 图片处理
+ (UIImage *)imageFromColor:(UIColor *)color Width:(int)width Height:(int) height{
    CGRect rect = CGRectMake(0, 0,width,height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage *)imageFromView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0f);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    UIImage * snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshotImage;
}

+ (UIColor *)colorWithHexColorString:(NSString *)hexColorString{
    if ([hexColorString length] <6){//长度不合法
        return [UIColor blackColor];
    }
    NSString *tempString=[hexColorString lowercaseString];
    if ([tempString hasPrefix:@"0x"])
    {//检查开头是0x
        tempString = [tempString substringFromIndex:2];
    }else if ([tempString hasPrefix:@"#"])
    {//检查开头是#
        tempString = [tempString substringFromIndex:1];
    }
    if ([tempString length] !=6){
        return [UIColor blackColor];
    }
    //分解三种颜色的值
    NSRange range;
    range.location =0;
    range.length =2;
    NSString *rString = [tempString substringWithRange:range];
    range.location =2;
    NSString *gString = [tempString substringWithRange:range];
    range.location =4;
    NSString *bString = [tempString substringWithRange:range];
    //取三种颜色值
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString]scanHexInt:&r];
    [[NSScanner scannerWithString:gString]scanHexInt:&g];
    [[NSScanner scannerWithString:bString]scanHexInt:&b];
    return [UIColor colorWithRed:((float) r /255.0f)
                           green:((float) g /255.0f)
                            blue:((float) b /255.0f)
                           alpha:1.0f];
}


+ (NSAttributedString *)convertHtmlTextToAttributedString:(NSString *)htmlText{
    htmlText = @"<bold>Wow!</bold> Now <em>iOS</em> can create <h3>NSAttributedString</h3> from HTMLs!";
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithData:[htmlText dataUsingEncoding:NSUTF8StringEncoding]
                                                                      options:options
                                                           documentAttributes:nil
                                                                        error:nil];
    
    return attrString;
}



+ (NSDictionary *)attributesForUserTextWithCalculateMode:(BOOL)isCalculateMode
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3;
    paragraphStyle.lineBreakMode = isCalculateMode ? NSLineBreakByWordWrapping : NSLineBreakByTruncatingTail;
    
    return @{NSFontAttributeName : [UIFont systemFontOfSize:12],
             NSParagraphStyleAttributeName : paragraphStyle,
             NSForegroundColorAttributeName: [UIColor blackColor]};
}


+ (UIColor *)getColorFromImage:(UIImage *)image
{
    return [UIColor colorWithPatternImage:image];
}

+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}



//图片裁剪
+ (UIImage *)getImageFromImage:(UIImage*) superImage
                  subImageSize:(CGSize)subImageSize
                  subImageRect:(CGRect)subImageRect {
    //    CGSize subImageSize = CGSizeMake(WIDTH, HEIGHT); //定义裁剪的区域相对于原图片的位置
    //    CGRect subImageRect = CGRectMake(START_X, START_Y, WIDTH, HEIGHT);
    CGImageRef imageRef = superImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, subImageRect);
    UIGraphicsBeginImageContext(subImageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, subImageRect, subImageRef);
    UIImage* returnImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext(); //返回裁剪的部分图像
    return returnImage;
}


+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, (float)size.width, (float)size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIColor *)randomColor
{
    return COLOR(arc4random()%256, arc4random()%256, arc4random()%256, 1);
}

+ (BOOL)whetherIsFirstLoadAfterInstalled{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (![version isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"AppVersion"]]) {
        [[NSUserDefaults standardUserDefaults] setObject:version forKey:@"AppVersion"];
        return YES;
    }
    return NO;
}

+ (NSString *)floatNumberFomatter:(CGFloat)floatNumber{
    
    NSString* str;
    
    if (fmodf(floatNumber, 1)==0) {
        str = [NSString stringWithFormat:@"%.0f",floatNumber];
    } else if (fmodf(floatNumber*10, 1)==0) {
        str = [NSString stringWithFormat:@"%.1f",floatNumber];
    } else {
        str = [NSString stringWithFormat:@"%.2f",floatNumber];
    }
    return str;
}

+ (NSString *)floatNumberForMoneyFomatter:(CGFloat)floatNumber{
    
    NSString* str;
    
    str = [NSString stringWithFormat:@"%.2f",floatNumber];

    return str;
}

+ (NSString *)baoziNumberFormatter:(NSString *)numStr{

    NSString *str;
    if ([numStr floatValue] != [numStr intValue]) {
        str = [NSString stringWithFormat:@"%.2f",[numStr doubleValue]];
    }else{
    
        str = [NSString stringWithFormat:@"%d",[numStr intValue]];
    }
    return str;
}

+ (NSString *)dateStringFromDate:(NSDate *)date
                 withFormatStyle:(NSString *)formatStyle{
    
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:formatStyle];
    NSString *dateStr=[dateformatter stringFromDate:date];
    
    return dateStr;
}

+ (NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        [scanner scanUpToString:@"<" intoString:nil];
        [scanner scanUpToString:@">" intoString:&text];
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}

+ (NSString *)versionNumber{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];

    return version;
}


+ (BOOL)isValidatePhone:(NSString *)phone{
    NSString *phoneRegex = @"^[1][3-8][0-9]{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}


+ (BOOL)isValidateVerifyCode:(NSString *)code{
    NSString *codeRegex = @"^\\d{6}$";
    NSPredicate *codeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", codeRegex];
    return [codeTest evaluateWithObject:code];
}




+ (BOOL)isNotReachable {
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable && [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}


+ (NSString *)dealWithAreaName:(NSString *)areaName{
    NSString *name = areaName;
    if ([areaName hasSuffix:@"市辖区"]) {
        name = [areaName stringByReplacingOccurrencesOfString:@"市市辖区" withString:@""];
    }
    else if ([areaName hasSuffix:@"市"]) {
        name = [areaName stringByReplacingOccurrencesOfString:@"市" withString:@""];
    }
    return name;
}



+ (BOOL)isCross
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/User/Applications/"]) {
        NSLog(@"The device is jail broken!");
        NSArray *applist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/User/Applications/" error:nil];
        NSLog(@"applist = %@", applist);
        return YES;
    }
    NSLog(@"The device is NOT jail broken!");
    return NO;
}


+ (NSString *)encrypDeviceId
{
    //随机生成20位基础号
    NSMutableString *deviceId = [NSMutableString stringWithString:[WJUtilityMethod randomStrWithType:1]];
    
    //首尾4位随机字符串
    NSString *headRandom = [WJUtilityMethod randomStrWithType:2];
    NSString *tailRandom = [WJUtilityMethod randomStrWithType:2];
    
    //随机4位key
    NSString * firstKey = [WJUtilityMethod randomStrWithType:3];
    NSString * secondKey = nil;
    do {
        secondKey = [WJUtilityMethod randomStrWithType:3];
    } while ([[firstKey substringToIndex:1] isEqualToString:[secondKey substringToIndex:1]]);
    
    NSLog(@"%@ -- %@", [firstKey substringToIndex:1], [secondKey substringToIndex:1]);
    
    unsigned int firstLoc, secondLoc;
    [[NSScanner scannerWithString:[firstKey substringToIndex:1]] scanHexInt:&firstLoc];
    [[NSScanner scannerWithString:[secondKey substringToIndex:1]] scanHexInt:&secondLoc];

    [deviceId replaceCharactersInRange:NSMakeRange(firstLoc, 1) withString:[firstKey substringFromIndex:1]];
    [deviceId replaceCharactersInRange:NSMakeRange(secondLoc, 1) withString:[secondKey substringFromIndex:1]];
    
    return [NSString stringWithFormat:@"%@%@%@%@%@",headRandom,firstKey,deviceId,secondKey,tailRandom];
}


//生成随机字符串
+ (NSString *)randomStrWithType:(int)type
{
    
    NSString *str= @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    //生成由数字和字母组成的字符串
    if (type == 1 || type == 2) {

        int num = 20;
        
        if(type == 2){
            num = 4;
        }
        
        NSMutableString *value = [NSMutableString stringWithString:@""];
        while (num > 0) {
            
            int loc = arc4random() % 62;
            [value appendString:[str substringWithRange:NSMakeRange(loc, 1)]];
            num--;
        }
        
        return value;
        
    }else if (type == 3) {

        str = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
        NSString *oddString = [[NSString alloc] initWithFormat:@"%1x", arc4random() % 16];
        int strLoc = arc4random() % 52;
        NSString *evenStr = [str substringWithRange:NSMakeRange(strLoc, 1)];
        return [NSString stringWithFormat:@"%@%@", oddString, evenStr];
        
    }else{

        return @"";
    }
}


+ (BOOL)isValidateDevice:(NSString *)deviceId
{

    if (deviceId && deviceId.length == 32) {
        
        NSString *midStr = [deviceId substringWithRange:NSMakeRange(4, [deviceId length] - 8)];
        
        NSString *headKeyStr = [midStr substringToIndex:2];
        NSString *tailKeyStr = [midStr substringFromIndex:[midStr length]-2];
        
        NSString *verifyStr = [midStr substringWithRange:NSMakeRange(2, [midStr length]-4)];

        
        unsigned int firstKeyLoc, secondKeyLoc;
        [[NSScanner scannerWithString:[headKeyStr substringToIndex:1]]scanHexInt:&firstKeyLoc];
        [[NSScanner scannerWithString:[tailKeyStr substringToIndex:1]]scanHexInt:&secondKeyLoc];
        
        NSString *firstKey = [headKeyStr substringFromIndex:1];
        NSString *secondKey = [tailKeyStr substringFromIndex:1];
        
        NSString *firstVerify = [verifyStr substringWithRange:NSMakeRange(firstKeyLoc, 1)];
        NSString *secondVerify = [verifyStr substringWithRange:NSMakeRange(secondKeyLoc, 1)];

        if ([firstVerify isEqualToString:firstKey] &&
            [secondVerify isEqualToString:secondKey]) {
            
            return YES;
            
        }else{
            
            return NO;
        }
        
    }else{

        return NO;
    }
}


@end
