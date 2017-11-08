//
//  WJMoreBrandesModel.h
//  WanJiCard
//
//  Created by XT Xiong on 16/6/2.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIBaseManager.h"

@interface WJMoreBrandesModel : NSObject

@property(nonatomic,strong) NSString     * brandPhotoUrl;
@property(nonatomic,strong) NSString     * hotNum;
@property(nonatomic,strong) NSString     * logoUrl;
@property(nonatomic,strong) NSString     * name;
@property(nonatomic,strong) NSString     * merchantAccountId;
@property(nonatomic,strong) NSString     * merchantBranchId;
@property(nonatomic,assign) BrandType     brandType;
@property(nonatomic,strong) NSString     * color;
- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
