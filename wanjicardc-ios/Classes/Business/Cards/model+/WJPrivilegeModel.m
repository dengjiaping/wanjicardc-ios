//
//  WJPrivilegeModel.m
//  WanJiCard
//
//  Created by Harry Hu on 15/8/31.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJPrivilegeModel.h"

@implementation WJPrivilegeModel

- (id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        
        self.condition = ToString(dic[@"useExplain"]);
        self.detail = ToString(dic[@"name"]);
        self.iconUrl = ToString(dic[@"url"]);
        self.type = [dic[@"category"] integerValue];// 0:固定特权   1:浮动特权
    }
    
    return self;
}



@end
