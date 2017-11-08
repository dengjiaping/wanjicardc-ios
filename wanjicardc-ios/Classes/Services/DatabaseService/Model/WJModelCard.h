//
//  WJModelCard.h
//  WanJiCard
//
//  Created by Lynn on 15/9/8.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJModelCard : NSObject

@property (nonatomic, strong) NSString      *coverURL;
@property (nonatomic, assign) CGFloat       faceValue;          //面额
@property (nonatomic, strong) NSString      *freeCardID;
@property (nonatomic, strong) NSString      *name;
@property (nonatomic, assign) NSInteger     saledNumber;
@property (nonatomic, assign) CGFloat       balance;          //余额
@property (nonatomic, assign) OrderStatus   status;
@property (nonatomic, assign) NSInteger     colorType;
@property (nonatomic, strong) NSString      *merName;
@property (nonatomic, strong) NSString      *merId;              //所属商家


//@property (nonatomic, strong) NSString *cardId;             //id
//@property (nonatomic, strong) NSString *name;               //名称
//@property (nonatomic, assign) NSInteger amount;             //金额
//@property (nonatomic, strong) NSString *cover;

- (instancetype)initWithDic:(NSDictionary *)dic;

-(id)initWithCursor:(FMResultSet *)cursor;

@end
