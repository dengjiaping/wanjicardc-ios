//
//  WJUnReadMessagesModel.h
//  WanJiCard
//
//  Created by XT Xiong on 16/7/5.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJUnReadMessagesModel : NSObject

@property(nonatomic,strong) NSString     * ifRead;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
