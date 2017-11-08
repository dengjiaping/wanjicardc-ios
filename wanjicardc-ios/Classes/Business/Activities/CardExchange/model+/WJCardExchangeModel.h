//
//  WJCardExchangeModel.h
//  WanJiCard
//
//  Created by XT Xiong on 2016/11/30.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJCardExchangeModel : NSObject

@property(nonatomic, strong) NSString *cardLogolUrl;
@property(nonatomic, strong) NSString *cardName;
@property(nonatomic, strong) NSString *cardColorValue;
@property(nonatomic, strong) NSString *thirdCardSortId; //卡类型
@property(nonatomic, strong) NSString *cardId;


- (id)initWithDic:(NSDictionary *)dic;

@end
