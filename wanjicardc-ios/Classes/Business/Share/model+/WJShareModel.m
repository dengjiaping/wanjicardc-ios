//
//  WJShareModel.m
//  WanJiCard
//
//  Created by wangzhangjie on 15/9/24.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJShareModel.h"

@implementation WJShareModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        
        self.title              = dic[@"title"];
        self.content            = dic[@"content"];
        self.shareContent       = dic[@"shareContent"];
        self.imgUrl             = dic[@"imgUrl"];
        self.shareImgUrl        = dic[@"shareImgUrl"];
        self.shareURL        = dic[@"titleUrl"];
    }
    return self;
}

@end
