//
//  WJOrderDetailModel.h
//  WanJiCard
//
//  Created by Angie on 15/9/26.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WJOrderModel.h"
#import "WJStoreModel.h"

@interface WJOrderDetailModel : NSObject


@property (nonatomic, strong) WJOrderModel *orderInfo;
@property (nonatomic, assign) NSInteger supportStoreCount;
@property (nonatomic, strong) NSArray *storeArray;              //WJStoreModel集合
@property (nonatomic, strong) NSArray *privilegeArray;


- (id)initWithDic:(NSDictionary *)dic;

@end
