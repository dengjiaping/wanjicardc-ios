//
//  WJMerchantImageModel.h
//  WanJiCard
//
//  Created by Angie on 15/9/24.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "BaseDBModel.h"

@interface WJMerchantImageModel : BaseDBModel

@property (nonatomic, strong) NSString *picId;
@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, assign) ColorType cType;
@property (nonatomic, strong) NSString *desc;

@end
