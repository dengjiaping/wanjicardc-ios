//
//  WJIndivdualCollectionViewCell.h
//  HuPlus
//
//  Created by reborn on 16/12/20.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJIndivdualCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong)UILabel *countL;
-(void)configDataWithIcon:(NSString *)icon Title:(NSString *)title countString:(NSString *)count;

@end
