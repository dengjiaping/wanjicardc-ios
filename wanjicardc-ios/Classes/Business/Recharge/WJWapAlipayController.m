//
//  WJWapAlipayController.m
//  WanJiCard
//
//  Created by Angie on 15/9/11.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJWapAlipayController.h"

@interface WJWapAlipayController ()

- (BOOL)isMainNetUrl:(NSString *)originalUrl;

@end

@implementation WJWapAlipayController
@synthesize html = _html;
@synthesize delegate = _delegate;

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    _webView.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_webView removeFromSuperview];
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, self.view.height)];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    [_webView loadHTMLString:self.html baseURL:nil];
    [self.view addSubview:_webView];
}


- (void)backBarButton:(UIButton *)btn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(wapAlipayFinish:)]) {
        [self.delegate wapAlipayFinish:NO];
    }
}

#pragma mark -- UIWebViewDelegate methods
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *originalUrl = [request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    BOOL su = NO;
    if ([originalUrl rangeOfString:@"result"].length > 0 && [originalUrl rangeOfString:@"callback"].length > 0) {
        if ([[originalUrl substringWithRange:NSMakeRange([originalUrl rangeOfString:@"result"].location+[originalUrl rangeOfString:@"result"].length + 1, 4)] isEqualToString:@"succ"]) {
            su = YES;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(wapAlipayFinish:)]) {
            [self.delegate wapAlipayFinish:su];
        }
    }else if ([self isMainNetUrl:originalUrl]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(wapAlipayFinish:)]) {
            
            [self.delegate wapAlipayFinish:YES];
        }
    }
    return YES;
}

//判断是否支付完成
- (BOOL)isMainNetUrl:(NSString *)originalUrl
{
    NSArray* filterArray = @[@"wjika.cn", @"wjika.com", @"wjika.net"];
    BOOL existInFilter = NO;
    for (NSString* filter in filterArray) {
        NSRange range = [originalUrl rangeOfString:filter];
        if (range.location < [originalUrl length]) {
            existInFilter = YES;
            break;
        }
    }
    return existInFilter;
}


@end
