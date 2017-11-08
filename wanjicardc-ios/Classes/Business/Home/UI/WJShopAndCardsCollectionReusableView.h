//
//  WJShopAndCardsCollectionReusableView.h
//  WanJiCard
//
//  Created by silinman on 16/5/25.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJShopAndCardsCollectionReusableView : UICollectionReusableView
{
    SEL myEvent;
    id obj;
}
//自定义点击事件
- (void)addTarget:(id)Target action:(SEL)action;

@end
