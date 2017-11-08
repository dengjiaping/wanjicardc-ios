//
//  WJBankCardModel.h
//  WanJiCard
//
//  Created by reborn on 16/11/23.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJBankCardModel : NSObject
@property (nonatomic, strong) NSString      *bankLogol;
@property (nonatomic, strong) NSString      *bankName;
@property (nonatomic, strong) NSString      *bankCardType;
@property (nonatomic, strong) NSString      *bankCardNumber;
@property (nonatomic, strong) NSString      *bankId;
@property (nonatomic, assign) BOOL          isReceiveCard;

- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
