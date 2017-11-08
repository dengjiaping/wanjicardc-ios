//
//  WJAboutUsViewController.m
//  WanJiCard
//
//  Created by wangzhangjie on 15/9/16.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJAboutUsViewController.h"
#import "WJCompanyDelegateViewController.h"
#import "WJCreditEggsController.h"
#import "WJAlertView.h"
#import <StoreKit/StoreKit.h>


@interface WJAboutUsViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,SKStoreProductViewControllerDelegate,WJAlertViewDelegate>

@end

@implementation WJAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.versionLabel];
    [self.view addSubview:self.descriptionTopLabel];
    [self.view addSubview:self.descriptionBottomLabel];
    self.navigationItem.title=@"关于万集卡";
    self.eventID = @"iOS_act_paboutus";
    
}


#pragma mark- skstore delege

- (void)showStoreProductInApp:(NSString *)appID{
    
    Class isAllow = NSClassFromString(@"SKStoreProductViewController");
    
    if (isAllow != nil) {
        
        SKStoreProductViewController *sKStoreProductViewController = [[SKStoreProductViewController alloc] init];
        // [sKStoreProductViewController.view setFrame:CGRectMake(0, 200, 320, 200)];
        [sKStoreProductViewController setDelegate:self];
        [sKStoreProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier: appID}
                                                completionBlock:^(BOOL result, NSError *error) {
                                                    if (nil==error) {
                                                        [self presentViewController:sKStoreProductViewController
                                                                           animated:YES
                                                                         completion:nil];
                                                      //  [self removeNotice];
                                                        
                                                    }else{
                                                        NSLog(@"======error:%@",error);
                                                        // 网络异常
                                                    }
                                                }];
    }
}


//取消按钮监听
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- UITableViewDelegate & UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (nil==cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellWithIdentifier];
        //UITableViewCellStyleValue1
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        [cell.textLabel setTextColor:WJColorDardGray3];
    }
    //  去评分，关于我们，帮助
    
    NSDictionary * dic = [self.listArray  objectAtIndex:indexPath.row];
    // cell.imageView.image = [UIImage imageNamed:dic[@"icon"]];
    // cell.accessoryView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:dic[@"icon"] ]];
    cell.textLabel.text = dic[@"text"];
    if(indexPath.row==1)
    {
        cell.accessoryView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:dic[@"icon"] ]];
    }
    return cell;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section==0)
//    {
//        //if (indexPath.row==0) {
//        
//        return ALD(94);
//        // }
//    }
//    else if(indexPath.section==1)
//    {
//        return ALD(45);
//    }
//    else
//    {
//        return ALD(45);
//    }
//}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            

            if (0==indexPath.row) {
                //去评分
                [self showStoreProductInApp:@"1021840697"];

            }else if (1==indexPath.row){
                
                //联系客服
                WJAlertView *alert = [[WJAlertView alloc]initWithTitle:nil message:@"拨打400-872-2002?" delegate:self cancelButtonTitle:@"取消"  otherButtonTitles:@"确定" textAlignment:NSTextAlignmentCenter];
                
                [alert showIn];
                
            }else {
                //万集卡协议
                WJCompanyDelegateViewController *companyVC= [[WJCompanyDelegateViewController alloc]init];
                [self.navigationController pushViewController:companyVC animated:YES];
            }
        }
            break;
            

    }
}
#pragma mark - alter -delegate
- (void)wjAlertView:(WJAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1==buttonIndex) {
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4008722002"]];
       
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)appNameLabelFiveTap {
    WJCreditEggsController *viewController = [[WJCreditEggsController alloc] init];
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark setter,getter
-(UIImageView *)imageView
{
    if (nil==_imageView) {
        _imageView = [[UIImageView alloc]init];
        if (kScreenHeight == 480) {
            _imageView.frame = CGRectMake(kScreenWidth/2-45, 40, 90  ,120);
        }else
        {
            _imageView.frame = CGRectMake(kScreenWidth/2-45, 80, 90  ,120);
        }
        _imageView.image=[UIImage imageNamed:@"aboutlogo"];
        _imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer* fiveRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(appNameLabelFiveTap)];
        fiveRecognizer.numberOfTapsRequired = 10;
        [_imageView addGestureRecognizer:fiveRecognizer];
        
    }
    return _imageView;
}
-(UITableView *)tableView
{
    if (nil==_tableView) {
//        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 240, [UIScreen mainScreen].bounds.size.width, 132) style:UITableViewStylePlain];
         if (kScreenHeight<=480) {
             // 适配4s
             _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 180, [UIScreen mainScreen].bounds.size.width, 132) style:UITableViewStylePlain];
         }else
         {
            _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 240, [UIScreen mainScreen].bounds.size.width, 132) style:UITableViewStylePlain];
         }
        _tableView.delegate =self;
        _tableView.dataSource =self;
        _tableView.bounces = NO;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.tableFooterView = [UIView new];
    }
    return  _tableView;
}
-(NSArray *)listArray
{
    if(nil==_listArray)
    {
        _listArray=@[@{@"icon":@"personal_invitation_icon",@"text":@"去评分"},
                          @{@"icon":@"details_call_icon",@"text":@"联系客服"},
                     @{@"icon":@"personal_settings_icon",@"text":@"万集卡协议"}];
    }
    return _listArray;
}

-(UILabel *)descriptionTopLabel
{
    if (nil ==_descriptionTopLabel) {
        _descriptionTopLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, kScreenHeight-120, kScreenWidth-70, 20)];
        
        _descriptionTopLabel.text=@"©2005-2016万集融合信息技术(北京)有限公司 版权所有";
        _descriptionTopLabel.textColor = WJColorDardGray9;
        _descriptionTopLabel.font = [UIFont systemFontOfSize:10];
        _descriptionTopLabel.textAlignment = NSTextAlignmentCenter;
      
    }
    return _descriptionTopLabel;
}
-(UILabel *)descriptionBottomLabel
{
    if (nil ==_descriptionBottomLabel) {
        _descriptionBottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, kScreenHeight-100, kScreenWidth-140, 20)];
        _descriptionBottomLabel.text=@"京公网安11010802016306";
        _descriptionBottomLabel.textColor = WJColorDardGray9;
        _descriptionBottomLabel.font = [UIFont systemFontOfSize:10];
        
         _descriptionBottomLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _descriptionBottomLabel;
}
-(UILabel *)versionLabel
{
    if (nil ==_versionLabel) {
        _versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, kScreenHeight-150, kScreenWidth-20, 30)];
        // 获取当前系统的版本号
        NSString *envirement = @"";
#if TestAPI
      envirement = @"/测试接口";
#endif
        
#if DEBUG
        envirement = [envirement stringByAppendingString:@"-Debug"];
#endif
        
        _versionLabel.text = [NSString stringWithFormat:@"版本号：%@%@",[WJUtilityMethod versionNumber], envirement];
        _versionLabel.textColor = WJColorDardGray9;
        _versionLabel.numberOfLines = 0;
        _versionLabel.font = [UIFont systemFontOfSize:14];
        
        _versionLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _versionLabel;
}
@end
