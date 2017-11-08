//
//  APICardExchangeCardFaceValueManager.h
//  WanJiCard
//
//  Created by reborn on 16/12/1.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APICardExchangeCardFaceValueManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property(nonatomic, strong) NSString * cardId;

@end
