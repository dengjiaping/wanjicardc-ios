//
//  BaseDBManager.h
//  WanJiCard
//
//  Created by Harry Hu on 15/8/28.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WJDBTableKeys.h"
#import <FMDB/FMDB.h>

@class SqliteManager;

@interface BaseDBManager : NSObject

@property (nonatomic, strong) SqliteManager *sqliteManager;

- (FMResultSet *)queryInTable:(NSString *)table
             withWhereClauses:(NSString *)whereClause
           withWhereArguments:(NSArray *)whereArgumentsInArray
                  withOrderBy:(NSString *) order
                withOrderType:(TS_ORDER_E) orderType;


- (FMResultSet *)queryAllInTable:(NSString *)table;


- (FMResultSet*)querySql:(NSString*)sql;
@end
