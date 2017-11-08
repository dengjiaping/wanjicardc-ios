//
//  WJWapAlipayController.h
//  WanJiCard
//
//  Created by Angie on 15/9/11.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJViewController.h"

@protocol WJWapAlipayControllerDelegate <NSObject>

@optional

- (void)wapAlipayFinish:(BOOL)success;

@end

@interface WJWapAlipayController : WJViewController<UIWebViewDelegate, NSURLConnectionDataDelegate>
{
    UIWebView *_webView;
}

@property (nonatomic, strong) NSString *html;
@property (nonatomic, weak) id <WJWapAlipayControllerDelegate> delegate;


@end
