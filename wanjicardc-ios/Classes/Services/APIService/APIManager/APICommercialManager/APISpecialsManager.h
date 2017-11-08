//
//  APISpecialsManager.h
//  WanJiCard
//
//  Created by Lynn on 15/9/24.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "APIBaseManager.h"
#import "WJEnumType.h"

@interface APISpecialsManager : APIBaseManager<APIManagerParamSourceDelegate ,APIManagerVaildator, APIManager>

@property (nonatomic, assign)FavorableTicketType        type;
@property (nonatomic, assign)BOOL                       available;

@end
