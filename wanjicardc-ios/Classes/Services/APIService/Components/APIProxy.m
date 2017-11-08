 //
//  APIProxy.m
//  LESports
//
//  Created by ZhangQibin on 15/6/18.
//  Copyright (c) 2015年 LETV. All rights reserved.
//

#import "APIProxy.h"
#import "AFNetworking.h"
#import "APIRequestGenerator.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "WJHttpsManager.h"

static NSString * const kAXApiProxyDispatchItemKeyCallbackSuccess = @"kAXApiProxyDispatchItemCallbackSuccess";
static NSString * const kAXApiProxyDispatchItemKeyCallbackFail = @"kAXApiProxyDispatchItemCallbackFail";

@interface APIProxy ()

@property (nonatomic, strong) NSMutableDictionary *dispatchTable;
@property (nonatomic, strong) NSNumber *recordedRequestId;

//AFNetworking stuff
@property (nonatomic, strong) AFHTTPSessionManager *operationManager;

@end

@implementation APIProxy
#pragma mark - life cycle
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static APIProxy *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[APIProxy alloc] init];
    });
    return sharedInstance;
}

#pragma mark - public methods
- (void)callGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(APICallBack)success fail:(APICallBack)fail
{
    NSURLRequest *request = [[APIRequestGenerator sharedInstance] generateGETRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    [self callApiWithRequest:request success:success fail:fail];
//    return request.URL.absoluteString;
}

- (void)callPOSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(APICallBack)success fail:(APICallBack)fail
{
    NSURLRequest *request = [[APIRequestGenerator sharedInstance] generatePOSTRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    [self callApiWithRequest:request success:success fail:fail];
//    return request.URL.absoluteString;
}

#pragma mark - private methods
/** 这个函数存在的意义在于，如果将来要把AFNetworking换掉，只要修改这个函数的实现即可。 */
- (void)callApiWithRequest:(NSURLRequest *)request success:(APICallBack)success fail:(APICallBack)fail
{
    [[self.operationManager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            if(error.code == -999)
            {
                return ;
            }
            APIURLResponse *urlResponse = [[APIURLResponse alloc] initWithResponseData:responseObject error:error];
//            fail ? fail(urlResponse) : nil;
            if (fail) {
                fail(urlResponse);
            }
        } else {
            APIURLResponse *urlResponse = [[APIURLResponse alloc] initWithResponseData:responseObject status:APIURLResponseStatusSuccess];
//            success ? success(urlResponse) : nil;
            if (success) {
                success(urlResponse);
            }
        }
    }] resume];
}

#pragma mark - getters and setters
- (NSMutableDictionary *)dispatchTable
{
    if (_dispatchTable == nil) {
        _dispatchTable = [[NSMutableDictionary alloc] init];
    }
    return _dispatchTable;
}

- (AFHTTPSessionManager *)operationManager
{
    if (_operationManager == nil) {
//        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//        securityPolicy.allowInvalidCertificates = YES;
//        [AFHTTPSessionManager manager].securityPolicy = securityPolicy;
        
        _operationManager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil];
        _operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _operationManager.responseSerializer.acceptableContentTypes = [_operationManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        [_operationManager setSecurityPolicy:[WJHttpsManager customSecurityPolicy]];
    }
    return _operationManager;
}

@end
