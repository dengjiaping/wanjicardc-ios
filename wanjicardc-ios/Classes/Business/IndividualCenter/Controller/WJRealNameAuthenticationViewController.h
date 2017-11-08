//
//  WJRealNameAuthenticationViewController.h
//  WanJiCard
//
//  Created by reborn on 16/6/15.
//  Copyright © 2016年 zOne. All rights reserved.
//

#import "WJViewController.h"

typedef NS_ENUM(NSInteger, RealNameComeFrom) {
    
    ComeFromIndividualCenter = 0,     //个人中心
    ComeFromIndividualInformation = 1,//个人信息
    ComeFromOwnedCardList = 2,        //卡包充值列表
    ComeFromProductDetail = 3,        //商品卡详情
    ComeFromCardPackageDetail = 4,    //用户卡详情
    ComeFromEleCardDetail = 5,        //电子卡详情
    ComeFromCardPackageView = 6,       //付款页
    ComeFromECardRechargeConfirm = 7,       //电子卡充值确认页
    ComeFromActivitiesShare                 //活动分享
};

@interface WJRealNameAuthenticationViewController : WJViewController

@property(nonatomic, copy)dispatch_block_t RealNameAuthenticationSuc;
@property(nonatomic, assign)BOOL isjumpOrderConfirmController;
@property(nonatomic, assign)RealNameComeFrom comefrom;


@end
