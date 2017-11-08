//
//  WJBunsTrandsRecordReformer.m
//  WanJiCard
//
//  Created by silinman on 16/8/24.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJBunsTrandsRecordReformer.h"
#import "WJMyBunsRecordModel.h"

@implementation WJBunsTrandsRecordReformer

- (id)manager:(APIBaseManager *)manager reformData:(id)data
{
    WJMyBunsRecordModel * recordModel;
    if ([data isKindOfClass:[NSDictionary class]]) {
        recordModel = [[WJMyBunsRecordModel alloc] initWithDictionary:data];
    }
    return recordModel;
}

@end
