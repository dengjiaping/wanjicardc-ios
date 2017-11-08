//
//  APICardExchangeListManager.h
//  WanJiCard
//
//  Created by reborn on 16/11/30.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APICardExchangeListManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>
@property (nonatomic, assign) NSInteger         pageCount;                  //  每页的个数   默认10
@property (nonatomic, assign) NSInteger         firstPageNo;                //  第一页页数   默认1
@property (nonatomic, assign, readonly) NSInteger callBackCount;            //  请求返回的个数

@property (nonatomic, strong) NSString         *thirdCardName;
@property (nonatomic, assign) CardExchangeType thirdCardSortId;

@end
