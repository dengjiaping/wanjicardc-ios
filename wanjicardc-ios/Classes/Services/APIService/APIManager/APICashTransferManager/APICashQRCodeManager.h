//
//  APICashQRCodeManager.h
//  WanJiCard
//
//  Created by XT Xiong on 2016/11/28.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APICashQRCodeManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

//@property(nonatomic,strong)NSString    * payWay;
@property(nonatomic,strong)NSString    * payMoney;
@property(nonatomic,strong)NSString    * payTypeId;

@end
