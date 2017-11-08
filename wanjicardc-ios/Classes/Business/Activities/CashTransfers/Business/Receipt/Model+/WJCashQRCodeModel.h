//
//  WJCashQRCodeModel.h
//  WanJiCard
//
//  Created by XT Xiong on 2016/11/28.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJCashQRCodeModel : NSObject

@property(nonatomic,strong)NSString     *codeImageUrl;
@property(nonatomic,strong)NSString     *payRemender;
@property(nonatomic,strong)NSString     *warmPrompt;

- (id)initWithDic:(NSDictionary *)dic;

@end