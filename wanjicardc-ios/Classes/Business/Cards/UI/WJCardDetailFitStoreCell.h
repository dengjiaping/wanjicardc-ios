//
//  WJFitStoreCell.h
//  WanJiCard
//
//  Created by Harry Hu on 15/9/6.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WJStoreModel;
@interface WJCardDetailFitStoreCell : UITableViewCell

@property(nonatomic, strong) WJStoreModel *store;
@property(nonatomic, assign) BOOL isOpenLocation;


@end
