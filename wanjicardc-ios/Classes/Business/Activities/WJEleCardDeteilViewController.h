//
//  WJEleCardDeteilViewController.h
//  WanJiCard
//
//  Created by 林有亮 on 16/8/18.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJViewController.h"
#import "WJBaoziPayCompleteController.h"

@class WJECardModel;
@interface WJEleCardDeteilViewController : WJViewController

@property (nonatomic, strong)WJECardModel * eCardModel;
@property (nonatomic, assign)ElectronicCardComeFrom electronicCardComeFrom;
@property (nonatomic, assign) BOOL          isEntityCard;

@end
