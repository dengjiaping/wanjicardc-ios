//
//  WJChooseFaceValueView.h
//  WanJiCard
//
//  Created by 林有亮 on 16/11/30.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WJCardExchangeModel;
@class WJFaceValueModel;

@protocol ChooseFaceValueDelegate <NSObject>

- (void)selectModel:(WJFaceValueModel *)model;
@end

@interface WJChooseFaceValueView : UIView
{
    NSInteger selectNum;
}
@property (nonatomic, weak)id<ChooseFaceValueDelegate> delegate;

- (void)refreshWithDictionary:(WJCardExchangeModel *)model listFaceValue:(NSArray *)cardArray;

@end
