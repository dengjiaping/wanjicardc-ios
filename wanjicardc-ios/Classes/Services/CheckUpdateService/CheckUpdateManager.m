//
//  CheckUpdateManager.m
//  WanJiCard
//
//  Created by Angie on 16/1/27.
//  Copyright © 2016年 zOne. All rights reserved.
//

#import "CheckUpdateManager.h"
#import <AFNetworking/AFHTTPSessionManager.h>


#define AppId           @"1021840697"
#define AppDownloadUrl  @"https://itunes.apple.com/lookup?id="##AppId

@implementation CheckUpdateManager

+ (void)checkAppUpdate{
    
    [CheckUpdateManager checkUpdateWithAppID:@"1021840697" success:^(NSDictionary *resultDic, BOOL isNewVersion, NSString *releaseNotes) {
        
        if (isNewVersion) {
            NSString *versionStr =[[[resultDic objectForKey:@"results"] firstObject] valueForKey:@"version"];
            NSString *trackViewUrl = [[[resultDic objectForKey:@"results"] firstObject] valueForKey:@"trackViewUrl"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kAppNeedUpdate" object:nil userInfo:@{@"newVersion":versionStr,@"trackViewUrl":trackViewUrl}];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"请求App版本信息失败");
    }];
}

+ (void)checkUpdateWithAppID:(NSString *)appID success:(void (^)(NSDictionary *resultDic , BOOL isNewVersion , NSString * releaseNotes))success failure:(void (^)(NSError *error))failure
{
    NSString *encodingUrl=[[@"https://itunes.apple.com/lookup?id=" stringByAppendingString:appID] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:encodingUrl
      parameters:nil
        progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSString * versionStr =[[[resultDic objectForKey:@"results"] firstObject] valueForKey:@"version"];

        NSCharacterSet *doNotWantStr = [NSCharacterSet characterSetWithCharactersInString:@"."];
        versionStr = [[versionStr componentsSeparatedByCharactersInSet:doNotWantStr] componentsJoinedByString:@""];
      
        NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
        NSString *currentVersion = [infoDic valueForKey:@"CFBundleShortVersionString"];
        currentVersion = [[currentVersion componentsSeparatedByCharactersInSet:doNotWantStr] componentsJoinedByString:@""];
        
        NSString *releaseNote = [[resultDic[@"results"] firstObject] valueForKey:@"releaseNotes"];
        
        if([versionStr intValue] > [currentVersion intValue]){
            
            success(resultDic, YES, releaseNote);
            
        }else{
            
            success(resultDic,NO ,releaseNote);
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        
    }];
    
}
@end
