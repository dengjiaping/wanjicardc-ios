//
//  TabSwitchView.h
//  LESports
//
//  Created by Harry Hu on 15/6/26.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TabSwitchTag) {
    TabSwitchTagLeft = 200,
    TabSwitchTagRight = 201,
    TabSwitchTagIndication = 202
};

#define kTabSwitchHeight  44

@protocol TabSwitchViewDelegage <NSObject>

- (void)tabSwitchAction:(NSNumber *)chooseBtnIndex;

@end



@interface TabSwitchView : UIView

@property (nonatomic, assign) id<TabSwitchViewDelegage> delegate;


@property (nonatomic, strong) UIColor *selectedColor;       //default is red;

- (id)initWithTitles:(NSArray *)titles andViewControllers:(NSArray *)vcs;

- (void)selectedIndex:(NSInteger)index;

@end
