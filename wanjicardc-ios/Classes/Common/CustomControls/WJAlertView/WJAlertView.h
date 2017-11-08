//
//  WJAlertView.h
//  WanJiCard
//
//  Created by 孙明月 on 16/1/16.
//  Copyright © 2016年 zOne. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kAlertViewTag 100001

@class WJAlertView;
@protocol WJAlertViewDelegate <NSObject>

@optional
- (void)wjAlertView:(WJAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end


@interface WJAlertView : UIView
{
    NSInteger _alertTag;
}
@property (nonatomic, weak)id<WJAlertViewDelegate>delegate;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *message;
@property(nonatomic,assign) NSInteger alertTag;

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id<WJAlertViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelTitle otherButtonTitles:(NSString *)otherTitles textAlignment:(NSTextAlignment)alignment;

- (void)showIn;
- (void)dismiss;


@end
