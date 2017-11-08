//
//  APISynProductManager.m
//  WanJiCard
//
//  Created by Lynn on 15/9/7.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "APISynProductManager.h"

@implementation APISynProductManager
#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.paramSource = self;
        self.validator = self;
    }
    return self;
}

#pragma mark - APIManagerVaildator
/*
 所有的callback数据都应该在这个函数里面进行检查，事实上，到了回调delegate的函数里面是不需要再额外验证返回数据是否为空的。
 因为判断逻辑都在这里做掉了。
 而且本来判断返回数据是否正确的逻辑就应该交给manager去做，不要放到回调到controller的delegate方法里面去做。
 */
- (BOOL)manager:(APIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data
{
    return [data[@"rspCode"] integerValue] == 0;
}
/*
 当调用API的参数是来自用户输入的时候，验证是很必要的。
 当调用API的参数不是来自用户输入的时候，这个方法可以写成直接返回true。反正哪天要真是参数错误，QA那一关肯定过不掉。
 不过我还是建议认真写完这个参数验证，这样能够省去将来代码维护者很多的时间。
 
 */
- (BOOL)manager:(APIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data
{
    return self.proIDs && [self.proIDs count] > 0;
}

#pragma mark - APIManagerParamSourceDelegate
//让manager能够获取调用API所需要的数据
- (NSDictionary *)paramsForApi:(APIBaseManager *)manager
{
    
    NSMutableString * proIDStr = [NSMutableString string];
    if ([self.proIDs count] > 0) {
        proIDStr = [NSMutableString stringWithFormat:@"%@", [self.proIDs objectAtIndex:0]];
    }
    
    for (int i = 1; i < [self.proIDs count]; i++) {
        [proIDStr appendString:[NSString stringWithFormat:@",%@",[self.proIDs objectAtIndex:i]]];
    }
    
    return [NSDictionary dictionaryWithObjectsAndKeys:proIDStr,@"pcid",nil];
}

#pragma mark - APIManager Methods
- (NSString *)methodName
{
    return @"/product/receive";
}

- (NSString *)serviceType
{
    return kAPIServiceWanJiKa;
}

- (APIManagerRequestType)requestType
{
    return APIManagerRequestTypePost;
}

@end
