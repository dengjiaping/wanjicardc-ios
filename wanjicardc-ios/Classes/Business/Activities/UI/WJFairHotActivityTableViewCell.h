//
//  WJFairHotActivityTableViewCell.h
//  WanJiCard
//
//  Created by silinman on 16/8/25.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SelectActivityBlock)(NSString *url,NSString *name);

@interface WJFairHotActivityTableViewCell : UITableViewCell{
    
}

@property (nonatomic, strong) SelectActivityBlock selectActivityBlock;

- (void)configData:(NSMutableArray *)dataArray;

@end
