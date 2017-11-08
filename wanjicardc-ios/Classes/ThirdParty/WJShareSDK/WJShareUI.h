//
//  WJShareUI.h
//  WanJiCard
//
//  Created by XT Xiong on 16/8/23.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef enum{
    shareTpyeOfQQ,
    shareTpyeOfWXF,
    shareTpyeOfWX,
    shareTpyeOfWB
}ShareType;

@protocol ShareChoiceDelegate <NSObject>

- (void)choiceShareTpye:(ShareType)shareType;

@end

@interface WJShareUI : UIView 

- (void)presentViewController:(UIViewController *)controller ShareOrderArray:(NSArray *)shareOrderArray;

@property (nonatomic,assign)id<ShareChoiceDelegate>delegate;

@end
