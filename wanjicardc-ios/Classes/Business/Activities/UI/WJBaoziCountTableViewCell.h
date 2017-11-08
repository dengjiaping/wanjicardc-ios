//
//  WJBaoziCountTableViewCell.h
//  WanJiCard
//
//  Created by silinman on 16/8/17.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJBaoziCountTableViewCell : UITableViewCell

@property (nonatomic, strong) WJActionBlock      myBuns;
@property (nonatomic, strong) WJActionBlock      payBuns;
@property (nonatomic, strong) WJActionBlock      userLogin;


- (void)configData:(NSString *)baoziCount isLogin:(BOOL)login;

@end
