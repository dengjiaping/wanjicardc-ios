//
//  BaseDBModel.h
//  WanJiCard
//
//  Created by Harry Hu on 15/9/1.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMResultSet.h"

@interface BaseDBModel : NSObject

-(id)initWithDic:(NSDictionary*)dic;

- (id)initWithCursor:(FMResultSet *)cursor;


@end
