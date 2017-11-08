//
//  WJSupportBankReformer.m
//  WanJiCard
//
//  Created by reborn on 16/9/1.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJSupportBankReformer.h"
#import "WJSupportBankModel.h"

@implementation WJSupportBankReformer
- (id)manager:(APIBaseManager *)manager reformData:(id)data
{
    NSMutableArray * result = [NSMutableArray array];
    if ([data[@"banks"] isKindOfClass:[NSArray class]]) {
        for (id obj in data[@"banks"]) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                WJSupportBankModel * supportBankModel = [[WJSupportBankModel alloc] initWithDictionary:obj];
                [result addObject:supportBankModel];
            }
        }
    }
    
    return result;
}
@end
