//
//  WJFaceValueModel.m
//  WanJiCard
//
//  Created by 林有亮 on 16/12/6.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJFaceValueModel.h"

@implementation WJFaceValueModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if(self == [super init])
    {
        self.sellValue = [NSString stringWithFormat:@"%.2f",[ToString(dic[@"bunNum"]) floatValue]];
        self.cardID = ToString(dic[@"id"]);
        self.faceValue = ToString(dic[@"thirdCardFacePrice"]);
    }
    return self;
}

@end
