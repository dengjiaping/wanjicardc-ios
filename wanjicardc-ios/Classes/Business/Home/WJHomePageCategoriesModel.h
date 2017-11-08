//
//  WJHomePageCategoriesModel.h
//  WanJiCard
//
//  Created by silinman on 16/6/3.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJHomePageCategoriesModel : NSObject

@property(nonatomic,strong) NSString        * categoryId;
@property(nonatomic,strong) NSString        * Id;
@property(nonatomic,strong) NSString        * img;
@property(nonatomic,strong) NSString        * name;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
