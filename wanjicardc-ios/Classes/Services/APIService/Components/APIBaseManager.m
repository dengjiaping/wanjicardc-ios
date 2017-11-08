//
//  APIBaseManager.m
//  LESports
//
//  Created by ZhangQibin on 15/6/18.
//  Copyright (c) 2015年 LETV. All rights reserved.
//

#import "APIBaseManager.h"
#import "AFNetworkReachabilityManager.h"
#import "APIProxy.h"
#import "WJConstKey.h"
//#import "SecurityService.h"

#define AXCallAPI(REQUEST_METHOD)                                                       \
{                                                                                       \
[[APIProxy sharedInstance] call##REQUEST_METHOD##WithParams:apiParams serviceIdentifier:self.child.serviceType methodName:self.child.methodName success:^(APIURLResponse *response) { \
[self successedOnCallingAPI:response];                                          \
} fail:^(APIURLResponse *response) {                                                \
[self failedOnCallingAPI:response withErrorType:APIManagerErrorTypeDefault];  \
}];                                                                                 \
}


@interface APIBaseManager ()

@property (nonatomic, strong, readwrite) id fetchedRawData;
@property (nonatomic, copy, readwrite) NSString *errorMessage;
@property (nonatomic, readwrite) APIManagerErrorType errorType;
@property (nonatomic, readwrite) NSInteger errorCode;
@property (nonatomic, assign, readwrite) BOOL isRequesting;

@end

@implementation APIBaseManager
#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        _delegate = nil;
        _validator = nil;
        _paramSource = nil;
        _fetchedRawData = nil;
        _errorMessage = nil;
        _errorType = APIManagerErrorTypeDefault;
        _cachePolicy = NOCACHE;
        _isRequesting = NO;
        if ([self conformsToProtocol:@protocol(APIManager)]) {
            self.child = (id <APIManager>)self;
        }
    }
    return self;
}

#pragma mark - public methods
- (void)loadData
{
    NSDictionary *params = [self.paramSource paramsForApi:self];

    if (self.isRequesting) {
        return;
    }
    self.isRequesting = YES;
    
    [self loadDataWithParams:params];
}

- (void)loadLocalData
{
    
}

- (id)fetchDataWithReformer:(id<APIManagerCallbackDataReformer>)reformer
{
    id resultData = nil;
    if ([reformer conformsToProtocol:@protocol(APIManagerCallbackDataReformer)]) {
        resultData = [reformer manager:self reformData:self.fetchedRawData];
    } else {
        if ([self.fetchedRawData conformsToProtocol:@protocol(NSMutableCopying)]) {
            resultData = [self.fetchedRawData mutableCopy];
        }else{
            resultData = self.fetchedRawData;
        }
    }
    return resultData;
}

#pragma mark - calling api
- (void)loadDataWithParams:(NSDictionary *)params
{
    NSDictionary *apiParams = [self reformParams:params];
    
    if ([self shouldCallAPIWithParams:apiParams]) {
        if ([self.validator manager:self isCorrectWithParamsData:apiParams]) {
            
            // 实际的网络请求
            if ([self isReachable]) {
                switch (self.child.requestType)
                {
                    case APIManagerRequestTypeGet:
                        AXCallAPI(GET);
                    
                        break;
                    case APIManagerRequestTypePost:
//                        AXCallAPI(self.requestUrlString, POST);
                        AXCallAPI(POST);
                        break;
                    default:
                        break;
                }
           
                NSMutableDictionary *params = [apiParams mutableCopy];
                [self afterCallingAPIWithParams:params];
            } else {
                [self failedOnCallingAPI:nil withErrorType:APIManagerErrorTypeNoNetwork];
            }
        } else {
            [self failedOnCallingAPI:nil withErrorType:APIManagerErrorTypeParamsError];
        }
    }
}



//- (NSArray *)fetchWithPredicate:(NSString *)predicate limit:(NSInteger)limit count:(NSInteger)count type:(StoreModelType)type
//{
//    
//    NSArray *results = [[LEDataStorageManager sharedInstance] selectObjcet:predicate
//                                     withStoreModelType:type
//                                         completeHandle:^(NSError *error) {
//    
//                                         }];
//    
//    return results;
//}

#pragma mark - api callbacks

- (void)successedOnCallingAPI:(APIURLResponse *)response
{
    self.isRequesting = NO;
    if(response.content[@"rspMsg"]!=nil)
    {
        self.errorMessage = response.content[@"rspMsg"];
    }
    
    if ([response.content[@"rspCode"] integerValue] > 0) {

        //补充错误码和错误信息；
        self.errorMessage = response.content[@"rspMsg"];
        if ([response.content[@"rspCode"] isEqualToString:@"50009003"] || [response.content[@"rspCode"] isEqualToString:@"50008082"]) {
            self.errorType = APIManagerErrorTypeNoLogin;
            [kDefaultCenter postNotificationName:kNoLogin object:self.errorMessage];
        }
    }
    
    if (self.shouldParse)
    {
        NSDictionary *dict = response.content[@"val"];
        if ([dict isKindOfClass:[NSNull class]]) {
            [self failedOnCallingAPI:response withErrorType:APIManagerErrorTypeNoData];
            return;
        }
        
        NSArray * array = dict[@"result"];
        if (array.count > 0) {
            
            if (self.fetchedRawData && self.shouldCleanData) {
                [self cleanData];
            }
            
            if (self.fetchedRawData) {
                self.fetchedRawData = [self.fetchedRawData arrayByAddingObjectsFromArray:array];
            }else {
                self.fetchedRawData = array;
            }
        }
        
        if ([dict[@"total"] integerValue] <= [self.fetchedRawData count]) {
            self.hadGotAllData = YES;
        }else{
            self.hadGotAllData = NO;
        }

    } else {
        self.fetchedRawData = response.content[@"val"];
    }
    
    
    if (([response.content[@"rspCode"] integerValue] == 0) && [self.validator manager:self isCorrectWithCallBackData:response.content]) {
        
        [self beforePerformSuccessWithResponse:response];
        [self.delegate managerCallAPIDidSuccess:self];
        [self afterPerformSuccessWithResponse:response];
        
    } else {
        
        if ([response.content[@"rspCode"] integerValue] == 0) {
            
            [self failedOnCallingAPI:response withErrorType:APIManagerErrorTypeNoData];

        }else{
            
            [self failedOnCallingAPI:response withErrorType:APIManagerErrorTypeNoContent];
        }
    }
}


- (void)failedOnCallingAPI:(APIURLResponse *)response withErrorType:(APIManagerErrorType)errorType
{
    self.isRequesting = NO;
    self.errorType = errorType;
    self.errorCode = [ToNSNumber(response.content[@"rspCode"]) integerValue];
    
 
    self.errorMessage = ToString(response.content[@"rspMsg"]);
    NSLog(@"error -- %@", response.content[@"rspMsg"]);
    [self beforePerformFailWithResponse:response];
   
    if(self.errorCode == 50009003 || self.errorCode == 50008082){
        [self.delegate managerCallAPIDidFailed:nil];
    }else{
        [self.delegate managerCallAPIDidFailed:self];
    }
    
    [self afterPerformFailWithResponse:response];
}

#pragma mark - method for interceptor

/*
 拦截器的功能可以由子类通过继承实现，也可以由其它对象实现,两种做法可以共存
 当两种情况共存的时候，子类重载的方法一定要调用一下super
 然后它们的调用顺序是BaseManager会先调用子类重载的实现，再调用外部interceptor的实现
 
 notes:
 正常情况下，拦截器是通过代理的方式实现的，因此可以不需要以下这些代码
 但是为了将来拓展方便，如果在调用拦截器之前manager又希望自己能够先做一些事情，所以这些方法还是需要能够被继承重载的
 所有重载的方法，都要调用一下super,这样才能保证外部interceptor能够被调到
 这就是decorate pattern
 */

- (void)beforePerformSuccessWithResponse:(APIURLResponse *)response
{
    self.errorType = APIManagerErrorTypeSuccess;
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(beforePerformSuccessWithResponse:)]) {
        [self.interceptor manager:self beforePerformSuccessWithResponse:response];
    }
}

- (void)afterPerformSuccessWithResponse:(APIURLResponse *)response
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(afterPerformSuccessWithResponse:)]) {
        [self.interceptor manager:self afterPerformSuccessWithResponse:response];
    }
}

- (void)beforePerformFailWithResponse:(APIURLResponse *)response
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(beforePerformFailWithResponse:)]) {
        [self.interceptor manager:self beforePerformFailWithResponse:response];
    }
}

- (void)afterPerformFailWithResponse:(APIURLResponse *)response
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(afterPerformFailWithResponse:)]) {
        [self.interceptor manager:self afterPerformFailWithResponse:response];
    }
}

//只有返回YES才会继续调用API
- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params
{
//    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(shouldCallAPIWithParams:)]) {
//        return [self.interceptor manager:self shouldCallAPIWithParams:params];
//    } else {
        return YES;
//    }
}

- (void)afterCallingAPIWithParams:(NSDictionary *)params
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(afterCallingAPIWithParams:)]) {
        [self.interceptor manager:self afterCallingAPIWithParams:params];
    }
}


#pragma mark - method for child

- (void)cleanData
{
    IMP childIMP = [self.child methodForSelector:@selector(cleanData)];
    IMP selfIMP = [self methodForSelector:@selector(cleanData)];
    
    if (childIMP == selfIMP) {
        self.fetchedRawData = nil;
        self.errorMessage = nil;
        self.errorType = APIManagerErrorTypeDefault;
    }else {
        if ([self.child respondsToSelector:@selector(cleanData)]) {
            [self.child cleanData];
        }
    }
}

//如果需要在调用API之前额外添加一些参数，比如pageNumber和pageSize之类的就在这里添加
//子类中覆盖这个函数的时候就不需要调用[super reformParams:params]了
- (NSDictionary *)reformParams:(NSDictionary *)params
{
    IMP childIMP = [self.child methodForSelector:@selector(reformParams:)];
    IMP selfIMP = [self methodForSelector:@selector(reformParams:)];
    
    if (childIMP == selfIMP) {
        return params;
    } else {
        // 如果child是继承得来的，那么这里就不会跑到，会直接跑子类中的IMP。
        // 如果child是另一个对象，就会跑到这里
        NSDictionary *result = nil;
        result = [self.child reformParams:params];
        if (result) {
            return result;
        } else {
            return params;
        }
    }
}

- (NSArray *)converNetDataToStoreModel:(NSArray *)array{
    
    IMP childIMP = [self.child methodForSelector:@selector(reformParams:)];
    IMP selfIMP = [self methodForSelector:@selector(reformParams:)];
    
    NSArray *results = array;
    if (childIMP != selfIMP)
    {
        // 如果child是继承得来的，那么这里就不会跑到，会直接跑子类中的IMP。
        // 如果child是另一个对象，就会跑到这里
        results = [self.child converNetDataToStoreModel:array];
    }
    
    return results;
}

#pragma mark - getters and setters
- (BOOL)isReachable
{
    BOOL isReachability = NO;
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusUnknown) {
        isReachability = YES;
    } else {
        isReachability = [[AFNetworkReachabilityManager sharedManager] isReachable];
    }
    
    if (!isReachability) {
        self.errorType = APIManagerErrorTypeNoNetwork;
    }
    return isReachability;
}





@end
