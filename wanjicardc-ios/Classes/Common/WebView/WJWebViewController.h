//
//  WJWebViewController.h
//  WanJiCard
//
//  Created by Lynn on 15/9/30.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJViewController.h"

@interface WJWebViewController : WJViewController

@property (nonatomic, strong) UIWebView             *webView;
@property (nonatomic, assign) BOOL                  isShowPriManual;
@property (nonatomic, strong) NSString              *merID;
@property (nonatomic, strong) NSString              *titleStr;

- (void)loadWeb:(NSString *)urlString;

@end
