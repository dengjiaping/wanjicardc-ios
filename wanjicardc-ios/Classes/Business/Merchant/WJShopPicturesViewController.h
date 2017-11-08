//
//  WJShopPicturesViewController.h
//  WanJiCard
//
//  Created by silinman on 16/6/23.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJViewController.h"

@class WJShopPicturesViewController;
@class WJMerchantDetailModel;

@interface WJShopPicturesViewController : WJViewController

@property (nonatomic, assign) int currentImageIndex;
@property (nonatomic, assign) NSInteger imageCount;//图片总数
@property (nonatomic, assign) WJMerchantDetailModel *detailModel;

@end
