//
//  WJCashQRCodeReformer.m
//  WanJiCard
//
//  Created by XT Xiong on 2016/11/28.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJCashQRCodeReformer.h"
#import "WJCashQRCodeModel.h"

@implementation WJCashQRCodeReformer

- (id)manager:(APIBaseManager *)manager reformData:(id)data
{
    WJCashQRCodeModel * cashQRCodeModel = [[WJCashQRCodeModel alloc] initWithDic:data];
    
    return cashQRCodeModel;
}


@end
