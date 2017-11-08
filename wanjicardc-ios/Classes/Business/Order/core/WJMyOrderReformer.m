//
//  WJMyOrderReformer.m
//  WanJiCard
//
//  Created by Harry Hu on 15/9/19.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJMyOrderReformer.h"
#import "WJOrderModel.h"

@implementation WJMyOrderReformer

- (id)manager:(APIBaseManager *)manager reformData:(id)data{
    
    WJOrderModel *order = [[WJOrderModel alloc] initWithDic:data];
    
    return order;
}
@end
