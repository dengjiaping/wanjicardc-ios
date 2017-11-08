//
//  WJPrivilegeModel.h
//  WanJiCard
//
//  Created by Harry Hu on 15/8/31.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJPrivilegeModel : NSObject

@property (nonatomic, strong) NSString *condition;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSString *iconUrl;


@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, assign) BOOL isOwn;
@property (nonatomic, assign) NSInteger type;

- (id)initWithDic:(NSDictionary *)dic;

@end
