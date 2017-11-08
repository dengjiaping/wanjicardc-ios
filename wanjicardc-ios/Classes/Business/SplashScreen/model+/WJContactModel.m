//
//  WJContactModel.m
//  WanJiCard
//
//  Created by wangzhangjie on 15/9/27.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJContactModel.h"

@implementation WJContactModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        
       
        self.name           = dic[@"Name"];
        
       // self.amount        =   [NSString stringWithFormat:@"%@",dic[@"Amount"] ];
       
    }
    return self;
}


@end
