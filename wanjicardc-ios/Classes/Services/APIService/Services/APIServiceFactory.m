//
//  APIServiceFactory.m
//  LESports
//
//  Created by ZhangQibin on 15/6/18.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "APIServiceFactory.h"
#import "APIServiceWanJiKa.h"
#import "APIServiceCashTransfer.h"

//API
NSString *const kAPIServiceWanJiKa = @"APIServiceWanJiKa";
NSString *const kAPIServiceCashTransfer = @"APIServiceCashTransfer";


@interface APIServiceFactory ()

@property (nonatomic, strong) NSMutableDictionary *serviceStorage;

@end

@implementation APIServiceFactory
#pragma mark - life cycle
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static APIServiceFactory *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[APIServiceFactory alloc] init];
    });
    return sharedInstance;
}

#pragma mark - public methods
- (APIBaseService <APIBaseServiceProtocol> *)serviceWithIdentifier:(NSString *)identifier
{
    if (self.serviceStorage[identifier] == nil) {
        self.serviceStorage[identifier] = [self newServiceWithIdentifier:identifier];
    }
    return self.serviceStorage[identifier];
}

#pragma mark - private methods
//  根据不同的identifier生成不同的APIService
- (APIBaseService <APIBaseServiceProtocol> *)newServiceWithIdentifier:(NSString *)identifier
{
    if ([identifier isEqualToString:kAPIServiceWanJiKa]) {
        return [[APIServiceWanJiKa alloc] init];
    }
    if ([identifier isEqualToString:kAPIServiceCashTransfer]) {
        return [[APIServiceCashTransfer alloc] init];
    }
    return nil;
}

#pragma mark - getters and setters
- (NSMutableDictionary *)serviceStorage
{
    if (_serviceStorage == nil) {
        _serviceStorage = [[NSMutableDictionary alloc] init];
    }
    return _serviceStorage;
}

@end
