//
//  WJAreaReformer.m
//  WanJiCard
//
//  Created by Harry Hu on 15/9/19.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJAreaReformer.h"
#import "WJModelArea.h"


@implementation WJAreaReformer

- (id)manager:(APIBaseManager *)manager reformData:(id)data{
    
    WJModelArea *area = [[WJModelArea alloc] initWithDic:data];
    
    return area;
}

@end
