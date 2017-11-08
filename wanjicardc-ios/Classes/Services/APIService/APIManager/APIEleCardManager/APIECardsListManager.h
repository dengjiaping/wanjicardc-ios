//
//  APIECardsListManager.h
//  WanJiCard
//
//  Created by silinman on 16/8/18.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIECardsListManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>
{
    
}

@property (nonatomic, assign) NSInteger         pageCount;                  //  每页的个数   默认20
@property (nonatomic, assign) NSInteger         firstPageNo;                //  第一页页数   默认1
@property (nonatomic, strong) NSString          *merchantBranchId;           //电子卡类型品牌ID

@end
