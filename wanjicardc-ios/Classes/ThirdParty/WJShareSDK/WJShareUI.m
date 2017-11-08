//
//  WJShareUI.m
//  WanJiCard
//
//  Created by XT Xiong on 16/8/23.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJShareUI.h"

#define ButtonWith 50

#define LiftEdge (kScreenWidth - ALD(20) - ButtonWith * 4)/5
#define ButtonDistance (kScreenWidth - ALD(20) - ButtonWith * 4)/5
#define KdeviceSystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]

@interface WJShareUI (){
    int liftWith;
}


@property (strong,nonatomic) UIPickerView         * pickView;

@property (strong,nonatomic) UIViewController     * controller;
@property (strong,nonatomic) UIAlertController    * alert;
@property (strong,nonatomic) UIActionSheet        * actionSheet;
@property (strong,nonatomic) UIButton             * WXButton;
@property (strong,nonatomic) UIButton             * WXPButton;
@property (strong,nonatomic) UIButton             * QQButton;
@property (strong,nonatomic) UIButton             * WBButton;

@property (strong,nonatomic) NSArray              * shareOrderArray;
@property (assign,nonatomic) NSInteger              buttonTag;



@end

@implementation WJShareUI

- (void)presentViewController:(UIViewController *)controller ShareOrderArray:(NSArray *)shareOrderArray
{
    self.controller = controller;
    self.shareOrderArray = shareOrderArray;
    if (KdeviceSystemVersion >= 8.0) {
        liftWith = LiftEdge;
        [controller presentViewController:self.alert animated:YES completion:nil];
    }else{
        liftWith = LiftEdge + 8;
        [self.actionSheet showInView:controller.navigationController.view];
    }
}

- (UIAlertController *)alert
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"\n\n\n\n\n\n"] message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self addSubviewToAlertview:alert.view];
    return alert;
}

- (UIActionSheet *)actionSheet
{
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"\n\n\n\n\n\n"] delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
    [self addSubviewToAlertview:actionSheet];
    return actionSheet;
}

- (UIButton *)QQButton
{
    return [self createButtonTitle:@"QQ好友" ImageNamed:@"Shared_QQ" Tag:111001];
}

- (UIButton *)WXPButton
{
    return [self createButtonTitle:@"朋友圈" ImageNamed:@"Shared_Friend" Tag:111002];
}

- (UIButton *)WXButton
{
    return [self createButtonTitle:@"微信好友" ImageNamed:@"Shared_Wechat" Tag:111003];
}

- (UIButton *)WBButton
{
    return [self createButtonTitle:@"新浪微博" ImageNamed:@"Shared_Weibo" Tag:111004];
}

- (UIButton *)createButtonTitle:(NSString *)title ImageNamed:(NSString *)imageNamed Tag:(int)tag
{
    NSInteger tagNum = self.buttonTag - 111000;
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(liftWith + (ButtonDistance + ButtonWith) * (tagNum - 1), ALD(35), ButtonWith, ButtonWith);
    
    [button addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button setBackgroundImage:[UIImage imageNamed:imageNamed] forState:UIControlStateNormal];
//    [button setImage:[UIImage imageNamed:imageNamed] forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(80, 0, 0, 0)];
    
    return button;
}


- (void)addSubviewToAlertview:(id)alert
{
    NSInteger buttonsNum = self.shareOrderArray.count;
    while (buttonsNum != 0) {
        for (int i = 0; i< _shareOrderArray.count; i++) {
            self.buttonTag = i + 111001;
            switch ([_shareOrderArray[i] integerValue]) {
                case 1:
                    [alert addSubview:self.QQButton];
                    buttonsNum --;
                    break;
                case 2:
                    [alert addSubview:self.WXPButton];
                    buttonsNum --;
                    break;
                case 3:
                    [alert addSubview:self.WXButton];
                    buttonsNum --;
                    break;
                case 4:
                    [alert addSubview:self.WBButton];
                    buttonsNum --;
                    break;
                default:
                    break;
            }
        }
    }
}

#pragma mark - ButtonAction
- (void)shareButtonAction:(UIButton *)button
{
    NSInteger tag = button.tag - 111000;
    switch (tag) {
        case 1:
            [_delegate choiceShareTpye:shareTpyeOfQQ];
            break;
        case 2:
            [_delegate choiceShareTpye:shareTpyeOfWXF];
            break;
        case 3:
            [_delegate choiceShareTpye:shareTpyeOfWX];
            break;
        case 4:
            [_delegate choiceShareTpye:shareTpyeOfWB];
            break;
        default:
            break;
    }
    [self.controller dismissViewControllerAnimated:YES completion:nil];
}

@end
