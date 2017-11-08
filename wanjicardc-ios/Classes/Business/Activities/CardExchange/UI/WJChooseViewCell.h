//
//  WJChooseViewCell.h
//  WanJiCard
//
//  Created by 林有亮 on 16/12/5.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WJFaceValueModel;
@interface WJChooseViewCell : UIView

@property (nonatomic , assign) BOOL selected;

- (instancetype) initWithPoint:(CGPoint)point value:(NSString *)value des:(NSString *)des;



//- (void)refreshWithModel:(WJFaceValueModel *)model;

@end
