//
//  WJUpgradeAlert.h
//  WanJiCard
//
//  Created by 孙明月 on 16/1/18.
//  Copyright © 2016年 zOne. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kWJAlertTag 100002

@class WJUpgradeAlert;
@protocol WJUpgradeAlertDelegate <NSObject>

@optional
- (void)wjUpgradeAlert:(WJUpgradeAlert *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface WJUpgradeAlert : UIView
@property (nonatomic, weak)id<WJUpgradeAlertDelegate>delegate;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *message;
@property(nonatomic,assign) NSInteger alertTag;

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id<WJUpgradeAlertDelegate>)delegate cancelButtonTitle:(NSString *)cancelTitle otherButtonTitles:(NSString *)otherTitles;

- (void)showIn;

- (void)dismiss;

@end
