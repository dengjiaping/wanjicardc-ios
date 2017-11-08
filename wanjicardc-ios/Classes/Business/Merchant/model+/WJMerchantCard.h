//
//  WJMerchantCard.h
//  WanJiCard
//
//  Created by 孙明月 on 16/3/10.
//  Copyright © 2016年 zOne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJMerchantCard : NSObject
@property (nonatomic, strong) NSString      *coverURL;
@property (nonatomic, assign) NSInteger     faceValue;              //面额
@property (nonatomic, strong) NSString      *cardId;
@property (nonatomic, strong) NSString      *name;
@property (nonatomic, assign) NSInteger     saledNumber;
@property (nonatomic, assign) CGFloat       salePrice;              //售价
@property (nonatomic, assign) NSInteger     colorType;
@property (nonatomic, assign) OrderStatus   status;
@property (nonatomic, strong) NSString      *merName;
@property (nonatomic, strong) NSString      *merId;                 //所属商家
@property (nonatomic, strong) NSString      *merchantCardStatus;
@property (nonatomic, strong) NSString      *merchantId;
@property (nonatomic, assign) BOOL          isLimitForSale;
@property (nonatomic, assign) NSInteger     salePercent;
@property (nonatomic, assign) CGFloat       price;                  //活动价



- (instancetype)initWithDic:(NSDictionary *)dic;
@end
