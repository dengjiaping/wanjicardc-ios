//
//  WJExtraCardModel.h
//  WanJiCard
//
//  Created by maying on 2017/8/12.
//  Copyright © 2017年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJExtraCardModel : NSObject

@property (nonatomic, strong) NSString *cardNumber; // 第三方卡号
@property (nonatomic, strong) NSString *cardSecret;   //第三方卡密

- (id)initWithDic:(NSDictionary *)dic;

@end
