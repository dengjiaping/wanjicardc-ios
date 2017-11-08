//
//  APINewsListManager.h
//  WanJiCard
//
//  Created by XT Xiong on 16/6/14.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APINewsListManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, strong) NSString          *type;                   //默认0
@property (nonatomic, assign) NSInteger         pageCount;                  //  每页的个数   默认20
@property (nonatomic, assign) NSInteger         firstPageNo;                //  第一页页数   默认1

@end
