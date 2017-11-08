//
//  WJChoiceCardModel.h
//  WanJiCard
//
//  Created by XT Xiong on 16/7/13.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJChoiceCardModel : NSObject

@property (nonatomic, assign) CGFloat       cardFacePrice;      //卡价格
@property (nonatomic, strong) NSString    * cardId;             //卡id
@property (nonatomic, strong) NSString    * merchantCardName;
@property (nonatomic, strong) NSArray     * privilegeArray;     //特权集合  

- (id)initWithDic:(NSDictionary *)dic;

@end
