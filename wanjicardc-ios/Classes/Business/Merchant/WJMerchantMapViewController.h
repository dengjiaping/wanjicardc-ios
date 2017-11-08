//
//  WJMerchantMapViewController.h
//  WanJiCard
//
//  Created by XT Xiong on 16/5/20.
//  Copyright © 2016年 zOne. All rights reserved.
//

#import "WJViewController.h"
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>


@interface WJMerchantMapViewController : WJViewController

@property(nonatomic,strong) NSString     * merchantLatitude;
@property(nonatomic,strong) NSString     * merchantLongitude;
@property(nonatomic,strong) NSString     * merchantAddress;
@property(nonatomic,strong) NSString     * merchantName;


@end
