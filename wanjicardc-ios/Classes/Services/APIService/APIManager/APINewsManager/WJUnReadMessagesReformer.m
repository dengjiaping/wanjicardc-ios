//
//  WJUnReadMessagesReformer.m
//  WanJiCard
//
//  Created by XT Xiong on 16/7/5.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJUnReadMessagesReformer.h"
#import "WJUnReadMessagesModel.h"

@implementation WJUnReadMessagesReformer

- (id)manager:(APIBaseManager *)manager reformData:(id)data
{
    if ([data isKindOfClass:[NSDictionary class]]) {
        WJUnReadMessagesModel * unReadMessagesModel = [[WJUnReadMessagesModel alloc] initWithDictionary:[data objectForKey:@"news"]];
        return unReadMessagesModel;
    }
    return nil;
}

@end
