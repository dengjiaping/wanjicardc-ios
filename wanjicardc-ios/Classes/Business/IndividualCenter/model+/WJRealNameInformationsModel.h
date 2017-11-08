//
//  WJRealNameInformationsModel.h
//  WanJiCard
//
//  Created by maying on 2017/8/12.
//  Copyright © 2017年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJRealNameInformationsModel : NSObject


@property (nonatomic, strong) NSString     * userIdcard;
@property (nonatomic, strong) NSString     * userRealname;

- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
