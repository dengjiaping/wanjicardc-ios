//
//  WJShare.m
//  WanJiCard
//
//  Created by XT Xiong on 16/8/24.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJShare.h"
#import "WJShareServices.h"

@implementation WJShare

+ (void)sendShareController:(UIViewController *)controller
                    LinkURL:(NSString *)urlString
                    TagName:(NSString *)tagName
                      Title:(NSString *)title
                Description:(NSString *)description
                 ThumbImage:(NSString *)thumbImage
{
    [[WJShareServices sharedServices] ShareSendController:controller
                                LinkURL:urlString
                                TagName:tagName
                                  Title:title
                            Description:description
                             ThumbImage:thumbImage];
}

@end
