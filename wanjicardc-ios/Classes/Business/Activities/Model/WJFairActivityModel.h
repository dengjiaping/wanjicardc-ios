//
//  WJFairActivityModel.h
//  WanJiCard
//
//  Created by silinman on 16/8/23.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJFairActivityModel : NSObject

@property (nonatomic, strong) NSString     * linkUrl;
@property (nonatomic, strong) NSString     * name;
@property (nonatomic, strong) NSString     * state;
@property (nonatomic, strong) NSString     * pcUrl;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
