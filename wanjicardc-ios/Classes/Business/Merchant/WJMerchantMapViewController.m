//
//  WJMerchantMapViewController.m
//  WanJiCard
//
//  Created by XT Xiong on 16/5/20.
//  Copyright © 2016年 zOne. All rights reserved.
//

#import "WJMerchantMapViewController.h"

#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>

@interface WJMerchantMapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate>

@property(nonatomic,strong)BMKMapView             * mapView;
@property(nonatomic,strong)BMKLocationService     * locService;

@end

@implementation WJMerchantMapViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
    self.locService.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
    self.locService.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商户位置";
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    [self addMapUI];
    [self startLocation];
}

#pragma mark - BMKMapViewDelegate

//用户方向更新后，会调用此函数
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [self.mapView updateLocationData:userLocation];
}

//用户位置更新后，会调用此函数
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [self.mapView  updateLocationData:userLocation];
}

- (void)addMapUI
{
    self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, -64, kScreenWidth, kScreenHeight)];
    [self.mapView setZoomLevel:15];
    [self.view addSubview:self.mapView];
    //添加大头针
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = [self.merchantLatitude floatValue];
    coor.longitude = [self.merchantLongitude floatValue];
    annotation.coordinate = coor;
    annotation.title = self.merchantName;
    
    [self.mapView addAnnotation:annotation];
    self.mapView.centerCoordinate = coor;
//    [self.mapView selectAnnotation:annotation animated:YES];
    
}

-(void)startLocation
{
    [self.locService startUserLocationService];
    self.mapView.showsUserLocation = NO;
    self.mapView.userTrackingMode = BMKUserTrackingModeNone;
    self.mapView.showsUserLocation = YES;
    
}

-(BMKMapView*)mapView
{
    if (_mapView==nil)
    {
        _mapView =[BMKMapView new];
    }
    return _mapView;
}

-(BMKLocationService*)locService
{
    if (_locService==nil)
    {
        _locService = [[BMKLocationService alloc]init];
    }
    return _locService;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
