//
//  WJShareServices.h
//  WanJiCard
//
//  Created by XT Xiong on 16/8/26.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WJShareUI.h"

@interface WJShareServices : NSObject<ShareChoiceDelegate>

+ (instancetype)sharedServices;

- (void)ShareSendController:(UIViewController *)controller
                    LinkURL:(NSString *)urlString
                    TagName:(NSString *)tagName
                      Title:(NSString *)title
                Description:(NSString *)description
                 ThumbImage:(NSString *)thumbImage;

@end
