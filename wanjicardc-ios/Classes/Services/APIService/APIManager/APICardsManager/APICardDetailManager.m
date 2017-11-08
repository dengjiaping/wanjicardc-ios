//
//  APICardDetailManager.m
//  WanJiCard
//
//  Created by Harry Hu on 15/9/6.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "APICardDetailManager.h"

@implementation APICardDetailManager

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

//{
//    rspCode = 000;
//    rspMsg = "\U6210\U529f";
//    val =     {
//        ad = "1\U3001\U8fdb\U5e97\U6d88\U8d39\U65f6\U51fa\U793a\U81ea\U5df1\U7684\U6570\U5b57\U7801/\U6761\U5f62\U7801/\U4e8c\U7ef4\U7801\U5927\U60a6\U57ce\U5e97\U8425\U4e1a\U65f6\U95f4\U4ee5\U5546\U573a\U95ed\U5e97\U65f6\U95f4\U4e3a\U51c6";
//        balance = 1000;
//        cardColor = 2;
//        cardLogo = "http://ca.wjika.com/Assets/img/application/productcard/Ef0quJWGCP.png";
//        cardName = "Hi\U8fa3\U706b\U9505\U4f1a\U5458\U50a8\U503c\U5361";
//        merchantId = 1505;
//        privilege =         (
//                             {
//                                 inUse = 1;
//                                 merchantPrivilegeDes = "\U8d2d\U5361\U91d1\U989d\U8fbe\U5230XXX\U5143\Uff0c\U5373\U53ef\U4eab\U53d7XX\U7279\U6743\Uff01";
//                                 privilegeName = 222;
//                                 privilegePic = "http://7xouy6.com2.z0.glb.qiniucdn.com/wjika-java/610100dc4b0b438a9c8c20a3a8d31fee.jpg";
//                                 privilegeType = 0;
//                             }
//                             );
//        totalRecharge = "<null>";
//    };
//}


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
    return self.merId.length > 0;
}

#pragma mark - APIManagerParamSourceDelegate
//让manager能够获取调用API所需要的数据
- (NSDictionary *)paramsForApi:(APIBaseManager *)manager
{    
    return @{@"merchantCardId":self.merId};
}

#pragma mark - APIManager Methods
- (NSString *)methodName
{
    return @"/userCard/userCardDetail";
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
