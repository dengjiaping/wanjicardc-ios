//
//  WJCardDetailPrivilegeCell.h
//  WanJiCard
//
//  Created by Harry Hu on 15/9/7.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJCardDetailPrivilegeCell : UITableViewCell


- (void)configWithPrivileges:(NSArray *)privilegeArray isCard:(BOOL)isCard;

- (void)notHaveValue;


@end
