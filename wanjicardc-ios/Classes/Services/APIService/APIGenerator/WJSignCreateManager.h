//
//  WJSignCreateManager.h
//  WanJiCard
//
//  Created by Lynn on 15/12/15.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJSignCreateManager : NSObject

+ (NSDictionary *)postSignWithDic:(NSMutableDictionary *)dict methodName:(NSString *)methodName;

+ (NSDictionary *)getSignWithDic:(NSMutableDictionary *)dict methodName:(NSString *)methodName;

+ (NSString *)createSingByDictionary:(NSDictionary *)dict;
@end
