//
//  WJUpdateLocationModel.m
//  WanJiCard
//
//  Created by Lynn on 15/10/29.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJUpdateLocationModel.h"
#import "APIUpdateLocationManager.h"
#import "LocationManager.h"

static WJUpdateLocationModel *model = nil;

@interface WJUpdateLocationModel()<APIManagerCallBackDelegate>
{
    BOOL    isNeedUpdate;
}
@property (nonatomic, strong) APIUpdateLocationManager * updateManager;

@end

@implementation WJUpdateLocationModel


+ (WJUpdateLocationModel *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[WJUpdateLocationModel alloc] init];
        [kDefaultCenter addObserver:model selector:@selector(updateLocation) name:kLocationUpdate object:nil];
        
    });
    return model;
}

- (void)updateLocation
{
    if (!isNeedUpdate) {
        [self.updateManager loadData];
        isNeedUpdate = YES;
    }
}


- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    [kDefaultCenter removeObserver:self name:kLocationUpdate object:nil];
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    [kDefaultCenter removeObserver:self name:kLocationUpdate object:nil];

}


- (APIUpdateLocationManager *)updateManager
{
    if (_updateManager == nil) {
        _updateManager  = [[APIUpdateLocationManager alloc] init];
        _updateManager.delegate = self;
    }
    _updateManager.latitude = [WJGlobalVariable sharedInstance].appLocation.latitude;
    _updateManager.longitude = [WJGlobalVariable sharedInstance].appLocation.longitude;
    return _updateManager;
}

@end
