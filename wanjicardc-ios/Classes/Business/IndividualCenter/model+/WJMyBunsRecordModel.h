//
//  WJMyBunsRecordModel.h
//  WanJiCard
//
//  Created by silinman on 16/8/24.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJMyBunsRecordModel : NSObject

@property (nonatomic, strong) NSString     * total;
@property (nonatomic, strong) NSString     * walletCount;
@property (nonatomic, assign) NSInteger      totalPage;
@property (nonatomic, assign) BOOL           recharge;
@property (nonatomic, strong) NSArray      * recordsArray;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
