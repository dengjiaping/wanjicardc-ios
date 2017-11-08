//
//  WJDBAreaManager.h
//  WanJiCard
//
//  Created by Harry Hu on 15/9/1.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDBManager.h"
#import "WJModelArea.h"

@interface WJDBAreaManager : BaseDBManager

- (BOOL)insertArea:(WJModelArea*)area;

- (BOOL)updateArea:(WJModelArea*)area;

- (BOOL)remove:(NSString *)areaId;

-(NSMutableArray *)getSubAreaByParentId:(NSString *)parentId;

-(NSMutableArray *)getAreaByLevel:(NSInteger)level;//省1 城市2

-(NSMutableArray *)getAllAreasByLevel:(NSInteger)level;//省1 城市2

- (WJModelArea *)getAreaByAreaId:(NSString *)areaId;

- (WJModelArea *)getAreaByCityName:(NSString *)cityName;

- (BOOL)isActivelyCity:(NSString *)areaId;
//wzj
- (WJModelArea *)getAreaByProvinceName:(NSString *)ProvinceName;

@end
