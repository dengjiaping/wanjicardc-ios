//
//  WJModelTicket.m
//  WanJiCard
//
//  Created by wangzhangjie on 15/9/17.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJModelTicket.h"

@implementation WJModelTicket

-(id)initWithDic:(NSDictionary*)dic{
    if (self = [super init]) {
        self.ticketId = ToString(dic[@"id"]);
        self.name = dic[@"name"]?:@"";
       // self.merId = dic[@"merId"]?:@"";
        self.amount = [ToNSNumber(dic[@"amount"]) floatValue];
       // self.cover = dic[@"cover"]?:@"";
    }
    return self;
}


-(id)initWithCursor:(FMResultSet *)cursor{
    if (self = [super init]) {
        self.ticketId =   [cursor stringForColumn:@"Id"];
        self.name =     [cursor stringForColumn:@"Name"];
       // self.merId =    [cursor stringForColumn:@"MerId"];
        self.amount =   [cursor doubleForColumn:@"Anount"];
       // self.cover =    [cursor stringForColumn:@"Cover"];
        
    }
    return self;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"(ticketId = %@)",self.ticketId];
}


@end
