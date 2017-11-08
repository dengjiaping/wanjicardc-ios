//
//  WJModelTicket.h
//  WanJiCard
//
//  Created by wangzhangjie on 15/9/17.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "BaseDBModel.h"

@interface WJModelTicket : BaseDBModel

@property (nonatomic, strong) NSString *ticketId;             //id
@property (nonatomic, strong) NSString *name;               //名称

@property (nonatomic, assign) NSInteger amount;             //金额
@property (nonatomic, strong) NSString *cover;              //icon
@end
