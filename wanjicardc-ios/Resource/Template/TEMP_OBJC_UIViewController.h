//
//  TEMP_OBJC_UIViewController.h
//  MySports
//
//  Created by zOne on 23/5/15.
//  Copyright (c) 2015 zOne. All rights reserved.
//

#import <UIKit/UIKit.h>

// TODO:枚举变量一般定义在 .h 文件中，方便外部文件引用。
typedef NS_ENUM (NSUInteger, MessageSendStrategy)
{
    MessageSendStrategyText  = 0,
    MessageSendStrategyImage = 1,
    MessageSendStrategyVoice = 2,
    MessageSendStrategyVideo = 3
};

@interface TEMP_OBJC_UIViewController : UIViewController
// TODO:所有对外部要暴露的变量，都设计成属性来调用。
@property (nonatomic, strong) UILabel  *label;
@property (nonatomic, strong) UIButton *button;

// TODO:所有要外部对象调用的 API 接口，都放在 .h 文件中声明。
//+ (void)someClassMethod;
//- (void)someAPIMethod;
@end
