//
//  APIBillsManager.h
//  WanJiCard
//
//  Created by reborn on 16/11/23.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIBillsManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, assign) BillStatus        billStatus;
@property (nonatomic, assign) NSInteger         pageCount;                  //  每页的个数   默认10
@property (nonatomic, assign) NSInteger         firstPageNo;                //  第一页页数   默认1
@property (nonatomic, assign, readonly) NSInteger callBackCount;            //  请求返回的个数
@end
