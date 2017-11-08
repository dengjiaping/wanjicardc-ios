//
//  WJOrderDetailViewController.m
//  WanJiCard
//
//  Created by 林有亮 on 16/11/14.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJOrderDetailViewController.h"
#import "WJOrderEcardTableViewCell.h"
#import "WJECardDetailModel.h"
#import "APIGenECardOrderManager.h"
#import "WJBaoziPayCompleteController.h"
#import "APIBuyECardManager.h"
#import "WJPassView.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <Pingpp/Pingpp.h>
#import "libPayecoPayPlugin.h"
#import "WJSystemAlertView.h"
#import "WJBaoziOrderConfirmController.h"
#import "WJAppealViewController.h"
#import "WJFindRealNameAuthenticationViewController.h"
#import "WJFindSafetyQuestionController.h"

@interface WJOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,WJPassViewDelegate,WJSystemAlertViewDelegate,UIActionSheetDelegate,PayEcoPpiDelegate>
{
    NSString * orderNo;
    NSString * totolBaoziNum;
}
@property (nonatomic, strong) UITableView   * tableView;
@property (nonatomic, strong) NSArray       * headerArray;
@property (nonatomic, strong) NSArray       * payArray;
@property (nonatomic, strong) UILabel       * countValueLabel;
@property (nonatomic, strong) UIButton      * payButton;
@property (nonatomic, assign) NSInteger     selectPayAwayIndex;
@property (nonatomic, assign) CGFloat       value;
@property (nonatomic, strong) APIGenECardOrderManager * genECardManager;
@property (nonatomic, strong) APIBuyECardManager    * buyECardManager;


@end

@implementation WJOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI
{
    
    [self navigationSetup];
    
    [self.view addSubview:self.tableView];
    self.value = [self.eCardModel.salePriceRmb floatValue] - [self.eCardModel.salePrice floatValue];
    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - ALD(48) - 64, kScreenWidth, ALD(48))];
    bottomView.backgroundColor = WJColorWhite;
    
    UILabel * oneLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), ALD(0), 22, ALD(48))];
    oneLabel.text = @"合计";
    oneLabel.font = [UIFont systemFontOfSize:14];
    oneLabel.textColor = [WJUtilityMethod colorWithHexColorString:@"2f333b"];
    [oneLabel sizeToFit];
    [oneLabel setFrame:CGRectMake(ALD(12), 0, oneLabel.width, ALD(44))];
    
    self.countValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(oneLabel.frame) + ALD(10), 0, ALD(120), ALD(48))];
    self.countValueLabel.font = [UIFont systemFontOfSize:14];
    [self valueAction];
    
    self.payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.payButton setFrame:CGRectMake(kScreenWidth - ALD(112), ALD(7), ALD(100), ALD(35))];
    [self.payButton setTitle:@"立即支付" forState:UIControlStateNormal];
    [self.payButton setBackgroundColor:[WJUtilityMethod colorWithHexColorString:@"31b0ef"]];
    self.payButton.layer.cornerRadius = 5;
    [self.payButton setTitleColor:WJColorWhite forState:UIControlStateNormal];
    [self.payButton addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomView addSubview:oneLabel];
    [bottomView addSubview:self.countValueLabel];
    [bottomView addSubview:self.payButton];
    
    [self.view addSubview:bottomView];
    
}

- (void)navigationSetup
{
    self.title = @"确认订单";
}


- (void)payAction
{
     CGFloat num = self.orderNum;
     if (num > MIN([self.eCardModel.stock floatValue], 200))
     {
     // 库存不足
     //清重新选择购买数量
         if (num > [self.eCardModel.stock integerValue])
         {
         [[TKAlertCenter defaultCenter] postAlertWithMessage:@"库存不足"];
         }
         else if (num > 200) {
         [[TKAlertCenter defaultCenter] postAlertWithMessage:@"购买数量不能超过200"];
         }
     
     //非活动电子卡
     } else {
         
         if (self.eCardModel.activityType != 0) {
             //活动电子卡
             if (num > self.eCardModel.limitCount) {
                 
                 [[TKAlertCenter defaultCenter] postAlertWithMessage:[NSString stringWithFormat:@"您每天最多可以购买%ld张限购商品",(long)self.eCardModel.allowBuyCount]];
                 
             } else {
                 
                 if (num > self.eCardModel.allowBuyCount) {
                     [[TKAlertCenter defaultCenter] postAlertWithMessage:[NSString stringWithFormat:@"您还可以购买%ld张限购商品",(long)self.eCardModel.allowBuyCount]];
                     
                 } else {
                     
                     self.genECardManager.eCardID = self.eCardModel.cardId;
                     self.genECardManager.buyNumber = num;
                     self.genECardManager.channelId = [[self.payArray objectAtIndex:self.selectPayAwayIndex] objectForKey:@"away"];
                     
                     //     buyNumber = num;
                     [self.genECardManager loadData];
                     self.payButton.enabled = NO;
                 }
             }
         }
         else
         {
             self.genECardManager.eCardID = self.eCardModel.cardId;
             self.genECardManager.buyNumber = num;
             //     buyNumber = num;
             self.genECardManager.channelId = [[self.payArray objectAtIndex:self.selectPayAwayIndex] objectForKey:@"away"];
             [self.genECardManager loadData];
             self.payButton.enabled = NO;
         }
     
     }

}

- (void)valueAction
{
    NSString * str = @"";
    if(self.selectPayAwayIndex == 2 )
    {
        str = [NSString stringWithFormat:@"%.2f个包子",[self.eCardModel.salePrice floatValue] * self.orderNum];
        self.countValueLabel.textColor = [WJUtilityMethod colorWithHexColorString:@"d9a109"];
    }else
    {
        str = [NSString stringWithFormat:@"￥ %.2f",[self.eCardModel.salePriceRmb floatValue] * self.orderNum];
        self.countValueLabel.textColor = [WJUtilityMethod colorWithHexColorString:@"f02b2b"];
    }
    
    self.countValueLabel.text = str;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 1;
        }
            break;
        case 1:
        {
            return 0;
        }
            break;
        case 2:
        {
            return 3;
        }
            break;
        case 3:
        {
            return 1;
        }
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            return ALD(91);
        }
            break;
        case 1:
        {
            return 0;
        }
            break;
        case 2:
        {
            return ALD(44);
        }
            break;
        case 3:
        {
            if (self.selectPayAwayIndex == 2 && self.value > 0) {
                return ALD(80);
            }
            return ALD(60);
        }
            break;
        default:
            break;
    }
    return 0;}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            WJOrderEcardTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
            if (!cell) {
                cell = [[WJOrderEcardTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            [cell refreshWithModel:self.eCardModel];
            
            return cell;
        }
            break;
        case 1:
        {
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
            }
            return cell;
        }
            break;
        case 2:
        {
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

                UIImageView * logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(12), ALD(11), ALD(22), ALD(22))];
                logoImageView.tag = 10000 + indexPath.row;
                UILabel     * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(logoImageView.frame) + ALD(11), ALD(11), ALD(11), ALD(22))];
                nameLabel.tag = 11000 + indexPath.row;
                UILabel     * desLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(3), ALD(11), ALD(5), ALD(11))];
                desLabel.tag = 12000 + indexPath.row;
                desLabel.font = [UIFont systemFontOfSize:11];
                desLabel.textColor = [WJUtilityMethod colorWithHexColorString:@"f02b2b"];
                
                UIImageView * selectIV = [[UIImageView alloc] init];
                [selectIV setFrame:CGRectMake(kScreenWidth - ALD(12) - ALD(7), ALD(15), ALD(13), ALD(13))];
                selectIV.tag = 13000 + indexPath.row;
                
                [cell.contentView addSubview:logoImageView];
                [cell.contentView addSubview:nameLabel];
                [cell.contentView addSubview:desLabel];
                [cell.contentView addSubview:selectIV];
            }
            
            UIImageView * logoIV = (UIImageView *) [cell.contentView viewWithTag:10000 + indexPath.row];
            UILabel     * nameL = (UILabel  *)[cell.contentView viewWithTag:11000 + indexPath.row];
            UILabel     * desL = (UILabel *)[cell.contentView viewWithTag:12000 + indexPath.row];
            UIImageView * selIV = (UIImageView *)[cell.contentView viewWithTag:13000 + indexPath.row];
            
            logoIV.image = [UIImage imageNamed:[[self.payArray objectAtIndex:indexPath.row] objectForKey:@"image"]];
            nameL.text = [[self.payArray objectAtIndex:indexPath.row] objectForKey:@"text"];
            [nameL sizeToFit];
            [nameL setFrame:CGRectMake(nameL.x, nameL.y, nameL.width, ALD(22))];
            
//            selIV.highlighted = (self.selectPayAwayIndex == indexPath.row);
            if (self.selectPayAwayIndex == indexPath.row) {
                selIV.image = [UIImage imageNamed:@"toggle_button_selected"];
            }else
            {
                selIV.image = [UIImage imageNamed:@"toggle_button_nor"];
            }
            
            if (indexPath.row == 2) {
                desL.hidden = NO;
                if (self.value <= 0) {
                    desL.hidden = YES;
                    return cell;
                }
                [desL setText:[NSString stringWithFormat:@"立减%.2f个包子（1元 = 1个包子）",self.value]];
                [desL sizeToFit];
                [desL setFrame:CGRectMake(CGRectGetMaxX(nameL.frame) + ALD(5), nameL.y + ALD(22) - desL.height, desL.width, desL.height)];
            } else
            {
                desL.hidden = YES;
            }

            
            return cell;
        }
            break;
        case 3:
        {
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

                UILabel * goodLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), ALD(11), ALD(100), ALD(20))];
                goodLabel.text = @"商品价格";
                goodLabel.font = [UIFont systemFontOfSize:12];
                goodLabel.textColor = [WJUtilityMethod colorWithHexColorString:@"2f333b"];
                
                UILabel * numLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), ALD(31), ALD(100), ALD(20))];
                numLabel.text = @"数量";
                numLabel.font = [UIFont systemFontOfSize:12];
                goodLabel.textColor = [WJUtilityMethod colorWithHexColorString:@"2f333b"];
                
                UILabel * favourableLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), ALD(51), ALD(100), ALD(20))];
                favourableLabel.text = @"优惠";
                favourableLabel.font = [UIFont systemFontOfSize:12];
                favourableLabel.textColor = [WJUtilityMethod colorWithHexColorString:@"2f333b"];
                favourableLabel.tag = 19999;
                
                UILabel *  priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(150), ALD(11), kScreenWidth - ALD(167), ALD(20))];
                priceLabel.tag = 20000;
                priceLabel.textAlignment = NSTextAlignmentRight;
                priceLabel.font = [UIFont systemFontOfSize:12];
                priceLabel.textColor = [WJUtilityMethod colorWithHexColorString:@"2f333b"];
                
                UILabel * numValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(150), ALD(31), kScreenWidth - ALD(167), ALD(20))];
                numValueLabel.tag = 20001;
                numValueLabel.textAlignment = NSTextAlignmentRight;
                numValueLabel.font = [UIFont systemFontOfSize:12];
                numValueLabel.textColor = [WJUtilityMethod colorWithHexColorString:@"2f333b"];
                
                UILabel * favourValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(150), ALD(51), kScreenWidth - ALD(167), ALD(20))];
                favourValueLabel.tag = 20002;
                favourValueLabel.textAlignment = NSTextAlignmentRight;
                favourValueLabel.font = [UIFont systemFontOfSize:12];
                favourValueLabel.textColor = [WJUtilityMethod colorWithHexColorString:@"2f333b"];
                
                [cell.contentView addSubview:goodLabel];
                [cell.contentView addSubview:numLabel];
                [cell.contentView addSubview:favourableLabel];
                [cell.contentView addSubview:priceLabel];
                [cell.contentView addSubview:numValueLabel];
                [cell.contentView addSubview:favourValueLabel];
            }
            
            UILabel * priceLabel = (UILabel *)[cell.contentView viewWithTag:20000];
            
            if (self.selectPayAwayIndex == 2) {
                
                if([self.eCardModel.salePrice integerValue] == [self.eCardModel.salePrice floatValue])
                {
                    self.eCardModel.salePrice = [NSString stringWithFormat:@"%ld",[self.eCardModel.salePrice integerValue]];
                }
                
                priceLabel.text = [NSString stringWithFormat:@"%@个包子",self.eCardModel.salePrice];
            }else
            {
                priceLabel.text = [NSString stringWithFormat:@"￥ %@",self.eCardModel.salePriceRmb];
            }
            
            UILabel * numValueLabel = (UILabel *)[cell.contentView viewWithTag:20001];
            numValueLabel.text = [NSString stringWithFormat:@"x %d",(int)self.orderNum];
            
            UILabel * favourValueLabel = (UILabel *)[cell.contentView viewWithTag:20002];
            UILabel * favLabel = (UILabel *)[cell.contentView viewWithTag:19999];
//            if (self.value > 0) {
                favourValueLabel.text = [NSString stringWithFormat:@"-%.2f个包子",self.value];
//            } else
//            {
//                favourValueLabel.text = [NSString stringWithFormat:@"0"];
//            }
//            
            if(self.selectPayAwayIndex == 2 && self.value > 0)
            {
                favourValueLabel.hidden = NO;
                favLabel.hidden = NO;
            } else
            {
                favourValueLabel.hidden = YES;
                favLabel.hidden = YES;
            }
            
            
            return cell;
        }
            break;
        default:
            break;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        self.selectPayAwayIndex = indexPath.row;
        [self valueAction];
        [self.tableView reloadData];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(44) + 10)];
    headerView.backgroundColor = WJColorCardGray;
    headerView.layer.borderColor = [WJColorCardGray CGColor];
    headerView.layer.borderWidth = 1;
    
    UILabel * textLable = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), 0, ALD(200), ALD(44))];
    textLable.text = [self.headerArray objectAtIndex:section];
    textLable.font = [UIFont systemFontOfSize:15];
    textLable.textColor = [WJUtilityMethod colorWithHexColorString:@"333333"];
    textLable.textColor = [WJUtilityMethod colorWithHexColorString:@"2f333b"];
    textLable.font = WJFont14;
    headerView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:textLable];
    
    if (section == 1) {
        UILabel * cardCateLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(150), ALD(0), kScreenWidth - ALD(162), ALD(44))];
        cardCateLabel.text = @"电子卡";
        cardCateLabel.textColor = [WJUtilityMethod colorWithHexColorString:@"2f333b"];
        cardCateLabel.font = WJFont14;
        cardCateLabel.textAlignment = NSTextAlignmentRight;
        [headerView addSubview:cardCateLabel];
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ALD(44);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    CGFloat height = ALD(15);
    
    if (section == 3) {
        height = 0;
    }
    
    UIView * aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height)];
    aView.backgroundColor = [UIColor clearColor];
    
    return aView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat height = ALD(15);

    if (section == 3) {
        height = 0;
    }
    
    return height;
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    if ([manager isKindOfClass:[APIGenECardOrderManager class]]) {
        
        [self hiddenLoadingView];

        NSDictionary * dic = [manager fetchDataWithReformer:nil];
        NSLog(@"%@",dic);
        //        orderNo = 101716082900016;
        orderNo = dic[@"orderNo"];
        self.buyECardManager.orderNo = orderNo;
        
        switch (self.selectPayAwayIndex) {
            case 0:
            case 1:
            {
//                dic[@"charge"];
                
                [self goToPay:dic[@"charge"]];
                
            }
                break;
            case 2:
            {
                totolBaoziNum = [NSString stringWithFormat:@"%@",dic[@"totalBunNum"]];
                [self checkAlertWithBaoziNum:totolBaoziNum];

            }
                break;
            default:
                break;
        }
        self.payButton.enabled = YES;
        
    } else if ([manager isKindOfClass:[APIBuyECardManager class]]) {
        NSLog(@"%@",@"购买成功");
        
        [self hiddenLoadingView];
        UIWindow *window = [[UIApplication sharedApplication].delegate window];
        WJPassView *alert = (WJPassView *)[window viewWithTag:100005];
        if (alert) {
            [alert dismiss];
        }
        
         //进入交易结果页
        [WJGlobalVariable sharedInstance].payfromController = self;

        [self paySuccessToResultViewController];
        
        orderNo = @"";
        self.orderNum = 0;
    }
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
   if ([manager isKindOfClass:[APIGenECardOrderManager class]]) {
        NSLog(@"%@",manager.errorMessage);
        if (manager.errorMessage.length > 0)
        {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:manager.errorMessage];
        }
        self.payButton.enabled = YES;
    } else if ([manager isKindOfClass:[APIBuyECardManager class]]) {
        self.payButton.enabled = YES;
        //        NSDictionary * dic = [manager fetchDataWithReformer:nil];
        WJSystemAlertView *sysAlert = [[WJSystemAlertView alloc] initWithTitle:@"支付失败" message:@"支付遇到问题，您可以到我的订单页面查看订单详情" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil textAlignment:NSTextAlignmentCenter];
        [sysAlert showIn];
    }
}


#pragma mark - WJSystemAlertViewDelegate
- (void)wjAlertView:(WJSystemAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //取消
    if (buttonIndex == 0) {
        [alertView dismiss];
//        isShowPassView = NO;
    }else{
        
        if ([alertView.title isEqualToString:@"验证失败"]) {
            //再试一次
            [self checkAlertWithBaoziNum:totolBaoziNum];
        }else if ([alertView.title isEqualToString:@"账号已被锁定"]) {
            
            [alertView dismiss];
//            isShowPassView = NO;
            [self findPassword];
        }
    }
}



- (void)goToPay:(NSString*)charge
{
    //易联支付
    if ([self.genECardManager.channelId isEqualToString:@"payeco"]) {
        
        [self performSelectorOnMainThread:@selector(goNext:) withObject:charge waitUntilDone:NO];
        
        return;
    }
    
    //支付宝支付
    [self hiddenLoadingView];
    __weak typeof(self) weakSelf = self;
    [Pingpp createPayment:charge
           viewController:weakSelf
             appURLScheme:KAppURLScheme
           withCompletion:^(NSString *result, PingppError *error) {
               if ([result isEqualToString:@"success"]) {
                   
                   [weakSelf updateOrderStatus:OrderStatusSuccess];
                   [kDefaultCenter postNotificationName:kPayOrderSuccess object:nil];
                   
                   [WJGlobalVariable sharedInstance].payfromController = weakSelf;
                   
                   // 支付成功
                   [weakSelf paySuccessToResultViewController];
                   
               } else {
                   if (error.code == PingppErrCancelled) {
                       ALERT(@"已取消付款操作，交易失败！");
                   }else{
                       ALERT(@"交易失败");
                   }
                   [self.navigationController popViewControllerAnimated:YES];
               }
           }];
}

#pragma mark 易联支付

/*
 *  下单成功，开始调用易联支付插件进行支付
 */
- (void)goNext:(NSString *)orderData{
    
    //orderData为商户下单返回的数据，将下单返回的数据转换成json字符串
    //    NSString *reqJson = [self toJsonStringWithJsonObject:orderData];
    NSLog(@"PayEcoPpi startPay: %@\n\n",orderData);
    
    //初始化易联支付类对象
    PayEcoPpi *payEcoPpi = [[PayEcoPpi alloc] init];
    
    /*
     *  跳转到易联支付SDK
     *  delegate: 用于接收支付结果回调
     *  env:环境参数 00: 测试环境  01: 生产环境
     *  orientation: 支付界面显示的方向 00：横屏  01: 竖屏
     */
    NSString *envStr = @"01";
    [payEcoPpi startPay:orderData delegate:self env:envStr orientation:@"01"];
    
}

- (void)paySuccessToResultViewController
{
    WJPayCompleteModel *model = [[WJPayCompleteModel alloc] init];
    model.paymentType = PaymentTypeBuy;
    model.orderNo = orderNo;
    model.ecardsNum = [NSString stringWithFormat:@"%f",self.orderNum];
    model.ecard = self.eCardModel;
    model.electronicCardPayType = self.selectPayAwayIndex;
    
    WJBaoziPayCompleteController *completeVC = [[WJBaoziPayCompleteController alloc]
                                                initWithinfo:model];
    completeVC.electronicCardComeFrom = self.electronicCardComeFrom;
    [self.navigationController pushViewController:completeVC animated:NO];
}

#pragma mark - WJPassViewDelegate
- (void)successWithVerifyPsdAlert:(WJPassView *)alertView
{
    [self showLoadingView];
    [self.buyECardManager loadData];
}

//更改订单状态
- (void)updateOrderStatus:(OrderStatus)status
{
    
    self.navigationItem.rightBarButtonItem = nil;
    //    [bottom removeFromSuperview];
    //    bottom = nil;
    //    self.detailOrder.orderInfo.orderStatus = status;
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}
//确认支付（已开启指纹）
- (void)payWithAlert:(WJPassView *)alertView
{
    [alertView dismiss];
//    isShowPassView = NO;
    [self checkFingerWithIdenty];
}

- (void)failedWithVerifyPsdAlert:(WJPassView *)alertView errerMessage:(NSString * )errerMessage isLocked:(BOOL)isLocked
{
    [alertView dismiss];
//    isShowPassView = NO;
    //失败重新弹出输入弹窗
    [self showAlertWithMessage:errerMessage isLocked:isLocked];
}


- (void)forgetPasswordActionWith:(WJPassView *)alertView
{
    [alertView dismiss];
//    isShowPassView = NO;
    [self findPassword];
}


//立即充值（包子不足）
- (void)RechargeWithAlert:(WJPassView *)alertView{
    [WJGlobalVariable sharedInstance].payfromController = self;
    WJBaoziOrderConfirmController *baoziVC = [[WJBaoziOrderConfirmController alloc] init];
    [self.navigationController pushViewController:baoziVC animated:YES];
}

//帮助
- (void)helpAction
{
//    WJBaoziDescriptionController *vc = [[WJBaoziDescriptionController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    
}

//指纹校验
- (void)checkFingerWithIdenty
{
    if(IOS8_LATER) {
        //进行指纹识别，获取指纹验证结果
        LAContext *context = [[LAContext alloc] init];
        context.localizedFallbackTitle = @"输入支付密码";
        
        __weak typeof(self) weakSelf = self;
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:NSLocalizedString(@"通过Home键验证已有手机指纹",nil) reply:^(BOOL success, NSError * _Nullable error) {
            
            __strong typeof(self) strongSelf = weakSelf;
            if (success) {
                //验证成功，主线程处理UI
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    
                    [self showLoadingView];
                    [strongSelf.buyECardManager loadData];
                }];
                
            }else{
                NSLog(@"%@",error.localizedDescription);
            }
        }];
    }
}

#pragma mark - 找回密码逻辑
- (void)showAlertWithMessage:(NSString *)msg isLocked:(BOOL)isLocked
{
    NSString *title = nil;
    NSString *otherBtnTitle = nil;
    if (isLocked) {
        title = @"账号已被锁定";
        otherBtnTitle = @"找回支付密码";
    }else{
        title = @"验证失败";
        otherBtnTitle = @"再试一次";
    }
    
    WJSystemAlertView *sysAlert = [[WJSystemAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:otherBtnTitle textAlignment:NSTextAlignmentCenter];
    
    [sysAlert showIn];
}

- (void)findPassword
{
    
    [kDefaultCenter addObserver:self selector:@selector(resetPasswordSuccess) name:@"FindPasswordFromECardDetail" object:nil];
    
    WJModelPerson *person = [WJGlobalVariable sharedInstance].defaultPerson;
    NSInteger appealStatus = person.appealStatus;
    BOOL isSetQuestion = person.isSetPsdQuestion;
    NSInteger realnameStatus = person.authentication;
    NSString *realname = nil;
    NSString *userPhone = person.phone;
    
    if (person.realName) {
        if ([person.realName length]>0) {
            realname = person.realName;
        }
    }
    
    if (IOS8_LATER) {
        
        __weak typeof(self) weakSelf = self;
        __weak NSString *weakName = realname;
        __weak NSString *weakPhone = userPhone;
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"找回密码" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertControl addAction:cancelAction];
        
        UIAlertAction *appealAction = [UIAlertAction actionWithTitle:@"申诉找回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            __strong typeof(self) strongSelf = weakSelf;
            
            if (appealStatus == AppealProcessing){
                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"申诉处理中"];
                
            }else{
                
                [WJGlobalVariable sharedInstance].findPwdFromController = strongSelf;
                //申诉找回
                WJAppealViewController *findPswVC = [[WJAppealViewController alloc] init];
                if (weakPhone) {
                    findPswVC.userPhone = weakPhone;
                }
                [strongSelf.navigationController pushViewController:findPswVC animated:YES];
            }
        }];
        
        [alertControl addAction:appealAction];
        
        if (isSetQuestion) {
            
            UIAlertAction *quesAction = [UIAlertAction actionWithTitle:@"安全问题找回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                __strong typeof(self) strongSelf = weakSelf;
                [WJGlobalVariable sharedInstance].findPwdFromController = strongSelf;
                //安全问题找回
                WJFindSafetyQuestionController *findSafeVC = [[WJFindSafetyQuestionController alloc] init];
                findSafeVC.phoneNumber = weakPhone;
                [strongSelf.navigationController pushViewController:findSafeVC animated:YES];
            }];
            
            [alertControl addAction:quesAction];
        }
        
        if (realnameStatus == 2) {
            
            UIAlertAction *authAction = [UIAlertAction actionWithTitle:@"实名验证找回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                __strong typeof(self) strongSelf = weakSelf;
                [WJGlobalVariable sharedInstance].findPwdFromController = strongSelf;
                //实名验证找回
                WJFindRealNameAuthenticationViewController *authenticVC = [[WJFindRealNameAuthenticationViewController alloc] init];
                if (weakName) {
                    authenticVC.realName = weakName;
                }
                [strongSelf.navigationController pushViewController:authenticVC animated:YES];
                
            }];
            [alertControl addAction:authAction];
        }
        
        [self presentViewController:alertControl animated:YES completion:nil];
        
    }else{
        
        
        UIActionSheet *actionSheet = nil;
        if (isSetQuestion && realnameStatus == 2) {
            actionSheet = [[UIActionSheet alloc] initWithTitle:@"找回密码" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"实名验证找回",@"安全问题找回",@"申诉找回", nil];
            
        }else {
            
            if (isSetQuestion) {
                actionSheet = [[UIActionSheet alloc] initWithTitle:@"找回密码" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"安全问题找回",@"申诉找回", nil];
                
            }else if (realnameStatus == 2){
                actionSheet = [[UIActionSheet alloc] initWithTitle:@"找回密码" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"实名验证找回",@"申诉找回", nil];
                
            }else{
                actionSheet = [[UIActionSheet alloc] initWithTitle:@"找回密码" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"申诉找回", nil];
            }
        }
        
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showInView:self.view];
    }
}



- (void)checkAlertWithBaoziNum:(NSString *)num
{
    CGFloat  salePrice = [self.eCardModel.salePrice floatValue];
    CGFloat  needPrice = salePrice *  self.orderNum;
    //num 数量是否需要充值
    
    if ([num floatValue] < needPrice) {
        WJPassView * passView = [[WJPassView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - ALD(50)) title:@"支付" cardName:self.eCardModel.commodityName  faceValue: [WJUtilityMethod baoziNumberFormatter:[NSString stringWithFormat:@"%f",[self.eCardModel.facePrice floatValue]]]  cardNum:[NSString stringWithFormat:@"%f",self.orderNum] baoziNeedNum:[NSString stringWithFormat:@"%f",needPrice] baoziHasNum:num passViewType:PassViewTypeSubmitTip];
        passView.delegate = self;
        [passView showIn];
        return;
    }
    //    return
    //判断是否设置了指纹验证
    NSString *fingerIdenty = KFingerIdentySwitch;
    BOOL isBool = NO;
    if (fingerIdenty) {
        isBool = [[NSUserDefaults standardUserDefaults] boolForKey:fingerIdenty];
    }
    
    [WJGlobalVariable sharedInstance].fromController = self;
    if (isBool) {
        WJPassView * passView = [[WJPassView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - ALD(50)) title:@"支付" cardName:self.eCardModel.commodityName  faceValue:  [WJUtilityMethod baoziNumberFormatter:[NSString stringWithFormat:@"%f",[self.eCardModel.facePrice floatValue]]] cardNum:[NSString stringWithFormat:@"%f",self.orderNum]  baoziNeedNum:[NSString stringWithFormat:@"%f",needPrice] baoziHasNum:num passViewType:PassViewTypeSubmit];
        
        passView.delegate = self;
        [passView showIn];
    } else {
        WJPassView * passView = [[WJPassView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - ALD(50)) title:@"支付" cardName:self.eCardModel.commodityName  faceValue: [WJUtilityMethod baoziNumberFormatter:[NSString stringWithFormat:@"%f",[self.eCardModel.facePrice floatValue]]] cardNum:[NSString stringWithFormat:@"%f",self.orderNum] baoziNeedNum:[NSString stringWithFormat:@"%f",needPrice]  baoziHasNum:num passViewType:PassViewTypeInputPassword];
        passView.delegate = self;
        [passView showIn];
    }
    
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - ALD(48) - 64) style:UITableViewStylePlain];
        _tableView.backgroundColor = [WJUtilityMethod colorWithHexColorString:@"f1f2f3"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSArray *)headerArray
{
    return @[@"商品信息",@"卡种类",@"选择支付方式",@"订单详情"];
}

- (NSArray *)payArray
{
//    、、
    return @[
             @{@"image":@"pay_alipay",@"text":@"支付宝支付",@"away":@"pingapp"},
             @{@"image":@"pay_yeepay",@"text":@"易联支付",@"away":@"payeco"},
             @{@"image":@"pay_baozi",@"text":@"包子支付",@"away":@"wjkbun"}
             ];
}

- (APIGenECardOrderManager *)genECardManager
{
    if (!_genECardManager) {
        _genECardManager = [[APIGenECardOrderManager alloc] init];
        _genECardManager.delegate = self;
    }
    return _genECardManager;
}

- (APIBuyECardManager *)buyECardManager
{
    if (!_buyECardManager) {
        _buyECardManager = [[APIBuyECardManager alloc] init];
        _buyECardManager.delegate = self;
    }
    return _buyECardManager;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end

