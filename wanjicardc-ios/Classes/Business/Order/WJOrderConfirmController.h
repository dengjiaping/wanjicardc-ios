//
//  WJOrderConfirmController.h
//  WanJiCard
//
//  Created by Angie on 15/9/21.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJViewController.h"
#import "WJCardModel.h"

typedef enum{
    BuyTypeCharge,
    BuyTypeOrder
}BuyType;


@class WJOrderModel, WJModelCard;

@interface WJOrderConfirmController : WJViewController

@property (nonatomic, strong) WJCardModel *currentCard;           //购卡
@property (nonatomic, strong) NSString    *isLimitForSale;        // 是否限购

- (id)initWithCardId:(NSString *)pcid
            cardName:(NSString *)cardName
               merID:(NSString *)merid
             merName:(NSString *)merName
             buyType:(BuyType)type;


@end
