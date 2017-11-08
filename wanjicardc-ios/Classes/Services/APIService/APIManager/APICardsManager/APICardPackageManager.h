//
//  APICardPackageManager.h
//  WanJiCard
//
//  Created by Lynn on 15/9/1.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "APIBaseManager.h"

@interface APICardPackageManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, assign) NSInteger pageCount;                  //  每页的个数   默认20
@property (nonatomic, assign) NSInteger firstPageNo;                //  第一页页数   默认1
@property (nonatomic, assign, readonly) NSInteger callBackCount;    //  请求返回的个数

@end