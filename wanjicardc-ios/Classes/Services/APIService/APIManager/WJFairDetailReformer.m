//
//  WJFairDetailReformer.m
//  WanJiCard
//
//  Created by silinman on 16/8/23.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJFairDetailReformer.h"
#import "WJFairDetailModel.h"

@implementation WJFairDetailReformer

- (id)manager:(APIBaseManager *)manager reformData:(id)data
{
    WJFairDetailModel * cardModel;
    if ([data isKindOfClass:[NSDictionary class]]) {
        cardModel = [[WJFairDetailModel alloc] initWithDictionary:data];
    }
    return cardModel;
}

@end
