//
//  WJPassView.h
//  WanJiCard
//
//  Created by 林有亮 on 16/8/17.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kBuyECardPsdAlertViewTag 100005

typedef enum
{
    PassViewTypeInputPassword = 0,
    PassViewTypeSubmit,
    PassViewTypeSubmitTip
}PassViewType;

@class WJPassView;
@protocol WJPassViewDelegate <NSObject>

@optional

- (void)successWithVerifyPsdAlert:(WJPassView *)alertView;
- (void)failedWithVerifyPsdAlert:(WJPassView *)alertView errerMessage:(NSString * )errerMessage isLocked:(BOOL)isLocked;

- (void)payWithAlert:(WJPassView *)alertView;

- (void)RechargeWithAlert:(WJPassView *)alertView;

- (void)forgetPasswordActionWith:(WJPassView *)alertView;

- (void)helpAction;

@end

@interface WJPassView : UIView

@property (nonatomic, weak) id<WJPassViewDelegate> delegate;
@property(nonatomic,assign) NSInteger alertTag;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title cardName:(NSString *)cardName faceValue:(NSString *)faceValue cardNum:(NSString *)cardNum
                 baoziNeedNum:(NSString *)baoziNeedNum baoziHasNum:(NSString *)baoziHasNum passViewType:(PassViewType)passViewType;

- (void)showIn;

- (void)dismiss;


@end
