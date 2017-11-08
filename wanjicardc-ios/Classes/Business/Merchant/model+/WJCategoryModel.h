//
//  WJCategory.h
//  WanJiCard
//
//  Created by Lynn on 15/9/18.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJCategoryModel : NSObject

@property (nonatomic, strong)NSString   *categoryID;
@property (nonatomic, strong)NSString   *name;
@property (nonatomic, strong)NSString   *pid;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
