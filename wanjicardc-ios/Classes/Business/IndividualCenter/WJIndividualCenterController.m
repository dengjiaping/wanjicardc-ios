//
//  WJIndividualCenterController.m
//  WanJiCard
//  个人中心
//  Created by Harry Hu on 15/8/28.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJIndividualCenterController.h"
#import "WJIndividualViewController.h"
#import "WJPaySettingController.h"
#import "WJMyOrderController.h"
#import "WJOwnedCardListController.h"

#import "WJSettingViewController.h"
#import "UIImageView+WebCache.h"
#import "WJShareFriendViewController.h"
#import "WJPurchaseHistoryController.h"

#import "APIUserDetailManager.h"

#import "WJMyTicketTableViewCell.h"
#import "WJMyTicketViewController.h"
#import "APIUserUpdateManager.h"
#import "WJIndividualNameReformer.h"
#import "APIUserDetailManager.h"
#import "WJMyConsumerController.h"
@interface WJIndividualCenterController ()<UITableViewDataSource,UITableViewDelegate,APIManagerCallBackDelegate>

@property(strong,nonatomic) UITableView * tableView;
@property(nonatomic,strong) NSArray *listdataTop;
@property(nonatomic,strong) NSArray *listdataMiddle;
@property(nonatomic,strong) NSArray *listdataFooter;

@property(strong,nonatomic) APIUserUpdateManager    *updateManager;


@end


@implementation WJIndividualCenterController

#pragma mark- Life cycle


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self hiddenBackBarButtonItem];
    
    self.view.backgroundColor = WJColorViewBg;
    self.title = @"个人中心";
    self.eventID = @"iOS_act_personcenter";
    
    [self navigationSetup];
    
    APIUserDetailManager *userD = [[APIUserDetailManager alloc] init];
    userD.delegate = self;
    [userD loadData];

    
    [self.view addSubview:self.tableView];
}


- (void)navigationSetup
{
   
    UIButton * settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingButton setFrame:CGRectMake(0, 0, 22, 22)];
    [settingButton setImage:[UIImage imageNamed:@"personal_settings_icon"] forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(gotoSetting) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * settingItem = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    self.navigationItem.leftBarButtonItem = settingItem;
    
    UIButton * messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [messageButton setFrame:CGRectMake(0, 0, 22, 22)];
    [messageButton setBackgroundColor:[UIColor redColor]];
    [messageButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(gotoMessage) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * messageItem = [[UIBarButtonItem alloc] initWithCustomView:messageButton];
    self.navigationItem.rightBarButtonItem = messageItem;
   
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
        
        UIImageView *iv = [[UIImageView alloc] initForAutoLayout];
        iv.layer.cornerRadius = 32;
        iv.layer.masksToBounds = YES;
        iv.tag = 500;
        [cell.contentView addSubview:iv];
        [cell.contentView addConstraints:[iv constraintsSize:CGSizeMake(64, 64)]];
        [cell.contentView addConstraints:[iv constraintsLeftInContainer:10]];
        [cell.contentView addConstraint:[iv constraintCenterYEqualToView:cell.contentView]];
        
        UILabel *nameL = [[UILabel alloc] initForAutoLayout];
        nameL.textColor = WJColorDardGray3;
        nameL.font = WJFont14;
        nameL.tag = 501;
        [cell.contentView addSubview:nameL];
        [cell.contentView addConstraints:[nameL constraintsSize:CGSizeMake(200, 64)]];
        [cell.contentView addConstraints:[nameL constraintsLeft:10 FromView:iv]];
        [cell.contentView addConstraint:[nameL constraintCenterYEqualToView:cell.contentView]];
        
        //小圆点
        UIImageView *smallCircle = [[UIImageView alloc] initForAutoLayout];
        smallCircle.layer.cornerRadius = 4;
        smallCircle.layer.masksToBounds = YES;
        smallCircle.hidden = YES;
        smallCircle.backgroundColor = [UIColor redColor];
        smallCircle.tag = 502;
        [cell.contentView addSubview:smallCircle];
        [cell.contentView addConstraints:[smallCircle constraintsSize:CGSizeMake(8, 8)]];
        [cell.contentView addConstraints:[smallCircle constraintsRightInContainer:0                                                                                                                                                                                                            ]];
        [cell.contentView addConstraint:[smallCircle constraintCenterYEqualToView:cell.contentView]];
    }
    
    UIImageView *iv = (UIImageView *)[cell.contentView viewWithTag:500];
    UILabel *nameL = (UILabel *)[cell.contentView viewWithTag:501];
    UIImageView *smallCircle = (UIImageView *)[cell.contentView viewWithTag:502];
    
    nameL.hidden = iv.hidden = (0 != indexPath.section + indexPath.row);
    iv.image = nil;
    nameL.text = @"";
    smallCircle.hidden = YES;
    
    //  头像，电话号
    if(0 ==indexPath.section)
    {
        
        if(0==indexPath.row)
        {
            WJModelPerson *defaultPerson3 = [WJDBPersonManager getDefaultPerson];
            
            NSURL  *url = [NSURL URLWithString: defaultPerson3.headImageUrl];
            
            [iv sd_setImageWithURL:url
                  placeholderImage:[UIImage imageNamed:@"default_avatar_bg"]];

            nameL.text =  defaultPerson3.phone;
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@""]]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.imageView.image = img;
                });
            });
            
        }
    }
    else if (1==indexPath.section)
    {
        //  我的订单，消费记录，支付设置等等
        NSDictionary * dic = [self.listdataMiddle  objectAtIndex:indexPath.row];
        cell.imageView.image = [UIImage imageNamed:dic[@"icon"]];
        cell.textLabel.text = dic[@"text"];
        
        WJModelPerson *defaultPerson = [WJDBPersonManager getDefaultPerson];
       
        if (indexPath.row == 3) {
            if(defaultPerson.isSetPsdQuestion){
                smallCircle.hidden = YES;
            }else{
                smallCircle.hidden = NO;
            }
           
        }
        
    }
    else
    {
        //  邀请好友，设置
        NSDictionary * dic = [self.listdataFooter  objectAtIndex:indexPath.row];
        cell.imageView.image = [UIImage imageNamed:dic[@"icon"]];
        cell.textLabel.text = dic[@"text"];
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return ALD(94);
    }
    
//    return ALD(45);
    return MAX(ALD(45), 44);
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // NSLog(@"numberOfRowsInSection %d", section);
    if (0 == section)
    {
        // 第0组有多少行
        return 1;
    }else if (1 == section) {
        return 6;
    }
    else if(2==section){
        // 第2组有多少行
        return 1;
    }else{
        return 0;
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
    switch (indexPath.section) {
        case 0:{
            WJIndividualViewController *selfinfo=[[WJIndividualViewController alloc] init];
            NSLog(@"%@", [NSDate date]);

            [self.navigationController pushViewController:selfinfo animated:YES];
        }
            break;
            
        case 1:{
            switch (indexPath.row) {
                case 0:{
                    //我的订单
                    WJMyOrderController *vc = [[WJMyOrderController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 1:{
                    // 消费记录
//                    WJPurchaseHistoryController *vc = [WJPurchaseHistoryController new];
//                    [self.navigationController pushViewController:vc animated:YES];
                    
                    WJMyConsumerController *vc = [WJMyConsumerController new];
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }
                    break;
                case 2:{
                    // 卡包充值
                    WJOwnedCardListController *vc = [WJOwnedCardListController new];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 3:{
                    // 安全设置
                    WJPaySettingController *dvc = [[WJPaySettingController alloc] init];
                    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadData) name:@"safetyQuestion" object:nil];
                    [self.navigationController pushViewController:dvc animated:YES];
                }
                    break;
                case 4:{
                    // 我的优惠券
                    WJMyTicketViewController *ticketVC = [[WJMyTicketViewController alloc]init];
                    [self.navigationController pushViewController:ticketVC animated:YES];
                }
                    break;
                case 5:{
                    // 邀请好友
                    WJShareFriendViewController *shareVC =[[WJShareFriendViewController alloc]init];
                    [self.navigationController pushViewController:shareVC animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        case 2:{
            //设置
            WJSettingViewController * settingVC =[[WJSettingViewController alloc]init];
            [self.navigationController pushViewController:settingVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)reloadData
{
    [self.tableView reloadData];
}


#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    if ([manager isKindOfClass:[APIUserDetailManager class]]) {
       
        NSDictionary *dic = [manager fetchDataWithReformer:nil];
        
        WJModelPerson *person = [WJDBPersonManager getDefaultPerson];
        [person updateWithDic:dic];

        if (person) {
            BOOL su = [[WJDBPersonManager new] updatePerson:person];
            if (su) {
                [self.tableView reloadData];
            }
        }
    }
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    NSLog(@"fail:%s",__func__);
    NSLog(@"fail:%@",manager.errorMessage);
    // response［@“msg”］
    //  [[TKAlertCenter defaultCenter]  postAlertWithMessage:@"系统异常，请稍后再试"];
}


#pragma mark- Getter and Setter
// TODO:所有属性的初始化，都写在这。
-(UITableView* ) tableView
{
    if(nil == _tableView)
    {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.backgroundColor = WJColorViewBg;
        _tableView.tableFooterView = [UIView new];

    }
    return _tableView;
}


-(NSArray *)listdataTop
{
    if(nil == _listdataTop)
    {
        _listdataTop=@[@{@"icon":@"business_beauty",@"text":@"18813050615"}];
    }
    return _listdataTop;
}


-(NSArray *)listdataMiddle
{
    if(nil==_listdataMiddle)
    {
        _listdataMiddle=@[@{@"icon":@"personal_order_icon",@"text":@"我的订单"},
                          @{@"icon":@"personal_records_icon",@"text":@"消费记录"},
                          @{@"icon":@"personal_package_icon",@"text":@"卡包充值"},
                          @{@"icon":@"personal_pay_icon",@"text":@"安全设置"},
                          @{@"icon":@"personal_coupons_icon",@"text":@"我的优惠券"},
                          @{@"icon":@"personal_invitation_icon",@"text":@"邀请好友"}
                          ];
    }
    return _listdataMiddle;
}


-(NSArray *)listdataFooter
{
    if(nil==_listdataFooter)
    {
        _listdataFooter=@[
                          @{@"icon":@"personal_settings_icon",@"text":@"设置"}];
    }
    return _listdataFooter;
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
