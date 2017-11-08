//
//  WJDBCardManager.h
//  WanJiCard
//
//  Created by Harry Hu on 15/8/31.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDBManager.h"
#import "WJModelCard.h"

@interface WJDBCardManager : BaseDBManager


- (instancetype)initWithOwnedUserId:(NSString *)userId;

- (BOOL)insertCard:(WJModelCard*)card;

- (BOOL)insertCards:(NSArray *)cards;

- (BOOL)updateCard:(WJModelCard*)card;

- (BOOL)remove:(WJModelCard *)card;

- (BOOL)removeCards;

- (WJModelCard *)getCardById:(NSString *)cardId;


- (NSArray *)getCards;

@end
