//
//  WJShareModel.h
//  WanJiCard
//
//  Created by wangzhangjie on 15/9/24.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJShareModel : NSObject

@property(strong,nonatomic) NSString * title;
@property(strong,nonatomic) NSString * content;
@property(strong,nonatomic) NSString * shareContent;
@property(strong,nonatomic) NSString * imgUrl;
@property(strong,nonatomic) NSString * shareImgUrl;
@property(strong,nonatomic) NSString * shareURL;

- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
