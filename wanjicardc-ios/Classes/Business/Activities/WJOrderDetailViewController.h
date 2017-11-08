//
//  WJOrderDetailViewController.h
//  WanJiCard
//
//  Created by 林有亮 on 16/11/14.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJViewController.h"
#import "WJBaoziPayCompleteController.h"

@class WJECardDetailModel;
@interface WJOrderDetailViewController : WJViewController

@property (nonatomic, strong)WJECardDetailModel   * eCardModel;
@property (nonatomic, assign)CGFloat      orderNum;
@property (nonatomic, assign)ElectronicCardComeFrom electronicCardComeFrom;

@end
