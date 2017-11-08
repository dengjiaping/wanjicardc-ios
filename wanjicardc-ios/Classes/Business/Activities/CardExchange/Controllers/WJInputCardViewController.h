//
//  WJInputCardViewController.h
//  WanJiCard
//
//  Created by 林有亮 on 16/12/6.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJViewController.h"

@class WJFaceValueModel;
@class WJCardExchangeModel;
@interface WJInputCardViewController : WJViewController

@property (nonatomic, strong) WJFaceValueModel * faceCard;
@property (nonatomic, strong) WJCardExchangeModel *cardModel;

@end
