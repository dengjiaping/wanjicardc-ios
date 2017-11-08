//
//  WJRealNameInformationsModel.m
//  WanJiCard
//
//  Created by maying on 2017/8/12.
//  Copyright © 2017年 WJIKA. All rights reserved.
//

#import "WJRealNameInformationsModel.h"

@implementation WJRealNameInformationsModel
- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.userIdcard               = ToString(dic[@"userIdcard"]);
        self.userRealname          = ToString(dic[@"userRealname"]);
    }
    return self;
}
@end
