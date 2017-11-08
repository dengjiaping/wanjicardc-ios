//
//  APIAdvertiseManager.h
//  WanJiCard
//
//  Created by reborn on 16/7/13.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIAdvertiseManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>
@property (nonatomic, strong) NSString *picSize;

@end
