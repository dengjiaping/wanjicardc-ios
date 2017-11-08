//
//  LocationManager.m
//  WanJiCard
//
//  Created by Angie on 15/9/21.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "LocationManager.h"
#import "APICityListManager.h"
#import "WJDBAreaManager.h"
#import "WJDBAreaVersionManager.h"

#import <Contacts/Contacts.h>

@interface LocationManager ()<CLLocationManagerDelegate, MKMapViewDelegate, APIManagerCallBackDelegate>{
    BOOL canTips;
    CLGeocoder *geo;
}

@property (nonatomic, strong) CLLocationManager *locaManager;
@property (nonatomic, strong) APICityListManager *cityListManager;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSError *clError;


@end

@implementation LocationManager

static LocationManager *s = nil;

+ (LocationManager *)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s = [[LocationManager alloc] init];
    });
    return s;
}


- (id)init{
    
    if (s) {
        return s;
    }
    
    if (self = [super init]) {
        geo = [[CLGeocoder alloc] init];
    }
    return self;
}


- (void)initCoreLoacation{
    
    [self.locaManager startUpdatingLocation];
    [self.cityListManager loadData];
}


+ (void)getSelfLocationInChina{
    //因为要反地址编码，基于火星坐标，要使用mapview定位出来的坐标；
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectMake(-100, 100, 1, 1)];
    mapView.delegate = s;
    mapView.showsUserLocation = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:mapView];
}


+ (NSString *)gpsAddress{
    
    return s.address;
}


+ (NSError *)gpsError{
    
    return s.clError;
}


- (void)revertGeocodeCoordinate:(CLLocation *)currLocation{
    
    
    [WJGlobalVariable sharedInstance].appLocation = currLocation.coordinate;
    
    if (currLocation.coordinate.latitude != 0 && currLocation.coordinate.longitude != 0) {
        [kDefaultCenter postNotificationName:kLocationUpdate object:nil];
    }
    NSLog(@"user 纬度=%f 经度=%f 高度=%f", currLocation.coordinate.latitude, currLocation.coordinate.longitude, currLocation.altitude);
    
    [geo cancelGeocode];
    [geo reverseGeocodeLocation:currLocation
              completionHandler:^(NSArray *placemarks, NSError *error) {
                  if (error || placemarks.count==0) {
                      NSLog(@"你输入的地址没找到，可能在月球上");
                      self.clError = error;
                  }else{
                      
                      self.clError = nil;
                      
                      CLPlacemark *place = [placemarks lastObject];
                      [self setCurrentAreaByName:[self generateCityName:place]];
                      self.address = [[place.addressDictionary[@"FormattedAddressLines"] firstObject]  stringByReplacingOccurrencesOfString:@"中国" withString:@""];

                      //北京京宝大厦坐标 39.950799, 116.400585
                      NSLog(@"name-------------------- %@", self.address);
                      [self refershLocationDataAction];

                  }
              }];
}
- (void)refershLocationDataAction{
    static dispatch_once_t disOnce;
    dispatch_once(&disOnce,  ^ {
        [kDefaultCenter postNotificationName:@"RefershLocationData" object:nil];
    });
}

- (NSString *)generateCityName:(CLPlacemark *)place{
    NSString *cityName = place.locality;
    if ([place.administrativeArea hasPrefix:@"北京"]||
        [place.administrativeArea hasPrefix:@"beijing"]||
        [place.administrativeArea hasPrefix:@"天津"]||
        [place.administrativeArea hasPrefix:@"tianjin"]||
        [place.administrativeArea hasPrefix:@"上海"]||
        [place.administrativeArea hasPrefix:@"shanghai"]||
        [place.administrativeArea hasPrefix:@"重庆"]||
        [place.administrativeArea hasPrefix:@"chongqing"]) {
        cityName = [place.administrativeArea stringByReplacingOccurrencesOfString:@"市" withString:@""];
    }
    if (!cityName) {
        cityName = place.subLocality;
    }
    return cityName;
}


#pragma mark - CLLocationManagerDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    [self revertGeocodeCoordinate:userLocation.location];
    canTips = YES;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currLocation = [locations lastObject];

    [self revertGeocodeCoordinate:currLocation];
    
    canTips = YES;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    self.address = nil;
  
    if ([error domain] == kCLErrorDomain) {
        
        // We handle CoreLocation-related errors here
        self.clError = error;
        
        if ([error code] == kCLErrorDenied)
        {
            //访问被拒绝
            NSLog(@"定位已被关闭");
            static dispatch_once_t disOnce;
            dispatch_once(&disOnce,  ^ {
                [kDefaultCenter postNotificationName:@"RefershLocationData" object:nil];
            });
        }
        if ([error code] == kCLErrorLocationUnknown) {
            //无法获取位置信息
            NSLog(@"定位失败");
            if (canTips) {
//                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"定位失败"];
                canTips = NO;
            }
        }
    }
}


#pragma mark - APIManagerCallBackDelegate

- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager{
    NSDictionary *allCity = [manager fetchDataWithReformer:nil];

    if ([allCity isKindOfClass:[NSDictionary class]]) {
        WJDBAreaVersionManager *areaVersionManager = [WJDBAreaVersionManager new];
        [areaVersionManager insertAreaVersion:[allCity[@"cityVersion"] integerValue]];
        
        WJDBAreaManager *areaManager = [WJDBAreaManager new];
        NSArray *arr = allCity[@"result"];
        for (NSDictionary *dic in arr) {
            WJModelArea * area = [[WJModelArea alloc] initWithDic:dic];
                //type类型： 增删改 分别对应 123
            if([dic[@"operationType"] integerValue] == 2){
            
                [areaManager remove:area.areaId];
                
            }else{
                
                [areaManager insertArea:area];
            }
        }
    }
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager{
    NSLog(@"城市请求失败");
}

#pragma mark - 属性访问方法

- (CLLocationManager *)locaManager
{
    if (nil ==  _locaManager) {
        if ([CLLocationManager locationServicesEnabled]) {
            _locaManager = [[CLLocationManager alloc] init];
            _locaManager.delegate = s;
            _locaManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
            _locaManager.distanceFilter = 100;
            
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
            if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
                [_locaManager requestWhenInUseAuthorization];//添加这句
            }
#endif
        }
    }
    
    return _locaManager;
}

- (void)setCurrentAreaByName:(NSString *)cityName{

    WJModelArea *area = [[WJDBAreaManager new] getAreaByCityName:[WJUtilityMethod dealWithAreaName:cityName]];
    if (!area) {
        area = [[WJDBAreaManager new] getAreaByAreaId:@"1"];
    }
    [[NSUserDefaults standardUserDefaults] setObject:area.name forKey:@"cityName"];
    [[NSUserDefaults standardUserDefaults] setObject:area.areaId forKey:@"cityID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    _currentArea = area;

}


- (void)setChoosedArea:(WJModelArea *)area{
//    _choosedArea = area;

    [[NSUserDefaults standardUserDefaults] setObject:[WJUtilityMethod dealWithAreaName:area.name] forKey:@"chooseCity"];
    [[NSUserDefaults standardUserDefaults] setObject:area.areaId forKey:@"chooseCityID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (WJModelArea *)choosedArea{
    
    WJModelArea *choose = nil;
    
    NSString *chooseId = [[NSUserDefaults standardUserDefaults] objectForKey:@"chooseCityID"];
    if (!chooseId) {
        WJModelArea *current = [LocationManager sharedInstance].currentArea;
        if (!current.isUse) {
            choose = [[WJDBAreaManager new] getAreaByAreaId:@"1"];
        }else{
            choose = current;
        }
    }else{
        choose = [[WJDBAreaManager new] getAreaByAreaId:chooseId];
    }
    
    return choose;
}

#pragma mark - RequestManager

- (APICityListManager *)cityListManager{
    if (!_cityListManager) {
        _cityListManager = [[APICityListManager alloc] init];
        _cityListManager.delegate = self;
    }
    return _cityListManager;
}

@end
