//
//  WJDBCardManager.m
//  WanJiCard
//
//  Created by Harry Hu on 15/8/31.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJDBCardManager.h"
#import "WJSqliteUserManager.h"

@interface WJDBCardManager ()

@property (nonatomic, strong) NSString *ownedUserId;

@end
@implementation WJDBCardManager


- (instancetype)initWithOwnedUserId:(NSString *)userId{
    if (self = [super init]) {
        self.sqliteManager = [WJSqliteUserManager sharedManager];
        self.ownedUserId = userId?:@"";
    }
    return self;
}


- (BOOL)insertCard:(WJModelCard*)card{
    if ([card.freeCardID isEqualToString:@"0"]) {
        NSLog(@"parameter is invalid");
        return NO;
    }
    
    WJModelCard *oldModelCard=[self getCardById:card.freeCardID];
    if(oldModelCard){
        return [self updateCard:card];
    }
    
    return [self.sqliteManager insert:TABLE_CARD
                              withColumnsInArray:@[COL_CARD_ID,
                                                   COL_CARD_NAME,
                                                   COL_CARD_FaceValue,
                                                   COL_CARD_COVER,
                                                   COL_CARD_SaleNumber,
                                                   COL_CARD_SalePrice,
                                                   COL_CARD_CardStatus,
                                                   COL_CARD_ColorType,
                                                   COL_CARD_MerName,
                                                   COL_CARD_OwnUserId]
                               withValuesInArray:@[card.freeCardID,
                                                   card.name?:@"",
                                                   @(card.faceValue),
                                                   card.coverURL?:@"",
                                                   @(card.saledNumber),
                                                   @(card.balance),
                                                   @(card.status),
                                                   @(card.colorType),
                                                   card.merName?:@"",
                                                   self.ownedUserId]];
}

- (BOOL)insertCards:(NSArray *)cards{
    NSMutableArray *values = [NSMutableArray array];
    for (WJModelCard *card in cards) {
        NSArray *arr =@[card.freeCardID,
                        card.name?:@"",
                        @(card.faceValue),
                        card.coverURL?:@"",
                        @(card.saledNumber),
                        @(card.balance),
                        @(card.status),
                        @(card.colorType),
                        card.merName?:@"",
                        self.ownedUserId];
        [values addObject:arr];
    }
    
    return [self.sqliteManager insertList:TABLE_CARD
                       withColumnsInArray:@[COL_CARD_ID,
                                            COL_CARD_NAME,
                                            COL_CARD_FaceValue,
                                            COL_CARD_COVER,
                                            COL_CARD_SaleNumber,
                                            COL_CARD_SalePrice,
                                            COL_CARD_CardStatus,
                                            COL_CARD_ColorType,
                                            COL_CARD_MerName,
                                            COL_CARD_OwnUserId]
                        withValuesInArray:values];
}


- (BOOL)updateCard:(WJModelCard*)card{
    
    NSDictionary *cardDic = @{COL_CARD_NAME:        card.name?:@"",
                              COL_CARD_FaceValue:   @(card.faceValue),
                              COL_CARD_COVER:       card.coverURL?:@"",
                              COL_CARD_SaleNumber:  @(card.saledNumber),
                              COL_CARD_SalePrice:   @(card.balance),
                              COL_CARD_CardStatus:  @(card.status),
                              COL_CARD_ColorType:   @(card.colorType),
                              COL_CARD_MerName:     card.merName?:@"",
                              COL_CARD_OwnUserId:   self.ownedUserId};

    return [self.sqliteManager update:(NSString *)TABLE_CARD
                    withSetDictionary:(NSDictionary *)cardDic
                      withWhereClause:@"CardId = ? AND OwnUserId = ?"
                   withWhereArguments:@[card.freeCardID, self.ownedUserId]];
}

- (BOOL)remove:(WJModelCard *)card{
    if (card.freeCardID.length == 0)
    {
        NSLog(@"card manager parameter is invalid");
        return NO;
    }
    
    return [self.sqliteManager remove:TABLE_CARD
                                withWhereClauses:@"CardId = ? AND OwnUserId = ?"
                              withWhereArguments:@[card.freeCardID, self.ownedUserId]];
}

- (BOOL)removeCards{
    return [self removeCardsByUserID:self.ownedUserId];
}

- (BOOL)removeCardsByUserID:(NSString *)userId{
    return [self.sqliteManager remove:TABLE_CARD
                     withWhereClauses:@"OwnUserId = ?"
                   withWhereArguments:@[userId]];
}

- (FMResultSet*)querySql:(NSString*)sql{
    return [self.sqliteManager querySql:sql];
}


#pragma mark - 具体API

- (WJModelCard *)getCardById:(NSString *)cardId{
    
    FMResultSet *cursor = [self queryInTable:TABLE_CARD
                            withWhereClauses:@"CardId = ? AND OwnUserId = ?"
                          withWhereArguments:@[cardId, self.ownedUserId]
                                 withOrderBy:COL_CARD_ID
                               withOrderType:ORDER_BY_ASC];
    
    WJModelCard *card = nil;
    while ([cursor next]) {
        card = [[WJModelCard alloc] initWithCursor:cursor];
        break;
    }
    [cursor close];
    
    return card;
    
}

- (NSArray *)getCards{
    NSMutableArray *arr = [NSMutableArray array];
    FMResultSet *cursor = [self queryInTable:TABLE_CARD
                            withWhereClauses:@"OwnUserId = ?"
                          withWhereArguments:@[self.ownedUserId]
                                 withOrderBy:COL_CARD_ID
                               withOrderType:ORDER_BY_ASC];
    
    WJModelCard *card = nil;
    while ([cursor next]) {
        card = [[WJModelCard alloc] initWithCursor:cursor];
        [arr addObject:card];
    }
    [cursor close];
    
    return [NSArray arrayWithArray:arr];
}

@end
