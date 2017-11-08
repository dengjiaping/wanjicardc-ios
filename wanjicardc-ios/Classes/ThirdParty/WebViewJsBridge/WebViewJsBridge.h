//
//  WebViewJsBridge.h
//
//
//  Created by
//  Copyright (c) 2014年 . All rights reserved.
//

#import <Foundation/Foundation.h>

#define kCustomProtocolScheme @"other"
#define kBridgeName           @"wjika"

typedef void(^JSBridgeReslut) (NSArray *args);


@interface WebViewJsBridge : NSObject<UIWebViewDelegate>

@property (nonatomic, weak) UIWebView *webView;

@property (nonatomic, copy) JSBridgeReslut result;

+ (instancetype)bridgeForWebView:(UIWebView*)webView webViewDelegate:(NSObject<UIWebViewDelegate>*)webViewDelegate result:(void (^)(NSArray *args))result;

+ (instancetype)bridgeForWebView:(UIWebView*)webView webViewDelegate:(NSObject<UIWebViewDelegate>*)webViewDelegate resourceBundle:(NSBundle*)bundle result:(void (^)(NSArray *))result;

- (void)excuteJSWithObj:(NSString *)obj function:(NSString *)function;

@end
