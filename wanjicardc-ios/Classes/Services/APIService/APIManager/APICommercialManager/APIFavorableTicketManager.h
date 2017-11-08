//
//  APIFavorableTicketManager.h
//  WanJiCard
//
//  Created by Lynn on 15/9/7.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "APIBaseManager.h"

#import "WJEnumType.h"

@interface APIFavorableTicketManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, assign) FavorableTicketType   ticketType;
@property (nonatomic, strong) NSString *available;


@end
