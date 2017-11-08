//
//  WJECardDetailModel.h
//  WanJiCard
//
//  Created by 林有亮 on 16/8/31.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJECardModel.h"

@interface WJECardDetailModel : WJECardModel

@property (nonatomic, strong) NSString      * desString;
@property (nonatomic, strong) NSString      * titleString;
@property (nonatomic, strong) NSString      * url;
@property (nonatomic, strong) NSString      * useRule;


- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
