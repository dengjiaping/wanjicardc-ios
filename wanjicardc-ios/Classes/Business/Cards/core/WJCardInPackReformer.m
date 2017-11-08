//
//  WJCardInPackReformer.m
//  WanJiCard
//
//  Created by 孙明月 on 16/2/24.
//  Copyright © 2016年 zOne. All rights reserved.
//

#import "WJCardInPackReformer.h"
#import "WJMyCardPackageDetailModel.h"

@implementation WJCardInPackReformer
- (id)manager:(APIBaseManager *)manager reformData:(id)data{
    
    WJMyCardPackageDetailModel *detailCard = [[WJMyCardPackageDetailModel alloc] initWithDic:data];
    
    return detailCard;
    
}

@end
