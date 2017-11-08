//
//  SqliteManager.h
//  WanJiCard
//
//  Created by Harry Hu on 15/8/28.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>
#import "FMDB.h"

#define DATABASE_FOLDER             @"Documents/Database"

#define IS_VALID_ORDER(e)  ((e) >= ORDER_BY_NONE && (e) <= ORDER_BY_ASC)

@interface SqliteManager : NSObject

@property (atomic, retain) FMDatabase *db;

- (id)initWithDBPath:(NSString *)filePath;

- (void)upgradeTables;


/**
 *  判断表是否存在column，如果不存在就创建
 *
 *  @param table  表
 *  @param column 字段
 *  @param type   字段类型
 *
 *  @return 是否成功
 */
- (BOOL)updateTable:(NSString *)table
        existColumn:(NSString *)column
           withType:(NSString *)type;

// insert record into database
-(BOOL) insert:(NSString *) tableName withColumnsInArray:(NSArray *) columnsInArray withValuesInArray:(NSArray *) valuesInArray;
-(BOOL) insertList:(NSString *) tableName withColumnsInArray:(NSArray *) columnsInArray withValuesInArray:(NSArray *) valuesInArray;

// remove record from database
-(BOOL) remove:(NSString *) tableName withWhereClauses:(NSString *) whereClause withWhereArguments:(NSArray *) whereArgumentsInArray;

// update records within database
-(BOOL) update:(NSString *) tableName
 withSetClause:(NSString *) setClause
withSetArguments:(NSArray *) setArgumentsInArray
withWhereClause:(NSString *) whereClause
withWhereArguments:(NSArray *) whereArgumentsInArray;

-(BOOL) update:(NSString *) tableName
withSetDictionary:(NSDictionary *) setDictionary
withWhereClause:(NSString *) whereClause
withWhereArguments:(NSArray *) whereArgumentsInArray;

//query records from database
-(FMResultSet *) query:(NSString *) tableName
    withColumnsInArray:(NSArray *) columns
      withWhereClauses:(NSString *) whereClause
withWhereArgumentsInArray:(NSArray *) whereArgmentsInArray
           withOrderBy:(NSString *) orderBy
          withOderType:(TS_ORDER_E) order;

-(FMResultSet*) querySql:(NSString*)sql;

-(BOOL) executeSQLUpdate:(NSString *) sqlStatement;

- (void)checkError;

@end

