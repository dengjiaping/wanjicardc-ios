//
//  WJHttpsManager.h
//  CardsBusiness
//
//  Created by 林有亮 on 16/3/16.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface WJHttpsManager : NSObject

+ (AFSecurityPolicy*)customSecurityPolicy;

@end
