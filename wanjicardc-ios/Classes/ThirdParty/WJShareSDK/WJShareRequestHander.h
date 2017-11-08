//
//  WJShareRequestHander.h
//  WanJiCard
//
//  Created by XT Xiong on 16/8/23.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>

@interface WJShareRequestHander : NSObject

+ (BOOL)WXSendLinkURL:(NSString *)urlString
              TagName:(NSString *)tagName
                Title:(NSString *)title
          Description:(NSString *)description
           ThumbImage:(UIImage *)thumbImage
              InScene:(enum WXScene)scene;


+ (BOOL)QQSendLinkURL:(NSString *)urlString
                Title:(NSString *)title
          Description:(NSString *)description
           ThumbImage:(NSString *)thumbImage;


+ (BOOL)WBSendLinkURL:(NSString *)urlString
             ObjectID:(NSString *)objectID
                Title:(NSString *)title
          Description:(NSString *)description
           ThumbImage:(NSData *)thumbImage
     ShareMessageFrom:(NSString *)shareMessageFrom;
@end
