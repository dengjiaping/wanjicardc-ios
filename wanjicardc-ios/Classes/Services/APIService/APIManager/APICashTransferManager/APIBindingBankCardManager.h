//
//  APIBindingBankCardManager.h
//  WanJiCard
//
//  Created by reborn on 16/11/23.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIBindingBankCardManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *bankCardNum;
@property (nonatomic, strong) NSString *phoneNum;
@property (nonatomic, strong) NSString *verfiCodeNum;
@property (nonatomic, strong) NSString *identityCard;



@end
