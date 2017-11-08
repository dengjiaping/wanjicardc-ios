//
//  WJConsumeNewsModel.h
//  WanJiCard
//
//  Created by XT Xiong on 16/7/6.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

//消费和资产

#import <Foundation/Foundation.h>

@interface WJConsumeNewsModel : NSObject

@property(nonatomic,strong) NSString     * money;
@property(nonatomic,strong) NSString     * reqParam;
@property(nonatomic,strong) NSString     * type;
@property(nonatomic,strong) NSString     * date;
@property(nonatomic,strong) NSString     * time;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
