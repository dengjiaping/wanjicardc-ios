//
//  WJDBAreaManager.m
//  WanJiCard
//
//  Created by Harry Hu on 15/9/1.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJDBAreaManager.h"
#import "WJSqliteBaseManager.h"


@implementation WJDBAreaManager

- (instancetype)init{
    if (self = [super init]) {
        self.sqliteManager = [WJSqliteBaseManager sharedManager];
    }
    return self;
}

- (BOOL)insertArea:(WJModelArea*)area{
    if (0 == area.areaId) {
        NSLog(@"parameter is invalid");
        return NO;
    }
    WJModelArea *oldModelArea=nil;
    FMResultSet *cursor = [self queryInTable:TABLE_AREA
                            withWhereClauses:@"AreaId = ?"
                          withWhereArguments:@[area.areaId]
                                 withOrderBy:COL_AREA_ID
                               withOrderType:ORDER_BY_ASC];
    while ([cursor next]) {
        oldModelArea = [[WJModelArea alloc] initWithCursor:cursor];
        break;
    }
    [cursor close];

    
    if(oldModelArea){
        return [self updateArea:area];
    }
    
    return [self.sqliteManager insert:TABLE_AREA
                  withColumnsInArray:@[COL_AREA_ID,
                                      COL_AREA_NAME,
                                      COL_AREA_ONAME,
                                      COL_AREA_ORDERNAME,
                                      COL_AREA_LEVEL,
                                      COL_AREA_PARENTID,
                                      COL_AREA_ISHOT,
                                      COL_AREA_LAT,
                                      COL_AREA_LNG,
                                      COL_AREA_ZOOM,
                                      COL_AREA_REGION,
                                      COL_AREA_ISUSE]
                   withValuesInArray:@[area.areaId,
                                       area.name?:@"",
                                       area.oname?:@"",
                                       area.orderName?:@"",
                                       @(area.level),
                                       area.parentid,
                                       @(area.ishot),
                                       @(area.lat),
                                       @(area.lng),
                                       @(area.zoom),
                                       @(area.region),
                                       @(area.isUse)]];
  
}


- (BOOL)updateArea:(WJModelArea*)area{
    
    NSDictionary *areaDic = @{COL_AREA_NAME:    area.name?:@"",
                              COL_AREA_ONAME:   area.oname?:@"",
                              COL_AREA_ORDERNAME:area.orderName?:@"",
                              COL_AREA_LEVEL:   @(area.level),
                              COL_AREA_PARENTID:area.parentid,
                              COL_AREA_ISHOT:   @(area.ishot),
                              COL_AREA_LAT:     @(area.lat),
                              COL_AREA_LNG:     @(area.lng),
                              COL_AREA_ZOOM:    @(area.zoom),
                              COL_AREA_REGION:  @(area.region),
                              COL_AREA_ISUSE:   @(area.isUse)};
    
    return [self.sqliteManager update:TABLE_AREA
                    withSetDictionary:areaDic
                      withWhereClause:@"AreaId = ?"
                   withWhereArguments:@[area.areaId]];
}

- (BOOL)remove:(NSString *)areaId{
    if (0 == areaId)
    {
        NSLog(@"parameter is invalid");
        return NO;
    }
    
    return [self.sqliteManager remove:TABLE_AREA
                     withWhereClauses:@"AreaId = ?"
                   withWhereArguments:@[areaId]];
}






#pragma mark - 具体接口

-(NSMutableArray *)getSubAreaByParentId:(NSString *)parentId
{
    
    NSMutableArray *areaList = [[NSMutableArray alloc]init];

    FMResultSet *cursor = [self queryInTable:TABLE_AREA
                            withWhereClauses:@"Parentid = ?"
                          withWhereArguments:@[parentId]
                                 withOrderBy:COL_AREA_ORDERNAME
                               withOrderType:ORDER_BY_ASC];
    
    while ([cursor next]) {
        WJModelArea *area = [[WJModelArea alloc] initWithCursor:cursor];
        [areaList addObject:area];
    }
    [cursor close];
    
    return areaList;
}

- (WJModelArea *)getAreaByAreaId:(NSString *)areaId{
    
    FMResultSet *cursor = [self queryInTable:TABLE_AREA
                            withWhereClauses:@"AreaId = ?"
                          withWhereArguments:@[areaId]
                                 withOrderBy:COL_AREA_ORDERNAME
                               withOrderType:ORDER_BY_ASC];
    WJModelArea *area = nil;
    while ([cursor next]) {
        area = [[WJModelArea alloc] initWithCursor:cursor];
        break;
    }
    [cursor close];
    
    return area;
}


-(NSMutableArray *)getAreaByLevel:(NSInteger)level{
    
    NSMutableArray *areaList = [[NSMutableArray alloc]init];
    
    FMResultSet *cursor = [self queryInTable:TABLE_AREA
                            withWhereClauses:@"Level = ? and IsUse = ?"
                          withWhereArguments:@[@(level), @YES]
                                 withOrderBy:COL_AREA_ORDERNAME
                               withOrderType:ORDER_BY_ASC];
    
    while ([cursor next]) {
        WJModelArea *area = [[WJModelArea alloc] initWithCursor:cursor];
        [areaList addObject:area];
    }
    [cursor close];
    
    return areaList;

}

-(NSMutableArray *)getAllAreasByLevel:(NSInteger)level
{
    NSMutableArray *areaList = [[NSMutableArray alloc]init];
    
    FMResultSet *cursor = [self queryInTable:TABLE_AREA
                            withWhereClauses:@"Level = ?"
                          withWhereArguments:@[@(level)]
                                 withOrderBy:COL_AREA_ORDERNAME
                               withOrderType:ORDER_BY_ASC];
    
    while ([cursor next]) {
        WJModelArea *area = [[WJModelArea alloc] initWithCursor:cursor];
        [areaList addObject:area];
    }
    [cursor close];
    
    return areaList;

}


- (WJModelArea *)getAreaByCityName:(NSString *)cityName{
    WJModelArea *area = nil;
    
    NSString *sql = [NSString stringWithFormat:@"select * from WJKAreaTable where Name like '%%%@%%' and Level = 2", cityName];
    
    FMResultSet *cursor = [self.sqliteManager querySql:sql];
    while ([cursor next]) {
        area = [[WJModelArea alloc] initWithCursor:cursor];
    }
    [cursor close];
    
    return area;
}

- (WJModelArea *)getAreaByProvinceName:(NSString *)ProvinceName{
    WJModelArea *area = nil;
    
    NSString *sql = [NSString stringWithFormat:@"select * from WJKAreaTable where Name like '%%%@%%' and Level = 1", ProvinceName];
    
    FMResultSet *cursor = [self.sqliteManager querySql:sql];
    while ([cursor next]) {
        area = [[WJModelArea alloc] initWithCursor:cursor];
    }
    [cursor close];
    
    return area;

}


- (BOOL)isActivelyCity:(NSString *)areaId{
    
    NSString *sql = [NSString stringWithFormat:@"select IsUse from WJKAreaTable where AreaId = %@", areaId];
    FMResultSet *cursor = [self.sqliteManager querySql:sql];
    BOOL result = NO;
    while ([cursor next]) {
        result = [cursor boolForColumn:@"IsUse"];
        break;
    }
    [cursor close];
    
    return result;
    
}


@end
