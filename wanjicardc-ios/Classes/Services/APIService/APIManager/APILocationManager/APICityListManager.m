//
//  APICityListManager.m
//  WanJiCard
//
//  Created by Lynn on 15/9/6.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "APICityListManager.h"
#import "LocationManager.h"
#import "WJDBAreaVersionManager.h"

@implementation APICityListManager
#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.paramSource = self;
        self.validator = self;
        
        WJDBAreaVersionManager *areaVersionManager = [WJDBAreaVersionManager new];
        self.areaDBVersion = [areaVersionManager getAreaVersionNumber];

    }
    return self;
}


#pragma mark - APIManagerVaildator

- (BOOL)manager:(APIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data
{
    return [data[@"rspCode"] integerValue] == 0;
}


- (BOOL)manager:(APIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data
{
    return YES;
}

#pragma mark - APIManagerParamSourceDelegate

- (NSDictionary *)paramsForApi:(APIBaseManager *)manager
{
    NSLog(@"version========%@",NumberToString(self.areaDBVersion));
    return @{@"cityVersion":NumberToString(self.areaDBVersion)};
}

#pragma mark - APIManager Methods
- (NSString *)methodName
{
    return @"/wjkArea/openLists";
}

- (NSString *)serviceType
{
    return kAPIServiceWanJiKa;
}

- (APIManagerRequestType)requestType
{
    return APIManagerRequestTypePost;
}
@end
