//
//  WJBunsTransRecordModel.h
//  WanJiCard
//
//  Created by silinman on 16/8/24.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJBunsTransRecordModel : NSObject

@property (nonatomic, strong) NSString     * days;
@property (nonatomic, strong) NSString     * bun;
@property (nonatomic, strong) NSString     * typeStr;
@property (nonatomic, strong) NSString     * git;
@property (nonatomic, strong) NSString     * type;
@property (nonatomic, strong) NSString     * order_no;
@property (nonatomic, strong) NSString     * dayStr;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
