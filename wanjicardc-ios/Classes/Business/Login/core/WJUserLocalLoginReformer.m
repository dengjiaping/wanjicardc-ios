//
//  WJUserLocalLoginReformer.m
//  WanJiCard
//
//  Created by Lynn on 15/8/31.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJUserLocalLoginReformer.h"
#import "WJPersonModel.h"

@implementation WJUserLocalLoginReformer

- (id)manager:(APIBaseManager *)manager reformData:(id)data
{
    WJPersonModel * person = [[WJPersonModel alloc] initWithData:data];
    
    return person;
}

@end
