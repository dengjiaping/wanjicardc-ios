//
//  WJCardActsModel.h
//  WanJiCard
//
//  Created by silinman on 16/7/7.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJCardActsModel : NSObject

@property(nonatomic,strong) NSString     * actName;
@property(nonatomic,strong) NSString     * Id;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
