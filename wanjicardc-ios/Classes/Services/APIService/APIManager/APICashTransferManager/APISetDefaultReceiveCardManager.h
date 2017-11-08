//
//  APISetDefaultReceiveCardManager.h
//  WanJiCard
//
//  Created by reborn on 16/11/25.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APISetDefaultReceiveCardManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>
@property(nonatomic, strong) NSString *bankCardId;


@end
