//
//  WJCashQRCodeModel.m
//  WanJiCard
//
//  Created by XT Xiong on 2016/11/28.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJCashQRCodeModel.h"

@implementation WJCashQRCodeModel

- (id)initWithDic:(NSDictionary *)dic
{
    if ([dic isKindOfClass:[NSDictionary class]]) {
        self.codeImageUrl     = dic[@"code_img_url"];
        self.payRemender      = dic[@"payRemender"];
        self.warmPrompt       = dic[@"warmPrompt"];
    }
    return self;
}

@end
