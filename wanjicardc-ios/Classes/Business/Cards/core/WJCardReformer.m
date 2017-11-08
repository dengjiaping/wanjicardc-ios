//
//  WJCardReformer.m
//  WanJiCard
//
//  Created by Lynn on 15/9/22.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJCardReformer.h"
#import "WJMyCardPackageModel.h"

@implementation WJCardReformer

- (id)manager:(APIBaseManager *)manager reformData:(id)data
{
    WJMyCardPackageModel *myCardPackageModel = [[WJMyCardPackageModel alloc] initWithDic:data];
    
    return myCardPackageModel;
}
@end
