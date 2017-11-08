//
//  WJNewsCenterModel.h
//  WanJiCard
//
//  Created by XT Xiong on 16/7/5.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJNewsCenterModel : NSObject

@property(nonatomic,strong) NSString     * isRead;
@property(nonatomic,strong) NSString     * reqParam;
@property(nonatomic,strong) NSString     * type;
@property(nonatomic,strong) NSString     * money;


- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
