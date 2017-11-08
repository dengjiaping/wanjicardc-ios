//
//  WJMerchantImageModel.m
//  WanJiCard
//
//  Created by Angie on 15/9/24.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJMerchantImageModel.h"

@implementation WJMerchantImageModel

- (id)initWithDic:(NSDictionary *)dic{
    if (self = [super initWithDic:dic]) {
        
        self.picId = ToString(dic[@"merchantPhotoId"]);
        self.imgUrl = ToString(dic[@"merchantPhotoAppsrc"]);
        self.cType = (ColorType)[dic[@"photoType"] integerValue];
        self.desc = ToString(dic[@"merchantPhotoName"]);
    }
    return self;
}
@end
