//
//  NSManagedObject+Helper.h
//  LESports
//
//  Created by HuHarry on 15/6/15.
//  Copyright (c) 2015年 LETV. All rights reserved.
//


#import "NSManagedObject+Helper.h"
#import <CoreData/CoreData.h>

typedef void(^ListResult)(NSArray* result, NSError *error);

typedef void(^ObjectResult)(id result, NSError *error);

typedef void(^ErrorBlock)(NSError *error);

@interface NSManagedObject (Helper)

//+(id)createNew;
//
//+(void)saveObject:(ErrorBlock)handler;
//
//
//+(NSArray*)filterWithPredicate:(NSString *)predicate
//                       orderby:(NSArray *)orders
//                        offset:(int)offset
//                         limit:(int)limit;
//
//+(void)filterWithPredicate:(NSString *)predicate
//                   orderby:(NSArray *)orders
//                    offset:(int)offset
//                     limit:(int)limit
//                        on:(ListResult)handler;
//
//+(id)oneWithPredicate:(NSString*)predicate;
//
//+(void)oneWithPredicate:(NSString*)predicate
//                     on:(ObjectResult)handler;
//
//+(void)delobject:(id)object;


@end

