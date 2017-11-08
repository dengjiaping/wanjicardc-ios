//
//  WJReceiptView.h
//  WanJiCard
//
//  Created by XT Xiong on 2016/11/28.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJReceiptView : UIView

@property(nonatomic,strong)UIView               * backgroundView;
@property(nonatomic,strong)UIButton             * sureButton;
@property(nonatomic,strong)UILabel              * tipRecLabel;
@property(nonatomic,strong)UILabel              * tipLabel;
@property(nonatomic,strong)UITextField          * textField;

- (void)configDataWithDictionary:(NSDictionary *)dictionary;

@end
