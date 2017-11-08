//
//  WJCardDetailReformer.m
//  WanJiCard
//
//  Created by Harry Hu on 15/9/19.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJCardDetailReformer.h"
#import "WJMerchantCardDetailModel.h"

@interface WJCardDetailReformer ()

@end


@implementation WJCardDetailReformer

- (id)manager:(APIBaseManager *)manager reformData:(id)data{
    
    WJMerchantCardDetailModel *detailCard = [[WJMerchantCardDetailModel alloc] initWithDic:data];
    
    return detailCard;
    
}


@end
