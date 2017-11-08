//
//  APISearchManager.h
//  WanJiCard
//
//  Created by Lynn on 15/9/6.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "APIBaseManager.h"

@interface APISearchManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, strong) NSString      *areaId;                   //默认0
@property (nonatomic, strong) NSString      *categoryid;             //默认0
@property (nonatomic, strong) NSString      *merchantAccountId;      //默认0
@property (nonatomic, strong) NSString      *merName;             //默认0
@property (nonatomic, assign) double        longitude;              //默认0
@property (nonatomic, assign) double        latitude;               //默认0
@property (nonatomic, assign) NSInteger     pageCount;              //  每页的个数   默认20
@property (nonatomic, assign) NSInteger     firstPageNo;            //  第一页页数   默认1
@property (nonatomic, assign, readonly) NSInteger callBackCount;    //  请求返回的个数

@property (nonatomic, strong) NSString      *sort;                  //可选

@end

