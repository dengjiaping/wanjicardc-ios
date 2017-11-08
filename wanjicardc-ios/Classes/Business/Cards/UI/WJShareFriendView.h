//
//  WJShareFriendView.h
//  WanJiCard
//
//  Created by Lynn on 15/9/22.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WJShareFriendView;
@protocol ShareFriendDelegate <NSObject>

- (void)ShareToFriend;
- (void)exitShareView;
@end

@interface WJShareFriendView : UIView

@property (nonatomic, weak) id<ShareFriendDelegate>  delegate;

@end
