//
//  WJContactModel.h
//  WanJiCard
//
//  Created by wangzhangjie on 15/9/27.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJContactModel : NSObject

@property(strong,nonatomic) NSString *name;


- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
