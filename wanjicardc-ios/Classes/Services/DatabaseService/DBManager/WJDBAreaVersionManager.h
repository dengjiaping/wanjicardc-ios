//
//  WJDBAreaVersionManager.h
//  WanJiCard
//
//  Created by Angie on 15/9/23.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "BaseDBManager.h"

@interface WJDBAreaVersionManager : BaseDBManager

- (BOOL)insertAreaVersion:(NSInteger)versionNumber;

- (BOOL)updateAreaVersion:(NSInteger)versionNumber;

- (NSInteger)getAreaVersionNumber;

@end
