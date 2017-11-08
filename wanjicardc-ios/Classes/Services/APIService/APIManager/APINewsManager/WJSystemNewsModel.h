//
//  WJSystemNewsModel.h
//  WanJiCard
//
//  Created by XT Xiong on 16/7/6.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

//系统和活动

#import <Foundation/Foundation.h>

@interface WJSystemNewsModel : NSObject

@property(nonatomic,strong) NSString     * activityUrl;
@property(nonatomic,strong) NSString     * content;         //内容
@property(nonatomic,strong) NSString     * pcUrl;
@property(nonatomic,strong) NSString     * theme;           //标题
@property(nonatomic,strong) NSString     * type;
@property(nonatomic,strong) NSString     * word;            //活动运营语
@property(nonatomic,strong) NSString     * date;
@property(nonatomic,strong) NSString     * time;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
