//
//  WJIndividualControllerViewController.m
//  WanJiCard
//
//  Created by wangzhangjie on 15/9/1.
//  Copyright (c) 2015年 zOne. All rights reserved.
//
#import <AFNetworking/AFNetworking.h>
#import "WJIndividualViewController.h"

//#import "WJIndividualNameViewController.h"
#import "WJDBAreaManager.h"
#import "SecurityService.h"
#import "APIUserLogoutManager.h"
//#import "WJIndividualNameReformer.h"
#import "APIUserUpdateManager.h"
#import "AppDelegate.h"

#import "APIUserDetailManager.h"
#import "WJAlertView.h"
#import "WJSignCreateManager.h"
#define uploadHead                 @"uploadHeadNofifation"
#define changeImg                  @"changeImaAction"
#import <AVFoundation/AVFoundation.h>
#import "WJRealNameAuthenticationViewController.h"
#import "WJCompleteRealNameViewController.h"

#if TestAPI
    NSString *const kCBBaseURL =  @"http://123.56.253.122:8081/wjapp_mobile/card";
#else
    NSString *const kCBBaseURL = @"http://mobilecardc.wjika.com/wjapp_mobile/card";
#endif


@interface WJIndividualViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UIPickerViewDelegate,UIPickerViewDataSource,APIManagerCallBackDelegate,WJAlertViewDelegate>

{
    BOOL _cameraIsAuthorize;
    NSInteger rowInProvince;
    NSInteger rowInCity;
}

@property (strong,nonatomic) MBProgressHUD* hud;

@property (assign,nonatomic) BOOL isShowing;

@end

@implementation WJIndividualViewController

#pragma mark- Life cycle


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad -- %@", [NSDate date]);

    [self.view addSubview:self.tableView];

//    [self.view addSubview:self.exitButton];

    self.navigationItem.title = @"个人信息";

    [self addNotification];
   
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear -- %@", [NSDate date]);
    
//    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        NSLog(@"相机权限受限");
        _cameraIsAuthorize = NO;
 
    }else
    {
        _cameraIsAuthorize = YES;
    }

}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear -- %@", [NSDate date]);
}

- (void)dealloc
{
    [self removeNofitcation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- UITableViewDelegate & UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"Cell1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (nil==cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellWithIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        [cell.textLabel setTextColor:WJColorDardGray3];
    }
    
    WJModelPerson *defaultPerson = [WJGlobalVariable sharedInstance].defaultPerson;

    if(0 ==indexPath.section)
    {
        // 第一部分，头像
        if(0==indexPath.row)
        {
            NSDictionary * dic = [self.listTop  objectAtIndex:indexPath.row];
            
            // 包含箭头
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 70, 40)];
            UIImageView *imageview1 = [[UIImageView alloc]initWithFrame:CGRectMake(58, 13, 12 , 12)];
            imageview1.image = [UIImage imageNamed:@"r_icon"];
            // 头像圆
            UIImageView *iv = [[UIImageView alloc] initForAutoLayout];
            iv.layer.cornerRadius = 22;
            iv.layer.masksToBounds = YES;
            [view addSubview:iv];
            [iv sd_setImageWithURL:[NSURL URLWithString:defaultPerson.headImageUrl]
                  placeholderImage:[UIImage imageNamed:@"default_avatar_bg"]];
            
            [view addConstraints:[iv constraintsSize:CGSizeMake(44, 44)]];
            [view addConstraints:[iv constraintsLeftInContainer:8]];
            [view addConstraint:[iv constraintCenterYEqualToView:view]];
            
            [view addSubview:iv];
            [view addSubview:imageview1];
            // xxxx
            if (nil!=defaultPerson.headImageUrl && ![@"" isEqual:defaultPerson.headImageUrl]) {
                
                cell.accessoryView =view;
                
            }else
            {
                cell.accessoryView =view;
                
            }
           
            cell.textLabel.text = dic[@"text"];
            
        }
    }else if (1==indexPath.section)
    {
        // 第2部分，姓名，性别，所在地
        NSDictionary * dic = [self.listMiddle  objectAtIndex:indexPath.row];
        cell.textLabel.text = dic[@"text"];
        
        // 刷新，以后还是自定义吧
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 222, 40)];
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(210, 13, 12 , 12)];
        imageview.image = [UIImage imageNamed:@"r_icon"];
        
        UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 205, 40)];
        
        WJModelPerson *defaultPerson = [WJGlobalVariable sharedInstance].defaultPerson;
        
        
        if (0 == indexPath.row) {
            
            if (defaultPerson.authentication == AuthenticationNo) {
                nameLabel.text = @"未设置";
                
            } else {
                
                NSRange tRange;
                
                if (![defaultPerson.realName isEqualToString:@""] && defaultPerson.realName != nil) {
                    
                    if (defaultPerson.realName.length == 2) {
                        tRange = NSMakeRange(1, 1);
                        nameLabel.text = [defaultPerson.realName stringByReplacingCharactersInRange:tRange withString:@"*"];
                        
                    } else {
                        
                        tRange = NSMakeRange(1, 2);
                        nameLabel.text = [defaultPerson.realName stringByReplacingCharactersInRange:tRange withString:@"**"];
                        
                    }
                }
                
                
            }
            
        } else {
            
            if ([dic[@"value"] length] > 0) {
                
                nameLabel.text = dic[@"value"];
                
            }else{
                
                nameLabel.text = @"未设置";
            }
            
        }

        nameLabel.textAlignment = NSTextAlignmentRight;
        nameLabel.textColor = WJColorDardGray9;
        nameLabel.font = [UIFont systemFontOfSize:16];
        [nameLabel addSubview:imageview];
      
        [view addSubview:imageview];
        [view addSubview:nameLabel];
        cell.accessoryView = view;
    }

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return ALD(60);
    }
//    else if(indexPath.section==1)
//    {
//        return ALD(45);
//    }
    else
    {
        return ALD(45);
    }
   
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (0 == section)
    {
        return 1;
    }else {
        return 4;
    }

   
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ALD(15);
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [UIView new];
    return headView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    WJModelPerson *defaultPerson = [WJGlobalVariable sharedInstance].defaultPerson;
    
    if (![WJUtilityMethod isNotReachable]){
        
        if (!self.isShowing) {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"当前网络不可用，请检查网络"];
            self.isShowing = YES;
            [self performSelector:@selector(showAction) withObject:self afterDelay:2];
        }
        
    }else{
        switch (indexPath.section) {
            case 0:{
                // 拍照&相册
                [self.view addSubview:self.photoView];
                
                [self.view insertSubview:self.photoButton aboveSubview:self.photoView];
                [self.view insertSubview:self.pictureButton aboveSubview:self.photoView];
                
                
            }
                break;
                
            case 1:{
                switch (indexPath.row) {
                    case 0:{
                        if (defaultPerson.authentication == AuthenticationNo) {
                            // 个人姓名
                            WJRealNameAuthenticationViewController *realNameAuthenticationVC = [[WJRealNameAuthenticationViewController alloc] init];
                            realNameAuthenticationVC.comefrom = ComeFromIndividualInformation;
                            [WJGlobalVariable sharedInstance].fromController = self;
                            [self.navigationController pushViewController:realNameAuthenticationVC animated:YES];
                            
                        }  else {
                            WJCompleteRealNameViewController *completeAuthenticationVC = [[WJCompleteRealNameViewController alloc] init];
                            [self.navigationController pushViewController:completeAuthenticationVC animated:YES];
                        }

                    }
                        break;
                    case 1:{
                        //性别
                        
                        [self.sexSheet showInView:self.view];
                    }
                        break;
                    case 2:{
                        
                        WJModelPerson *defaultPerson = [WJGlobalVariable sharedInstance].defaultPerson;
                        //生日
                        UIView * maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
                        maskView.backgroundColor = [UIColor blackColor];
                        maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
                        [maskView addSubview:self.datePicker];
                        
                        //默认显示当前用户的生日
                        NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
                        [dateFormater setDateFormat:@"yyyy-MM-dd"];
                        
                        NSString * listMiddleBirth =nil;
                        NSString * listMiddleBirthYear = defaultPerson.birthdayYear;
                        NSString * listMiddleBirthMonth = defaultPerson.birthdayMonth;
                        NSString * listMiddleBirthDay = defaultPerson.birthdayDay;
                        
                        if ([@"" isEqual:defaultPerson.birthdayYear] || nil ==defaultPerson.birthdayYear ||[@"" isEqual:defaultPerson.birthdayMonth] ||nil == defaultPerson.birthdayMonth ||[@"" isEqual:defaultPerson.birthdayDay] || nil ==defaultPerson.birthdayDay || [defaultPerson.birthdayYear intValue]<=0 || [defaultPerson.birthdayMonth intValue]<=0 || [defaultPerson.birthdayDay intValue]<=0) {
                            
                            listMiddleBirth =@"";
                            [_datePicker setDate:_datePicker.maximumDate animated:YES];
                            
                        }else
                        {
                            listMiddleBirth = [NSString stringWithFormat:@"%@%@%@%@%@",listMiddleBirthYear,@"-",listMiddleBirthMonth,@"-",listMiddleBirthDay];
                            
                            self.userBirthDate = [dateFormater dateFromString:listMiddleBirth];
                            [_datePicker setDate:_userBirthDate animated:YES];
                            
                        }
                        
                        UIView * grayView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-240, kScreenWidth, 40)];
                        grayView.backgroundColor = [WJUtilityMethod colorWithHexColorString:@"aeaeae"];
                        [maskView addSubview:grayView];
                        
                      
                        UILabel *birthLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, kScreenWidth-120, 40)];
                         birthLabel.text = @"设置生日";
                        birthLabel.font = WJFont17;
                        [birthLabel setTextColor:WJColorDardGray3];
                        [birthLabel setTextAlignment:NSTextAlignmentCenter];
                        birthLabel.backgroundColor=[UIColor whiteColor];
                        [grayView addSubview:birthLabel];
                        
                        // 添加确定button
                        UIButton *okButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-60, 0, 60, 40)];
                        
                        okButton.backgroundColor = [UIColor whiteColor];
                        [okButton setTitle:@"确定" forState:UIControlStateNormal];
                        [okButton.titleLabel setFont:WJFont15];
                        [okButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
                        [okButton addTarget:self action:@selector(clickOk:) forControlEvents:UIControlEventTouchUpInside];
                        [grayView addSubview:okButton];
                        
                        
                        //  取消button
                        UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
                        cancelButton.backgroundColor = [UIColor whiteColor];
                        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
                        [cancelButton.titleLabel setFont:WJFont15];
                        [cancelButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
                        [cancelButton addTarget:self action:@selector(clickCancel:) forControlEvents:UIControlEventTouchUpInside];
                        [grayView addSubview:cancelButton];
                        
                        
                        //添加手势
                        UITapGestureRecognizer *tapGestureBirth = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapgesture:)];
                        [maskView addGestureRecognizer:tapGestureBirth];
                        
                        [[UIApplication sharedApplication].keyWindow addSubview:maskView];
                       
                    }
                        break;
                    case 3:{
                        //所在地
                        WJModelPerson *defaultPerson = [WJGlobalVariable sharedInstance].defaultPerson;
                        
                        UIView * maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
                        maskView.backgroundColor = [UIColor blackColor];
                        maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
                        [maskView addSubview:self.pickerView];
                        
                        UIView * grayView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-240, kScreenWidth, 41)];
                        grayView.backgroundColor = [WJUtilityMethod colorWithHexColorString:@"aeaeae"];
                        [maskView addSubview:grayView];
                        
                        //确定哪个省哪个市
                        BOOL hasLocation = NO;
                        for (int i=0; i<self.provinceArray.count; i++) {
                            WJModelArea *province = [self.provinceArray objectAtIndex:i];
                            if ([defaultPerson.province isEqualToString:province.name]) {
                                rowInProvince = i;
                                
                                NSArray *citys = [[WJDBAreaManager new]getSubAreaByParentId:province.areaId];
                                for (int j=0; j<citys.count; j++) {
                                    WJModelArea *city = [citys objectAtIndex:j];
                                    if ([defaultPerson.city isEqualToString:city.name]) {
                                        rowInCity = j;
                                        hasLocation = YES;
                                        break;
                                    }
                                }
                                if (hasLocation) {
                                    break;
                                }
                            }
                        }
                        [self.pickerView  reloadComponent:0];
                        [self.pickerView  reloadComponent:1];
                        [self.pickerView selectRow:rowInProvince inComponent:0 animated:YES];//设置某列选择某行
                        [self.pickerView selectRow:rowInCity inComponent:1 animated:YES];
                        
                        
                        // xxx
                        UILabel *birthLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 0, kScreenWidth-120, 40)];
                        birthLabel.text = @"设置所在地";
                        birthLabel.font = WJFont17;
                        [birthLabel setTextColor:WJColorDardGray3];
                        [birthLabel setTextAlignment:NSTextAlignmentCenter];
                        birthLabel.backgroundColor=[UIColor whiteColor];
                        [grayView addSubview:birthLabel];
                        
                        // 添加确定button
                        UIButton *okButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-60, 0, 60, 40)];
                        
                        okButton.backgroundColor = [UIColor whiteColor];
                        [okButton setTitle:@"确定" forState:UIControlStateNormal];
                        [okButton.titleLabel setFont:WJFont15];
                        [okButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
                        [okButton addTarget:self action:@selector(clickAreaOk:) forControlEvents:UIControlEventTouchUpInside];
                        [grayView addSubview:okButton];
                        
                        
                        //  取消button
                        UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
                        
                        
                        cancelButton.backgroundColor = [UIColor whiteColor];
                        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
                        [cancelButton.titleLabel setFont:WJFont15];
                        [cancelButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
                        [cancelButton addTarget:self action:@selector(clickAreaCancel:) forControlEvents:UIControlEventTouchUpInside];
                        [grayView addSubview:cancelButton];
                        
                        //添加手势
                        UITapGestureRecognizer *tapGestureAddress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapgesture:)];
                        [maskView addGestureRecognizer:tapGestureAddress];
                        
                        [[UIApplication sharedApplication].keyWindow addSubview:maskView];
                        
                        
                    }
                        break;
                        
                    default:
                        break;
                }
            }
                break;
                
            default:
                break;
        }
        
    }
    
}

#pragma mark - ChangeActiveAction
- (void)appHasGoneInForeground
{
    [self viewWillAppear:YES];
}

- (void)appHasGoneBcakground
{
    [self viewWillDisappear:YES];
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
//    if ([manager isKindOfClass:[APIUserUpdateManager class]]) {
//        self.dataArray = [manager fetchDataWithReformer:[[WJIndividualNameReformer alloc] init]];
//    }
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    [[TKAlertCenter defaultCenter]  postAlertWithMessage:manager.errorMessage];
}


#pragma mark- ActionSheet-delegate

- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    //
   // NSLog(@"点击了。。。cancel");
}


- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
  
    // 存到数据库
    WJModelPerson *defaultPerson = [WJGlobalVariable sharedInstance].defaultPerson;

    if (0 == buttonIndex) {
        defaultPerson.gender = GenderFemale;
       
        [[WJDBPersonManager new] updatePerson:defaultPerson];
        [self updateGenderRequest];

       // 刷新性别
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 107, 40)];
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(95, 13, 12 , 12)];
        imageview.image = [UIImage imageNamed:@"r_icon"];
        
        UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 40)];
         nameLabel.text = @"女";
        nameLabel.textAlignment = NSTextAlignmentRight;
        nameLabel.textColor = WJColorDardGray9;
        nameLabel.font = [UIFont systemFontOfSize:16];
        [nameLabel addSubview:imageview];
        
        [view addSubview:imageview];
        [view addSubview:nameLabel];
        cell.accessoryView = view;

    }else if (1==buttonIndex) {
      
        defaultPerson = [WJGlobalVariable sharedInstance].defaultPerson;
        defaultPerson.gender = GenderMale;
        
        [[WJDBPersonManager new] updatePerson:defaultPerson];
    
        [self updateGenderRequest];
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 107, 40)];
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(95, 13, 12 , 12)];
        imageview.image = [UIImage imageNamed:@"r_icon"];
        
        UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 40)];
        nameLabel.text =@"男";
        nameLabel.textAlignment = NSTextAlignmentRight;
        nameLabel.textColor = WJColorDardGray9;
        nameLabel.font = [UIFont systemFontOfSize:16];
        [nameLabel addSubview:imageview];
        
        [view addSubview:imageview];
        [view addSubview:nameLabel];
        cell.accessoryView = view;
    }else
    {
        // 点击取消则什么都不做
       
    }
      
   
}

-(void) updateGenderRequest {
   
    WJModelPerson *defaultPerson = [WJGlobalVariable sharedInstance].defaultPerson;

    //男性为1，女性为2，。。。
    if (defaultPerson.gender == GenderFemale) {
        self.updateManager.isMale = 2;

    } else {
        self.updateManager.isMale = 1;

    }
    
    self.updateManager.name = defaultPerson.realName;
    
    WJModelArea *city = [[WJDBAreaManager new] getAreaByCityName:defaultPerson.city];
    self.updateManager.address = city.areaId;
    self.updateManager.userBirthday = [NSString stringWithFormat:@"%d,%d,%d",[defaultPerson.birthdayYear intValue],[defaultPerson.birthdayMonth intValue],[defaultPerson.birthdayDay intValue]];

    
    [self.updateManager loadData];
}


#pragma mark- pickview delegate &source 

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (0 == component) {
        
        return [self.provinceArray count];
        
    }else
    {
        return [self.cityArray count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

    if (0 == component) {
        return [[self.provinceArray objectAtIndex:row] name];
        
    }else
    {
        return [[self.cityArray objectAtIndex:row] name];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (0 == component)
    {
        if (nil !=[self.provinceArray objectAtIndex:row]) {
            WJModelArea *province = [self.provinceArray objectAtIndex:row] ;
            
            // 最终选择的省
            self.selectedProvinceArea = province;
            
            rowInProvince = row;
            rowInCity = 0;
            
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            
            self.selectedCityArea = [self.cityArray objectAtIndex:0];
        }
    }
    
    if (1 == component)
    {
        if (nil!=[self.cityArray objectAtIndex:row]) {
 
            rowInCity = row;
            
            WJModelArea *seletedCity = [self.cityArray objectAtIndex:row];
            
            // 最终选择的市
            self.selectedCityArea = seletedCity;

        }
        
    }
}
#pragma mark- CustomDelegate
// TODO:所有自定义协议的实现都写在这里。 mark 的协议名字要与 code 中的协议名字完全一样，方便查找。
#pragma mark- birthday & area  click－event

- (void)showAction
{
    self.isShowing = NO;
}

-(void)clickOk:(UIButton *) button
{
    WJModelPerson *defaultPerson = [WJGlobalVariable sharedInstance].defaultPerson;

    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy-MM-dd"];
    NSString * birth=[dateFormater stringFromDate:self.datePicker.date];
    self.userBirthDate = self.datePicker.date;
    
    //hzq
    defaultPerson.birthdayYear=[[birth componentsSeparatedByString:@"-"] firstObject];
    defaultPerson.birthdayMonth=[birth componentsSeparatedByString:@"-"][1];
    defaultPerson.birthdayDay=[[birth componentsSeparatedByString:@"-"] lastObject];
    
    // 更新到数据库
    [[WJDBPersonManager new] updatePerson:defaultPerson];

    self.updateManager.isMale = defaultPerson.gender;
    self.updateManager.name = defaultPerson.realName;

    WJModelArea *city = [[WJDBAreaManager new] getAreaByCityName:defaultPerson.city];
    self.updateManager.address = city.areaId;
    self.updateManager.userBirthday = [NSString stringWithFormat:@"%d,%d,%d",[defaultPerson.birthdayYear intValue],[defaultPerson.birthdayMonth intValue],[defaultPerson.birthdayDay intValue]];

    [self.updateManager loadData];
    [button.superview.superview removeFromSuperview];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 107, 40)];
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(100, 13, 12 , 12)];
    imageview.image = [UIImage imageNamed:@"r_icon"];
    
    UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 95, 40)];
    nameLabel.text =birth;
    nameLabel.textAlignment = NSTextAlignmentRight;
    nameLabel.textColor = WJColorDardGray9;
    nameLabel.font = [UIFont systemFontOfSize:16];
    [nameLabel addSubview:imageview];
    
    [view addSubview:imageview];
    [view addSubview:nameLabel];
    cell.accessoryView = view;
   
}


-(void)clickCancel:(UIButton *) button
{
    [button.superview.superview removeFromSuperview];
}


-(void)clickAreaOk:(UIButton *) button
{
    WJModelPerson *defaultPerson = [WJGlobalVariable sharedInstance].defaultPerson;
    
    if (self.selectedProvinceArea) {
        defaultPerson.province = self.selectedProvinceArea.name;
    }
    if (self.selectedCityArea) {
        defaultPerson.city = self.selectedCityArea.name;
    }

    if (defaultPerson.province==nil || [defaultPerson.province isEqual:@""]) {
        defaultPerson.province = @"北京市";
    }
    if (defaultPerson.city ==nil || [defaultPerson.city isEqual:@""]) {
        defaultPerson.city =@"北京市";
    }

    [[WJDBPersonManager new] updatePerson:defaultPerson];
 
    self.updateManager.isMale = defaultPerson.gender;
    self.updateManager.name = defaultPerson.realName;
    
    WJModelArea *city = [[WJDBAreaManager new] getAreaByCityName:defaultPerson.city];
    self.updateManager.address = city.areaId;
    self.updateManager.userBirthday = [NSString stringWithFormat:@"%d,%d,%d",[defaultPerson.birthdayYear intValue],[defaultPerson.birthdayMonth intValue],[defaultPerson.birthdayDay intValue]];
    
    
    [self.updateManager loadData];
    
    [button.superview.superview removeFromSuperview];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
    // 刷新省市，以后还是自定义吧
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 222, 40)];
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(210, 13, 12 , 12)];
    imageview.image = [UIImage imageNamed:@"r_icon"];
    
    UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 205, 40)];
    // 具体到城市
    nameLabel.text = [NSString stringWithFormat:@"%@ %@",defaultPerson.province,defaultPerson.city];
    nameLabel.textAlignment = NSTextAlignmentRight;
    nameLabel.textColor = WJColorDardGray9;
    nameLabel.font = [UIFont systemFontOfSize:16];
    [nameLabel addSubview:imageview];
    
    [view addSubview:imageview];
    [view addSubview:nameLabel];
    cell.accessoryView = view;
}

-(void)clickAreaCancel:(UIButton *) button
{
    [button.superview.superview removeFromSuperview];
    
    //所在地
    WJModelPerson *defaultPerson = [WJGlobalVariable sharedInstance].defaultPerson;
    
     //确定哪个省哪个市
    for (int i=0; i < self.provinceArray.count; i++) {
        WJModelArea *province = [self.provinceArray objectAtIndex:i];
        if ([defaultPerson.province isEqualToString:province.name]) {
            rowInProvince = i;
//            self.selectedProvince = province.name;
            self.selectedProvinceArea = province;
            
            NSArray *citys = [[WJDBAreaManager new]getSubAreaByParentId:province.areaId];
            for (int j=0; j<citys.count; j++) {
                WJModelArea *city = [citys objectAtIndex:j];
                if ([defaultPerson.city isEqualToString:city.name]) {
                    rowInCity = j;
//                    self.selectedCity = city.name;
                    self.selectedCityArea = city;
                }
            }
        }
    }

}
#pragma mark- Event Response
// TODO:所有 button、gestureRecognizer、notification 的事件相应方法，与跳转到其他 controller 的出口方法都写在这里。
-(void) tapgesture:(UITapGestureRecognizer*) tap
{
    [tap.view removeFromSuperview];
}

//开始拍照
-(void)takePhoto

{
    [self handletapPressGesture];
    
    if (_cameraIsAuthorize) {
        
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
            
        {
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            
            picker.delegate = self;
            
            //设置拍照后的图片可被编辑
            
            picker.allowsEditing = YES;
            
            picker.sourceType = sourceType;
            
            [self presentViewController:picker animated:YES completion:nil];
            
        }else
        {
            NSLog(@"模拟其中无法打开照相机,请在真机中使用");
        }

    }else{
        
        
        WJAlertView *alert = [[WJAlertView alloc]initWithTitle:nil
                                                       message:@"无法启动相机\n请为万集卡开放相机权限：手机设置->隐私->相机->万集卡（打开）"
                                                      delegate:self
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil
                                                 textAlignment:NSTextAlignmentCenter];
        [alert showIn];

    }

    
 }



//打开本地相册

-(void)LocalPhoto

{
    [self handletapPressGesture];

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    picker.delegate = self;
    
    //设置选择后的图片可被编辑
    
    picker.allowsEditing = YES;
    
    
    [self presentViewController:picker animated:YES completion:nil];
    
    
}
//当选择一张图片后进入这里

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
    
        UIImage* image2 = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        
        UIImage * image = [self scaleToSize:image2 size:CGSizeMake(200 , 200)];
        
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        
        while ([data length]/1024/1024 > 10) {
            
            data = UIImageJPEGRepresentation(image, 0.5);
        }
        
        _filePath = [[NSString alloc]initWithFormat:@"%@",[info objectForKey:@"UIImagePickerControllerReferenceURL"]];
        
        [self signAndPostToServer:data];
        
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
}

   // 上传头像
-(void)signAndPostToServer:(NSData *) imgdata
{
    
    NSString * token=   [WJGlobalVariable sharedInstance].defaultPerson.token;
    UIDevice *currentDevice = [UIDevice currentDevice];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary: @{}];
    parameters[@"token"]=token;
    parameters[@"appType"] = @"1_2";
    parameters[@"buildModel"] = [NSString stringWithFormat:@"%@", currentDevice.model];
    parameters[@"deviceId"] = [[WJUtilityMethod keyChainValue:NO] stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
    parameters[@"deviceVersion"] = currentDevice.systemVersion;
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    parameters[@"appVersion"] = infoDictionary[@"CFBundleShortVersionString"];
    
    NSString * sign = [WJSignCreateManager createSingByDictionary:parameters];
    parameters[@"sign"] = sign;
    parameters[@"sysVersion"] = [NSString stringWithFormat:@"%@",kSystemVersion];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
    
    [manager POST:[NSString stringWithFormat:@"%@/user/imageUploads",kCBBaseURL]
       parameters:parameters
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

        [formData appendPartWithFileData:imgdata name:@"file" fileName:@"1.png" mimeType:@"image/jpeg"];

        [self.view addSubview:self.hud];
        self.hud.labelText = @"正在上传中...";
        self.hud.mode = MBProgressHUDModeIndeterminate;
        
        [self.hud show:YES];
    
    }
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              NSData *resp = responseObject;
              NSDictionary * dataDic = [NSJSONSerialization JSONObjectWithData:resp options:NSJSONReadingAllowFragments error:nil];
              NSInteger result=[dataDic[@"rspCode"]integerValue];
              
              if (result==0)
              {
                  // [MBProgressHUD dismissWithSuccess:@"保存成功"];
                  self.hud.mode = MBProgressHUDModeText;
                  self.hud.labelText = @"上传成功";
                  
                 
                  WJModelPerson* defaultperson = [WJGlobalVariable sharedInstance].defaultPerson;
                  defaultperson.headImageUrl = dataDic[@"val"][@"url"]?:@"";
                  [[WJDBPersonManager new] updatePerson:defaultperson];
                  
                  NSURL  *url = [NSURL URLWithString:defaultperson.headImageUrl];
                  UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                 
                  UIImage *scaleImg = [self scaleToSize:img size:CGSizeMake(44, 44)];
                  UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                  // 刷新头像
                  UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 70, 40)];
                  UIImageView *imageview1 = [[UIImageView alloc]initWithFrame:CGRectMake(58, 13, 12 , 12)];
                  imageview1.image = [UIImage imageNamed:@"r_icon"];
                  // 头像圆
                  UIImageView *imageview2 =[[UIImageView alloc] initWithFrame:CGRectMake(8, 0, 45, 45)];
                  imageview2.image = scaleImg;
                  
                  imageview2.clipsToBounds = YES;
                  imageview2.layer.cornerRadius =22.5;
                  
                  [view addSubview:imageview2];
                  [view addSubview:imageview1];
                  
                  cell.accessoryView = view;
                  [kDefaultCenter postNotificationName: uploadHead object:@"上传成功"];
                  [kDefaultCenter postNotificationName: @"refreshUploadHeadPortrait" object:nil];

                  NSLog(@"服务器返回的val＝＝%@",dataDic[@"val"]);
                  
              }
              else if (result==1)
              {
                  self.hud.mode=MBProgressHUDModeText;
                  self.hud.labelText=@"网络异常,请稍候再试";
                  [kDefaultCenter postNotificationName: uploadHead object:@"网络异常，请稍候再试"];
              }
              else
              {
                  self.hud.mode=MBProgressHUDModeText;
                  self.hud.labelText=@"请求超时,请不要选择太大的图片";
                  // [MBProgressHUD dismissWithError:@"请求超时" afterDelay:10];
                  [kDefaultCenter postNotificationName: uploadHead object:@"请求超时"];
              }
              
    }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"fail");
              [kDefaultCenter postNotificationName: uploadHead object:@"上传失败"];
    }];
    
}


-(void)handletapPressGesture{
    [self.photoButton removeFromSuperview];
    [self.pictureButton removeFromSuperview];
    [self.photoView removeFromSuperview];
    
    
    self.photoView = nil;
    self.photoButton = nil;
    self.pictureButton = nil;
    
}

#pragma mark private method
- (void)setExtraCellLineHidden: (UITableView *)tableView


{
    
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
    
    
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    
    UIGraphicsBeginImageContext(size);
    
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}



#pragma Action
- (void)addNotification
{
    [kDefaultCenter addObserver:self selector:@selector(uploadHeadImage:) name:uploadHead object:nil];
  
    [kDefaultCenter  addObserver:self selector:@selector(changeNameL) name:@"hasChangedNameNotification" object:nil];
    
    [kDefaultCenter addObserver:self selector:@selector(appHasGoneInForeground)
                           name:UIApplicationWillEnterForegroundNotification
                         object:nil];
    
    [kDefaultCenter addObserver:self selector:@selector(appHasGoneBcakground)
                           name:UIApplicationDidEnterBackgroundNotification
                         object:nil];
    
}


- (void)removeNofitcation
{
    [kDefaultCenter removeObserver:self];
    
}


- (void)uploadHeadImage:(NSNotification *)notification
{
    NSLog(@"[notification object]de1值为＝＝%@",[notification object]);
    // 网络异常，或者成功提示
    NSString * msg =[notification object];
     [[TKAlertCenter defaultCenter] postAlertWithMessage:msg];
    [self uploadOver];
}


- (void)changeNameL{
    [self.tableView reloadData];
}


-(void) uploadOver
{
    // self.hud.labelText=@"上传成功";
    NSLog(@"执行了notificationAction &&&&&&&& uploadover......");
    
    [self.hud removeFromSuperview];
    self.hud=nil;
}


#pragma mark- Private Methods
// TODO:理论上来说，此处不应有私有方法存在，都应该在上面找到归类。这里应该放置拆分的中间方法。
-(void)dateChanged:(id)sender{
    _datePicker= (UIDatePicker*)sender;
    
    NSDate* date = _datePicker.date;
    NSLog(@"-->%@",date);
    /*添加你自己响应代码*/
}

#pragma mark -Action
//-(void)userlogout
//{
//    [self.APIlogout loadData];
//
//    // 删除本地纪录
//    WJModelPerson *person = [WJGlobalVariable sharedInstance].defaultPerson;
//    [person logout];
//    [WJGlobalVariable sharedInstance].defaultPerson = nil;
//    
//    [[NSNotificationCenter defaultCenter]  postNotificationName:@"kQuitAccountNotification" object:nil];
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}



#pragma mark- Getter and Setter
// TODO:所有属性的初始化，都写在这。
-(UITableView* ) tableView
{
    if(nil == _tableView)
    {
        
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
        _tableView.delegate =self;
        _tableView.dataSource =self;
        _tableView.backgroundColor = WJColorViewBg;

        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.tableFooterView = [UIView new];
        
    }
    return _tableView;
}

-(NSArray *)listTop
{
    if (nil==_listTop) {
        _listTop=@[@{@"text":@"头像",@"icon":@"45_default_avatar_bg"}];
    }
    return _listTop;
}


-(NSMutableArray *)listMiddle
{
    _listMiddle = [[NSMutableArray alloc] init];
    WJModelPerson *defaultPerson = [WJGlobalVariable sharedInstance].defaultPerson;

    if(_listMiddle.count == 0)
    {
        
        NSString *listMiddleName = @"";
        if (nil== defaultPerson.realName || [@"" isEqualToString: defaultPerson.realName]) {
        
        }else{
            listMiddleName =  defaultPerson.realName;
        
        }
        // 性别默认为空
        NSString * listMiddleGender =@"";
        
        if (GenderFemale ==defaultPerson.gender) {
            listMiddleGender = @"女";
        }else if(GenderMale ==defaultPerson.gender)
        {
             listMiddleGender = @"男";
        }else{
             listMiddleGender = @"女";
        }
       // NSLog(@"性别默认应为空，现在是%@",listMiddleGender);
        NSString * listMiddleBirthYear = defaultPerson.birthdayYear;
        NSString * listMiddleBirthMonth = defaultPerson.birthdayMonth;
        NSString * listMiddleBirthDay = defaultPerson.birthdayDay;
        //  生日默认为空
        NSString * listMiddleBirth =@"";
        if ([@"" isEqual:defaultPerson.birthdayYear] || nil ==defaultPerson.birthdayYear ||[@"" isEqual:defaultPerson.birthdayMonth] ||nil == defaultPerson.birthdayMonth ||[@"" isEqual:defaultPerson.birthdayDay] || nil ==defaultPerson.birthdayDay || [defaultPerson.birthdayYear intValue]<=0 || [defaultPerson.birthdayMonth intValue]<=0 || [defaultPerson.birthdayDay intValue]<=0) {
            
            listMiddleBirth =@"";
        }else
        {
            listMiddleBirth = [NSString stringWithFormat:@"%@%@%@%@%@",listMiddleBirthYear,@"-",listMiddleBirthMonth,@"-",listMiddleBirthDay];
        }
       
        
       // 省份默认为空
        NSString * listMiddleProvince = @"";
        if ([@"" isEqual:defaultPerson.province] || nil==defaultPerson.province) {
            // 若为空，则一定为默认值
             listMiddleProvince = @"";
        }else{
            
            listMiddleProvince = defaultPerson.province;
        }
        //城市默认为空
        NSString  * listMiddleCity = @"";
        if ([@"" isEqual:defaultPerson.city] ||nil==defaultPerson.city) {
            listMiddleCity = @"";
        }else{
            listMiddleCity = defaultPerson.city;
        }
        //最终呈现的省市
        NSString * listMiddleProvinceCity = nil;
        if ([listMiddleProvince isEqualToString:@""] && [listMiddleCity isEqualToString:@""]) {
            
            listMiddleProvinceCity = @"";
            
        }else{
            listMiddleProvinceCity = [NSString stringWithFormat:@"%@ %@", listMiddleProvince, listMiddleCity];
        }
        
        [_listMiddle addObject:@{@"text":@"真实姓名",@"value":listMiddleName}];
        [_listMiddle addObject:@{@"text":@"性别",@"value":listMiddleGender}];
        [_listMiddle addObject:@{@"text":@"生日",@"value":listMiddleBirth}];
        [_listMiddle addObject:@{@"text":@"所在地",@"value":listMiddleProvinceCity}];
                                 
    }
    return _listMiddle;
}

-(UILabel *)rightLabel
{
    if (nil ==_rightLabel) {
        _rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-125, 1, 90, 40)];
    }
    return _rightLabel;
}

-(NSArray *)listfooter
{
    if(nil==_listfooter)
    {
        _listfooter=@[@{@"text":@"实名认证"}];
    }
    return _listfooter;
}

//-(UIButton *)exitButton
//{
//    if (nil==_exitButton) {
//        _exitButton=[[UIButton alloc]init];
//        _exitButton.frame=CGRectMake(15, kScreenHeight-180, [UIScreen mainScreen].bounds.size.width-30, 40);
//        [_exitButton setTitle:@"退出登录"forState:UIControlStateNormal];
//        _exitButton.layer.cornerRadius=6;
//        
//        _exitButton.titleLabel.font=[UIFont systemFontOfSize:14];
//      
//        [_exitButton setBackgroundColor:[WJUtilityMethod colorWithHexColorString:@"028be6"]];
//        
//        [_exitButton addTarget:self action:@selector(userlogout) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _exitButton;
//}


-(UIView *)photoView
{
    if (nil==_photoView) {
        _photoView=[[UILabel alloc]initWithFrame:self.view.bounds];
        _photoView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5];
        _photoView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handletapPressGesture)];
        [_photoView  addGestureRecognizer:tapGesture];
    }
    return _photoView;
}
-(UIButton *)photoButton
{
    if (nil==_photoButton) {
        _photoButton=[[UIButton alloc]init];
        _photoButton.frame=CGRectMake(60, [UIScreen mainScreen].bounds.size.height/2 -70, [UIScreen mainScreen].bounds.size.width-120, 50);
        [_photoButton setImage:[UIImage imageNamed:@"Camera"] forState:UIControlStateNormal];
        [_photoButton setTitle:@"拍照" forState:UIControlStateNormal];
        _photoButton.backgroundColor=[UIColor orangeColor];
        // _photoButton.backgroundColor=[UIColor colorWithRed:126.0/255 green:126.0/255 blue:126.0/255 alpha:1.0];
        _photoButton.backgroundColor=[[UIColor whiteColor]colorWithAlphaComponent:1.0];
        [_photoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _photoButton.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, kScreenWidth/5);
        _photoButton.contentEdgeInsets=UIEdgeInsetsMake(0, 0, 0, kScreenWidth/7);
        _photoButton.layer.cornerRadius=5;
        [_photoButton addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    }
    return _photoButton;
}
-(UIButton *)pictureButton
{
    if (nil==_pictureButton) {
        _pictureButton=[[UIButton alloc]init];
        _pictureButton.frame=CGRectMake(60, [UIScreen mainScreen].bounds.size.height/2 -110, [UIScreen mainScreen].bounds.size.width-120, 50);
        [_pictureButton setImage:[UIImage imageNamed:@"photo"] forState:UIControlStateNormal];
        [_pictureButton setTitle:@"相册" forState:UIControlStateNormal];
        _pictureButton.backgroundColor=[UIColor greenColor];
        _pictureButton.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, kScreenWidth/5);
        _pictureButton.contentEdgeInsets=UIEdgeInsetsMake(0, 0, 0, kScreenWidth/7);
        //_pictureButton.backgroundColor=[UIColor colorWithRed:226.0/255 green:226.0/255 blue:226.0/255 alpha:1.0];
        _pictureButton.backgroundColor=[[UIColor whiteColor]colorWithAlphaComponent:1.0];
        _pictureButton.layer.cornerRadius=5;
        [_pictureButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [_pictureButton addTarget:self action:@selector(LocalPhoto) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pictureButton;
}
-(UIActionSheet *)sexSheet
{
    if(nil==_sexSheet)
    {
        _sexSheet=[[UIActionSheet alloc]initWithTitle:@"请选择性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle: nil otherButtonTitles:@"女",@"男", nil];
        //性别0，生日1，所在地2
        _sexSheet.tag = 33333;
        _sexSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        //_sexSheet.cancelButtonIndex=0;
        _sexSheet.destructiveButtonIndex = 2;

    }
    return _sexSheet;
}


-(UIActionSheet *)birthSheet
{
    if(nil==_birthSheet)
    {
        _birthSheet=[[UIActionSheet alloc]init];
        [_birthSheet addSubview:self.datePicker];
        
    }
    return _birthSheet;
}


-(UIDatePicker *)datePicker
{
    if (nil==_datePicker) {
        
        _datePicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, kScreenHeight-199.5,kScreenWidth, 199.5)];
        _datePicker.backgroundColor = [UIColor whiteColor];
        _datePicker.datePickerMode = UIDatePickerModeDate;
      
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
        [dateFormater setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *maxDate = [NSDate date];
        NSDate *minDate = [dateFormater dateFromString:@"1949-10-01"];
        
        _datePicker.minimumDate = minDate;
        _datePicker.maximumDate = maxDate;
        
        NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
        _datePicker.locale=locale;
        [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}


-(NSMutableArray *)provinceArray
{
    if (nil==_provinceArray) {
        _provinceArray =[[NSMutableArray alloc]init];
        NSMutableArray * allArray =[[WJDBAreaManager new] getAllAreasByLevel:1];
     
        for (WJModelArea *area in allArray)
        {
           
           [_provinceArray addObject:area];
        }
    }
    
    return _provinceArray;
}


-(NSMutableArray *)cityArray
{
    _cityArray = [[NSMutableArray alloc]init];

    WJModelArea *province = [self.provinceArray objectAtIndex:rowInProvince];
    NSArray *citys = [[WJDBAreaManager new] getSubAreaByParentId:province.areaId];
    
    for (WJModelArea *area in citys)
    {
        [_cityArray addObject:area];
    }

    return _cityArray;
}


-(UIPickerView *)pickerView
{
    if(nil == _pickerView)
    {
        _pickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(0, kScreenHeight-199.5,kScreenWidth, 199.5)];
        _pickerView.backgroundColor=[UIColor whiteColor];
        _pickerView.delegate =self;
        _pickerView.dataSource=self;
        _pickerView.showsSelectionIndicator = YES;
    
    }
    return _pickerView;
}


//-(APIUserLogoutManager *)APIlogout
//{
//    if (nil == _APIlogout) {
//        
//        _APIlogout = [[APIUserLogoutManager alloc]init];
//        _APIlogout.delegate = self;
//    }
//    return _APIlogout;
//}


-(MBProgressHUD *)hud{
    if (nil==_hud) {
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
    }
    return _hud;
}


- (NSMutableArray *)dataArray
{
    if (nil == _dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


-(APIUserUpdateManager *)updateManager
{
    
    if (nil==_updateManager) {
        _updateManager = [[APIUserUpdateManager  alloc]init];
        _updateManager.delegate=self;
        
        
    }
    return _updateManager;
}


@end
