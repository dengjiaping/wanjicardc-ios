//
//  WJMaxCodeReformer.m
//  WanJiCard
//
//  Created by Lynn on 15/9/10.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJMaxCodeReformer.h"

@implementation WJMaxCodeReformer
- (id)manager:(APIBaseManager *)manager reformData:(id)data
{
    return  data[@"Name"];
}
@end
