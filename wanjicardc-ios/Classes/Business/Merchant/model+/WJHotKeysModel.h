//
//  HotKeysModel.h
//  WanJiCard
//
//  Created by Lynn on 15/9/23.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJHotKeysModel : NSObject

@property (nonatomic, strong)NSString   *countNum;
@property (nonatomic, strong)NSString   *name;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
