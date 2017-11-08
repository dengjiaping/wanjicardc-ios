//
//  ModelArea.h
//  WanJiCard
//
//  Created by Harry Hu on 15/8/28.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDBModel.h"


@interface WJModelArea : BaseDBModel

@property (nonatomic, strong) NSString *areaId;
@property (nonatomic, strong) NSString *name;       //地区名字
@property (nonatomic, strong) NSString *oname;
@property (nonatomic, strong) NSString *orderName;
@property (nonatomic, strong) NSString *parentid;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) NSInteger ishot;
@property (nonatomic, assign) float lat;
@property (nonatomic, assign) float lng;
@property (nonatomic, assign) NSInteger zoom;
@property (nonatomic, assign) NSInteger region;
@property (nonatomic, assign) NSInteger isUse;


@end
