//
//  PayPrivilegeModel.m
//  WanJiCard
//
//  Created by 孙明月 on 16/7/23.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "PayPrivilegeModel.h"

@implementation PayPrivilegeModel
- (instancetype)initWithDic:(NSDictionary *)dic{
    
    if (self = [super init]) {
        
        self.privilegeId = ToString([dic objectForKey:@"privilegeId"]);
        self.merchantCardId = ToString([dic objectForKey:@"merchantCardId"]);
        self.merchantPrivilegeDes = ToString([dic objectForKey:@"merchantPrivilegeDes"]);
        self.privilegeName = ToString([dic objectForKey:@"privilegeName"]);
        self.privilegePic = ToString([dic objectForKey:@"privilegePic"]);
        
    }
    return self;
}

@end
