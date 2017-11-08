//
//  WJShopAndCardsTableViewCell.h
//  WanJiCard
//
//  Created by silinman on 16/5/25.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WJHomePageBottomModel;
@interface WJShopAndCardsTableViewCell : UITableViewCell

- (void)sendPicUrls:(WJHomePageBottomModel *)bottomModel selectImageHandle:(void(^)(NSInteger index))process;

@end
