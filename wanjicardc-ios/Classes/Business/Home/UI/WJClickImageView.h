//
//  WJClickImageView.h
//  WanJiCard
//
//  Created by silinman on 16/5/20.
//  Copyright © 2016年 zOne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJClickImageView : UIImageView
{
    SEL myEvent;
    id obj;
}
//自定义点击事件
- (void)addTarget:(id)Target action:(SEL)action;

@end
