//
//  WJBaoziPayCompleteController.h
//  WanJiCard
//
//  Created by 孙明月 on 16/8/16.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJViewController.h"
#import "WJPayCompleteModel.h"
typedef NS_ENUM(NSInteger, ElectronicCardComeFrom) {
    
    ComeFromHome = 0,     //首页
    ComeFromFair = 1,     //包子商城
    ComeFromCardShop = 2  //卡商城
};
@interface WJBaoziPayCompleteController : WJViewController
@property (nonatomic, assign)ElectronicCardComeFrom electronicCardComeFrom;
- (instancetype)initWithinfo:(WJPayCompleteModel *)completeInfo;
@end
