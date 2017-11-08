//
//  WJSystemAlertView.h
//  WanJiCard
//
//  Created by 孙琦 on 16/7/5.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSystemAlertViewTag 100003

@class WJSystemAlertView;
@protocol WJSystemAlertViewDelegate <NSObject>

@optional
- (void)wjAlertView:(WJSystemAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface WJSystemAlertView : UIView
{
    NSInteger _alertTag;
    NSString * _message;
    NSString * _title;
}
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *message;
@property (nonatomic, weak)id<WJSystemAlertViewDelegate>delegate;
@property(nonatomic,assign) NSInteger alertTag;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id<WJSystemAlertViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelTitle otherButtonTitles:(NSString *)otherTitles textAlignment:(NSTextAlignment)alignment;

- (void)showIn;

- (void)dismiss;

@end

