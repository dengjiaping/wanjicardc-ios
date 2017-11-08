//
//  PayPrivilegeModel.h
//  WanJiCard
//
//  Created by 孙明月 on 16/7/23.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayPrivilegeModel : NSObject

@property (nonatomic, strong) NSString      *privilegeId;
@property (nonatomic, strong) NSString      *merchantCardId;
@property (nonatomic, strong) NSString      *merchantPrivilegeDes;
@property (nonatomic, strong) NSString      *privilegeName;
@property (nonatomic, strong) NSString      *privilegePic;


@property (nonatomic, assign) BOOL isOwn;

- (instancetype) initWithDic:(NSDictionary *)dic;

@end
