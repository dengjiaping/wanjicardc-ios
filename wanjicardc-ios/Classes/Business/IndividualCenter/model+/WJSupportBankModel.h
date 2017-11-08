//
//  WJSupportBankModel.h
//  WanJiCard
//
//  Created by reborn on 16/9/1.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJSupportBankModel : NSObject

@property (nonatomic, strong) NSString     *bankId;
@property (nonatomic, strong) NSString     *logoImage;
@property (nonatomic, strong) NSString     *name;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
