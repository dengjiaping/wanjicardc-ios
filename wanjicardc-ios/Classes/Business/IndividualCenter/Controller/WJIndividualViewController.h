//
//  WJIndividualControllerViewController.h
//  WanJiCard
//
//  Created by wangzhangjie on 15/9/1.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJViewController.h"
#import "WJModelArea.h"
@class APIUserLogoutManager;
@class APIUserUpdateManager;
typedef void (^CBEngineCallback)(id datas, id data, NSError *error);

@interface WJIndividualViewController : WJViewController

@property(strong,nonatomic) UITableView * tableView;
@property(nonatomic,strong) NSArray * listTop;
@property(nonatomic,strong) NSMutableArray * listMiddle;
@property(nonatomic,strong) NSArray * listfooter;

@property(nonatomic,strong) UIButton * exitButton;

//弹出选择，拍照／相册

@property(strong,nonatomic) UIButton * photoButton;
@property(strong,nonatomic) UIButton * pictureButton;
@property(strong,nonatomic) UIView * photoView;

@property(strong,nonatomic) UIActionSheet* sexSheet;
@property(strong,nonatomic) UIActionSheet* birthSheet;
@property(strong,nonatomic) UIDatePicker * datePicker;
@property(strong,nonatomic) UIActionSheet* addressSheet;

@property(strong,nonatomic) UIPickerView * pickerView;
@property(strong,nonatomic) NSMutableArray* provinceArray;
@property(strong,nonatomic) NSMutableArray* cityArray;

@property(strong,nonatomic) APIUserLogoutManager * APIlogout;

@property (nonatomic, strong)NSMutableArray         *dataArray;
@property(strong,nonatomic) APIUserUpdateManager    *updateManager;

@property(strong,nonatomic) UILabel * rightLabel;
@property(strong,nonatomic) UILabel * rightNameLabel;
@property(strong,nonatomic) UILabel * rightGenderLabel;
@property(strong,nonatomic) UILabel * rightBirthLabel;
@property(strong,nonatomic) UILabel * rightAreaLabel;

@property(strong,nonatomic)NSDate *userBirthDate;

//最终选定的省，市
@property(strong,nonatomic) WJModelArea *selectedProvinceArea;
@property(strong,nonatomic) WJModelArea *selectedCityArea;

//图片2进制路径
@property(strong,nonatomic) NSString* filePath;

//-(void)signAndPostToServer:(NSData *) imgdata;
@end
