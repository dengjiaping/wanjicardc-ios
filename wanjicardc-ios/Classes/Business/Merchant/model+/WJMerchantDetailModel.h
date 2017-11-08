//
//  WJMerchantDetail.h
//  WanJiCard
//
//  Created by Angie on 15/9/12.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WJStoreModel.h"
#import "WJMerchantImageModel.h"

@interface WJMerchantDetailModel : NSObject

@property (nonatomic, strong) NSString      *shareDesc;
@property (nonatomic, strong) NSString      *shareTitle;
@property (nonatomic, strong) NSString      *shareUrl;
@property (nonatomic, strong) NSArray       *activity;
@property (nonatomic, strong) NSString      *activityNum;

@property (nonatomic, strong) NSString      *merId;
@property (nonatomic, strong) NSString      *mainMerId;
@property (nonatomic, strong) NSString      *merName;
@property (nonatomic, strong) NSString      *address;
@property (nonatomic, assign) NSInteger      totalSale;
@property (nonatomic, assign) CGFloat        lat;
@property (nonatomic, assign) CGFloat        lng;
@property (nonatomic, strong) NSString      *merCover;
@property (nonatomic, strong) NSString      *businessTime;
@property (nonatomic, strong) NSString      *phone;
@property (nonatomic, assign) NSInteger      productNum;
@property (nonatomic, assign) NSInteger      branchNum;

@property (nonatomic, strong) NSArray       *branchArray;             //WJStoreModel
@property (nonatomic, strong) NSArray       *productArray;            //WJCardsModel
@property (nonatomic, strong) NSArray       *privilegeArray;          
@property (nonatomic, assign) BOOL           isMain;
@property (nonatomic, assign) NSInteger      imageNum;
@property (nonatomic, strong) NSArray       *imageArray;              //WJMerchantImageModel
@property (nonatomic, strong) NSString      *introduction;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
