//
//  WJStoreModel.h
//  WanJiCard
//
//  Created by Harry Hu on 15/8/31.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJStoreModel : NSObject

@property (nonatomic, strong) NSString *areaId;             //区域id
@property (nonatomic, strong) NSString *distanceStr;        //距离关键字 '一公里内'
@property (nonatomic, strong) NSString *isLimitForSale;     //是否有限购活动
@property (nonatomic, strong) NSString *storeAddress;       //商户地址
@property (nonatomic, strong) NSString *storeCategory;      //商户类型
@property (nonatomic, strong) NSString *storeId;            //商户id
@property (nonatomic, assign) CGFloat latitude;             //经度
@property (nonatomic, assign) CGFloat longitude;            //纬度
@property (nonatomic, strong) NSString *storeName;          //商户名称
@property (nonatomic, strong) NSString *telephone;          //电话
@property (nonatomic, strong) NSString *storeCover;         //商户图片
@property (nonatomic, assign) NSInteger storeTotalSale;     //售卖物品


@property (nonatomic, strong) NSString *businessHours;      //营业时间
@property (nonatomic, assign) CGFloat distance;             //距离

- (id)initWithDic:(NSDictionary *)dic;

@end
