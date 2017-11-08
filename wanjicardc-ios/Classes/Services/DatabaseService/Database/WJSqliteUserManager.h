//
//  WJSqliteUserManager.h
//  WanJiCard
//
//  Created by Angie on 15/9/22.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "SqliteManager.h"

@interface WJSqliteUserManager : SqliteManager

+ (instancetype)sharedManager;

- (BOOL)status;

@end
