//
//  WJFilterTableViewCell.h
//  WanJiCard
//
//  Created by 孙明月 on 16/5/31.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJFilterTableViewCell : UITableViewCell
@property (nonatomic, strong)UILabel    * titleLabel;
@property (nonatomic, strong)UIView    * markView;
@property (nonatomic, strong)UIView    * rightSideLine;
@property (nonatomic, strong)UIView    *bottomLine;

- (void)configData:(id)obj;
@end
