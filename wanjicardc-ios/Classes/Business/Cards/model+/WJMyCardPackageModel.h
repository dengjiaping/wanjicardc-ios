//
//  WJMyCardPackageModel.h
//  WanJiCard
//
//  Created by XT Xiong on 16/7/9.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WJModelCard.h"

@interface WJMyCardPackageModel : NSObject

@property (nonatomic, strong) NSArray     *cardListArray;     //卡集合  WJModelCard
@property (nonatomic, assign) CGFloat      totalAssets;       //我的卡总价格
@property (nonatomic, assign) NSInteger    totalPage;         //总页面
@property (nonatomic, assign) NSInteger    pages;             //当前页面

- (id)initWithDic:(NSDictionary *)dic;

@end
