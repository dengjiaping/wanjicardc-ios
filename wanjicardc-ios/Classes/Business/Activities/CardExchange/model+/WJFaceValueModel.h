//
//  WJFaceValueModel.h
//  WanJiCard
//
//  Created by 林有亮 on 16/12/6.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJFaceValueModel : NSObject

@property (nonatomic, strong) NSString * sellValue;
@property (nonatomic, strong) NSString * cardID;
@property (nonatomic, strong) NSString * faceValue;

- (instancetype)initWithDic:(NSDictionary *)dic;


@end
