//
//  WJFairDetailModel.h
//  WanJiCard
//
//  Created by silinman on 16/8/23.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJFairDetailModel : NSObject

@property (nonatomic, strong) NSString        * balance;
@property (nonatomic, strong) NSArray        *cardsArray;
@property (nonatomic, strong) NSArray        *activityArray;
@property (nonatomic, assign) BOOL           cardsHasmore;
@property (nonatomic, assign) BOOL           activityHasmore;
@property (nonatomic, assign) BOOL           recharge;
@property (nonatomic, assign) NSInteger      total;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
