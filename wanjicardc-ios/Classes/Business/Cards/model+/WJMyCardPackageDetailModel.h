//
//  WJMyCardPackageDetailModel.h
//  WanJiCard
//
//  Created by XT Xiong on 16/7/13.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJMyCardPackageDetailModel : NSObject

@property (nonatomic, strong) NSString * ad;              //卡介绍
@property (nonatomic, assign) CGFloat    balance;         //商家卡余额
@property (nonatomic, assign) CardBgType cType;             //卡图片类型
@property (nonatomic, assign) NSString * cardLogo;
@property (nonatomic, strong) NSString * cardName;
@property (nonatomic, strong) NSString * merchantId;
@property (nonatomic, strong) NSString * totalRecharge;
@property (nonatomic, strong) NSArray  * privilegeArray;  //特权集合  

- (id)initWithDic:(NSDictionary *)dic;

@end
