//
//  SqliteManager.m
//  WanJiCard
//
//  Created by Harry Hu on 15/8/28.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "SqliteManager.h"
#import "FMDB.h"

@interface SqliteManager()

@property (nonatomic, strong) FMDatabaseQueue *queue;

- (NSString *)combineNamesArray:(NSArray *)namesInArray;
- (NSString *)composeQuestionMarks:(NSArray *)valuesInArray;

@end

@implementation SqliteManager

- (id)initWithDBPath:(NSString *)filePath
{
    if(self= [super init])
    {
        BOOL su = [WJUtilityMethod createDirectoryIfNotPresent:DATABASE_FOLDER];
        NSAssert(su, @"创建数据库文件夹失败");
//        [self openDB:filePath];
        NSString *dbfolder = [NSString stringWithFormat:@"%@/%@/%@"
                              , NSHomeDirectory()
                              , DATABASE_FOLDER, filePath];
        self.queue = [FMDatabaseQueue databaseQueueWithPath:dbfolder];
        __weak typeof(self) weakSelf = self;
        [self.queue inDatabase:^(FMDatabase *db) {
            weakSelf.db = db;
        }];
    }
    
    return self;
}

- (void)dealloc
{
    @synchronized(self)
    {
        [self closeDB];
    }
}


- (void)openDB:(NSString *)DBFileName
{
    @synchronized(self) {
        NSFileManager *fm = [NSFileManager defaultManager];

        NSString *dbfolder = [NSString stringWithFormat:@"%@/%@"
                              , NSHomeDirectory()
                              , DATABASE_FOLDER];

        NSError *error = nil;
        if (![fm fileExistsAtPath:dbfolder]) {
            NSLog(@"start to create database folder");
            if (![fm createDirectoryAtPath:dbfolder
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:&error]) {
                NSLog(@"Ooops, cannot create database folder - %@", dbfolder);
                return;
            }
        }
        ;

        NSString* dbfile = [dbfolder stringByAppendingPathComponent:DBFileName];
        FMDatabase* db = [FMDatabase databaseWithPath:dbfile];
        if (![db open]) {
            NSLog(@"Ooops, cannot open the database - %@", dbfile);
            return;
        }
        self.db = db;
    }
}

- (void)closeDB
{
    @synchronized(self) {
        [self.db close];
    }
}


- (void)upgradeTables
{
    
}

- (BOOL)updateTable:(NSString *)table existColumn:(NSString *)column withType:(NSString *)type{
    NSString *vercifySqlStr = [NSString stringWithFormat:@"select %@ from %@ where rowid = 1", column, table];
    if ([self.db executeQuery:vercifySqlStr] == nil) {
        return [self.db executeUpdate:[NSString stringWithFormat:@"alter table %@ add column %@ %@", table, column, type]];
    }
    
    return YES;
}


- (NSString *)composeQuestionMarks:(NSArray *) valuesInArray
{
    NSMutableString *clause = [[NSMutableString alloc] init];
    
    NSInteger placeHolderNum = [valuesInArray count];
    for (int i = 0; i < placeHolderNum; ++i) {
        [clause appendString:@" ?"];
        if (i < placeHolderNum - 1) {
            [clause appendString:@","];
        }
    }
    [clause appendString:@" "];
    
    return clause;
}


- (NSString *)combineNamesArray:(NSArray *) namesInArray
{
    NSMutableString *clause = [[NSMutableString alloc] init];
    NSInteger placeHolderNum = [namesInArray count];
    for (int i = 0; i < placeHolderNum; ++i) {
        [clause appendFormat:@" %@", [namesInArray objectAtIndex:i]];
        if (i < placeHolderNum - 1) {
            [clause appendString:@","];
        }
    }
    
    return clause;
    
}

- (BOOL)executeSQLUpdate:(NSString *) sqlStatement
{
    [self.queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:sqlStatement];
    }];
 
    return YES;
}


- (BOOL)    insert:(NSString *) tableName
withColumnsInArray:(NSArray *) columnsInArray
 withValuesInArray:(NSArray *) valuesInArray
{
    /*
     * SQL specification:
     *       INSERT INTO tablename (columns,...) VALUES (values,...);
     */
    if (nil == columnsInArray || nil == valuesInArray || [columnsInArray count] != [valuesInArray count]) {
        NSLog(@"parameter is invalid");
        return NO;
    }
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO  %@ (%@) VALUES (%@) ",
                     tableName, [self combineNamesArray:columnsInArray], [self composeQuestionMarks:valuesInArray]];

    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            [self.db executeUpdate:sql withArgumentsInArray:valuesInArray];

    }];
    
    return YES;
}

- (BOOL)insertList:(NSString *) tableName
withColumnsInArray:(NSArray *) columnsInArray
 withValuesInArray:(NSArray *) valuesInArray{

    if (nil == columnsInArray || nil == valuesInArray ) {
        NSLog(@"parameter is invalid");
        return NO;
    }
    
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {

        for(NSArray *valueArry in valuesInArray){
            NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO  %@ (%@) VALUES (%@);",
                             tableName, [self combineNamesArray:columnsInArray], [self composeQuestionMarks:valueArry]];
            [self.db executeUpdate:sql withArgumentsInArray:valueArry];
        }
        
    }];
    
    return YES;
}



- (BOOL)remove:(NSString *) tableName withWhereClauses:(NSString *) whereClause withWhereArguments:(NSArray *) whereArgumentsInArray
{
    /*
     * SQL specification:
     *      DELETE FROM tablename WHERE ...;
     */
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@", tableName, whereClause];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:sql withArgumentsInArray:whereArgumentsInArray];
    }];

    
    return YES;
}

- (BOOL)    update:(NSString *) tableName
     withSetClause:(NSString *) setClause
  withSetArguments:(NSArray *) setArgumentsInArray
   withWhereClause:(NSString *) whereClause
withWhereArguments:(NSArray *) whereArgumentsInArray
{
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ %@",
                     tableName,
                     setClause,
                     whereClause ? [NSString stringWithFormat:@"WHERE %@", whereClause] : @""];
    
    NSMutableArray *args = [[NSMutableArray alloc] initWithCapacity:
                            [setArgumentsInArray count] + [whereArgumentsInArray count]];
    for (id object in setArgumentsInArray) {
        [args addObject:object];
    }
    for (id object in whereArgumentsInArray) {
        [args addObject:object];
    }
    
    // NSLog(@"Database update:%@", sql);
    [self.queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:sql withArgumentsInArray:args];
    }];
    
    return YES;
}

- (BOOL)    update:(NSString *) tableName
 withSetDictionary:(NSDictionary *) setDictionary
   withWhereClause:(NSString *) whereClause
withWhereArguments:(NSArray *) whereArgumentsInArray
{
    if (nil == tableName || nil == setDictionary || nil == whereClause || nil == whereArgumentsInArray)
    {
        NSLog(@"parameter is invalid");
        return NO;
    }
    
    BOOL result = NO;
    NSArray *keys = [setDictionary allKeys];
    NSMutableString *setClause = [[NSMutableString alloc] init];
    BOOL isFirst = YES;
    for (NSString *column in keys) {
        [setClause appendFormat:@"%@ %@ = ? ", (isFirst ? @"": @","), column];
        isFirst = NO;
    }
    
    result = [self update:tableName
            withSetClause:setClause
         withSetArguments:[setDictionary allValues]
          withWhereClause:whereClause
       withWhereArguments:whereArgumentsInArray];
    
    return result;
}

- (FMResultSet *)query:(NSString *) tableName
    withColumnsInArray:(NSArray *) columns
      withWhereClauses:(NSString *) whereClause
withWhereArgumentsInArray:(NSArray *) whereArgmentsInArray
           withOrderBy:(NSString *) orderBy withOderType:(TS_ORDER_E) order
{
    /*
     *  SQL specification:
     *      SELECT columnname,... FROM tablename,... [WHERE ...] [ORDER BY ...];
     */
    NSString *sql = [NSString stringWithFormat:@"SELECT %@ FROM %@ %@  ORDER BY %@ %@",
                     [NSString stringWithFormat:@"rowid, %@", columns ? [self combineNamesArray:columns] : @"*"],
                     tableName,
                     whereClause ? [NSString stringWithFormat:@"WHERE %@", whereClause] : @"",
                     orderBy == nil ? @"" : orderBy,
                     orderBy ? (ORDER_BY_ASC == order ? @"ASC" : @"DESC") : @"rowid ASC"];
    
    //NSLog(@"Database query:%@", sql);
    
    __block FMResultSet *cursor = nil;
    dispatch_semaphore_t semap = dispatch_semaphore_create(0);
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *tes = nil;
        if (whereArgmentsInArray) {
            tes = [self.db executeQuery:sql withArgumentsInArray:whereArgmentsInArray];
        } else {
            tes = [self.db executeQuery:sql];
        }
        tes.statement.inUse = NO;
        cursor = [FMResultSet resultSetWithStatement:tes.statement usingParentDatabase:db];
        [tes close];
        dispatch_semaphore_signal(semap);
    }];
    dispatch_semaphore_wait(semap, DISPATCH_TIME_FOREVER);
    
    return cursor;
}

- (FMResultSet*)querySql:(NSString*)sql{
    
    __block FMResultSet *cursor = nil;
    dispatch_semaphore_t semap = dispatch_semaphore_create(0);
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *tes = [db executeQuery:sql];
        tes.statement.inUse = NO;
        cursor = [FMResultSet resultSetWithStatement:tes.statement usingParentDatabase:db];
        [tes close];
        dispatch_semaphore_signal(semap);
    }];
    dispatch_semaphore_wait(semap, DISPATCH_TIME_FOREVER);
   
    return cursor;
}

- (void)checkError
{
    if ([self.db hadError]) {
        NSLog(@"!!!Database Error!!! %d: %@", [self.db lastErrorCode], [self.db lastErrorMessage]);
    }
}

@end
