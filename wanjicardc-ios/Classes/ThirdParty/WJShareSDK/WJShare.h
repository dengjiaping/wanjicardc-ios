//
//  WJShare.h
//  WanJiCard
//
//  Created by XT Xiong on 16/8/24.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJShare : NSObject

+ (void)sendShareController:(UIViewController *)controller
                    LinkURL:(NSString *)urlString
                    TagName:(NSString *)tagName
                      Title:(NSString *)title
                Description:(NSString *)description
                 ThumbImage:(NSString *)thumbImage;

@end
