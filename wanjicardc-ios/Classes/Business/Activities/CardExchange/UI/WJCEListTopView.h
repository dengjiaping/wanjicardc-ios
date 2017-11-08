//
//  WJCEListTopView.h
//  WanJiCard
//
//  Created by XT Xiong on 2016/12/1.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJCEListTopView : UIView

@property(nonatomic ,strong)UIImageView    * iconIV;
@property(nonatomic ,strong)UILabel        * creditSumLabel;
@property(nonatomic ,strong)UILabel        * canUseSumLabel;

- (void)configDataWithDictionary:(NSDictionary *)dictionary;

@end
