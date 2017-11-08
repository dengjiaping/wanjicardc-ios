//
//  APIBunsTransRecordManager.h
//  WanJiCard
//
//  Created by silinman on 16/8/24.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APIBunsTransRecordManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>{
    
}

@property (nonatomic, assign) NSInteger         pageCount;                  //  每页的个数   默认20
@property (nonatomic, assign) NSInteger         firstPageNo;                //  第一页页数   默认1
@property (nonatomic, assign) NSInteger         currentPage;

@end
