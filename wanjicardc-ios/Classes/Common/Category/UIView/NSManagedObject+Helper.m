//
//  NSManagedObject+helper.m
//  LESports
//
//  Created by HuHarry on 15/6/15.
//  Copyright (c) 2015年 LETV. All rights reserved.
//

#import "NSManagedObject+Helper.h"

@implementation NSManagedObject (Helper)

//+ (id)createNew
//{
//    NSString *className = [NSString stringWithUTF8String:object_getClassName(self)];
//    return [NSEntityDescription insertNewObjectForEntityForName:className inManagedObjectContext:[NSManagedObjectContext MR_defaultContext]];
//}
//
//+ (void)saveObject:(ErrorBlock)handler
//{
//    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
//        if (handler) {
//            handler(error);
//        }
//    }];
//}
//
//+ (NSArray*)filterWithPredicate:(NSString *)predicate orderby:(NSArray *)orders offset:(int)offset limit:(int)limit
//{
//    NSManagedObjectContext *ctx = [NSManagedObjectContext MR_defaultContext];
//    NSFetchRequest *fetchRequest = [self makeRequest:ctx predicate:predicate orderby:orders offset:offset limit:limit];
//    
//    NSError* error = nil;
//    NSArray* results = [ctx executeFetchRequest:fetchRequest error:&error];
//    if (error) {
//        NSLog(@"error: %@", error);
//        return @[];
//    }
//    return results;
//}
//
//+ (NSFetchRequest*)makeRequest:(NSManagedObjectContext*)ctx predicate:(NSString*)predicate orderby:(NSArray*)orders offset:(int)offset limit:(int)limit
//{
//    NSString *className = [NSString stringWithUTF8String:object_getClassName(self)];
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    [fetchRequest setEntity:[NSEntityDescription entityForName:className inManagedObjectContext:ctx]];
//    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:predicate]];
//    NSMutableArray *orderArray = [[NSMutableArray alloc] init];
//    if (orders!=nil) {
//        for (NSString *order in orders) {
//            NSSortDescriptor *orderDesc = nil;
//            if ([[order substringToIndex:1] isEqualToString:@"-"]) {
//                orderDesc = [[NSSortDescriptor alloc] initWithKey:[order substringFromIndex:1]
//                                                        ascending:NO];
//            } else {
//                orderDesc = [[NSSortDescriptor alloc] initWithKey:order
//                                                        ascending:YES];
//            }
//        }
//        [fetchRequest setSortDescriptors:orderArray];
//    }
//    if (offset>0) {
//        [fetchRequest setFetchOffset:offset];
//    }
//    if (limit>0) {
//        [fetchRequest setFetchLimit:limit];
//    }
//    return fetchRequest;
//}
//
//+ (void)filterWithPredicate:(NSString *)predicate orderby:(NSArray *)orders offset:(int)offset limit:(int)limit on:(ListResult)handler
//{
//    NSManagedObjectContext *ctx = [NSManagedObjectContext MR_defaultContext];
//    [ctx performBlock:^{
//        NSFetchRequest *fetchRequest = [self makeRequest:ctx predicate:predicate orderby:orders offset:offset limit:limit];
//        NSError* error = nil;
//        NSArray* results = [ctx executeFetchRequest:fetchRequest error:&error];
//        if (error) {
//            NSLog(@"error: %@", error);
//            [ctx performBlock:^{
//                handler(@[], nil);
//            }];
//        }
//        if ([results count] < 1) {
//            [ctx performBlock:^{
//                handler(@[], nil);
//            }];
//        }
//        NSMutableArray *result_ids = [[NSMutableArray alloc] init];
//        for (NSManagedObject *item  in results) {
//            NSLog(@"id=%@", item.objectID);
//            [result_ids addObject:item.objectID];
//        }
//        [ctx performBlock:^{
//            NSMutableArray *final_results = [[NSMutableArray alloc] init];
//            for (NSManagedObjectID *oid in result_ids) {
//                [final_results addObject:[ctx objectWithID:oid]];
//            }
//            handler(final_results, nil);
//        }];
//    }];
//}
//
//+ (id)oneWithPredicate:(NSString*)predicate
//{
//    NSManagedObjectContext *ctx = [NSManagedObjectContext MR_defaultContext];
//    NSFetchRequest *fetchRequest = [self makeRequest:ctx predicate:predicate orderby:nil offset:0 limit:1];
//    NSError* error = nil;
//    NSArray* results = [ctx executeFetchRequest:fetchRequest error:&error];
//
//    return [results firstObject];
//}
//
//+ (void)oneWithPredicate:(NSString*)predicate on:(ObjectResult)handler
//{
//    NSManagedObjectContext *ctx = [NSManagedObjectContext MR_defaultContext];
//    [ctx performBlock:^{
//        NSFetchRequest *fetchRequest = [self makeRequest:ctx predicate:predicate orderby:nil offset:0 limit:1];
//        NSError* error = nil;
//        NSArray* results = [ctx executeFetchRequest:fetchRequest error:&error];
//        if (error) {
//            NSLog(@"error: %@", error);
//            [ctx performBlock:^{
//                handler(@[], nil);
//            }];
//        }
//        if ([results count]<1) {
//            [ctx performBlock:^{
//                handler(@[], nil);
//            }];
//        }
//        NSManagedObjectID *objId = ((NSManagedObject*)results[0]).objectID;
//        [ctx performBlock:^{
//            handler([ctx objectWithID:objId], nil);
//        }];
//    }];
//}
//
//+ (void)delobject:(id)object
//{
//    [[NSManagedObjectContext MR_defaultContext] deleteObject:object];
//}

@end