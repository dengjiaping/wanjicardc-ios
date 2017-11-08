//
//  WJPaymentMethodViewController.m
//  WanJiCard
//
//  Created by XT Xiong on 2016/11/23.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJPaymentMethodViewController.h"
#import "WJPaymentMethodCell.h"
#import "WJCashQRCodeViewController.h"

#import "APICashRateManager.h"
#import "WJCashRateModel.h"
#import "WJCashRateReformer.h"

@interface WJPaymentMethodViewController ()<APIManagerCallBackDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView                     * mainTabelView;

@property(nonatomic,strong)APICashRateManager              * cashRateManager;

@property(nonatomic,strong)NSMutableArray                  * dataArray;
@property(nonatomic,strong)UIView                          * topBackgroundView;
@property(nonatomic,strong)UILabel                         * amountLabel;


@end

@implementation WJPaymentMethodViewController


#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择支付通道";
    
    [self.cashRateManager loadData];
    [self.view addSubview:self.mainTabelView];

}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    if ([manager isKindOfClass:[APICashRateManager class]]) {
       self.dataArray = [manager fetchDataWithReformer:[[WJCashRateReformer alloc] init]];
    }
    [self.mainTabelView reloadData];
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    ALERT(manager.errorMessage);
}



#pragma mark - Custom func

- (WJCashRateModel *)siftModelWithString:(NSString *)channelName
{
    for (WJCashRateModel * cashRateMoel in self.dataArray) {
        if ([cashRateMoel.channelName isEqualToString:channelName]) {
            return cashRateMoel;
        }
    }
    return nil;
}

#pragma mark - Button action

- (void)nowAction:(UIButton *)button
{
    WJCashQRCodeViewController * QRCodeVC = [[WJCashQRCodeViewController alloc]init];
    NSInteger row = button.tag - 5000;
    WJCashRateModel *model = self.dataArray[row -1];
    QRCodeVC.payTypeId = model.idFast;
    QRCodeVC.payMoney = self.amountStr;
    QRCodeVC.buttonNotShow = YES;
    [self.navigationController pushViewController:QRCodeVC animated:YES];
}

- (void)nextAction:(UIButton *)button
{
    WJCashQRCodeViewController * QRCodeVC = [[WJCashQRCodeViewController alloc]init];
    NSInteger row = button.tag - 5000;
    WJCashRateModel *model = self.dataArray[row -1];
    QRCodeVC.payTypeId = model.idNormal;
    QRCodeVC.payMoney = self.amountStr;
    QRCodeVC.buttonNotShow = YES;
    [self.navigationController pushViewController:QRCodeVC animated:YES];
}

#pragma mark - UITableViewDelagate/UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 0) {
        return 1;
    }else{
        if (0 == self.dataArray.count || nil == self.dataArray) {
            return 1;
        } else {
            return self.dataArray.count + 1;
        }
    }
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return ALD(97);
    }else{
        if (indexPath.row == 0) {
            return ALD(44);
        }
        return 210 - ALD(90);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cashMethod"];
        [cell.contentView addSubview:self.topBackgroundView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        if (indexPath.row == 0) {
            UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cashMethod"];
            cell.textLabel.text = @"请选择支付通道";
            cell.textLabel.font = WJFont15;
            cell.textLabel.textColor = WJColorDardGray3;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            WJPaymentMethodCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CashRateCell"];
            
            if (cell == nil) {
                cell = [[WJPaymentMethodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CashRate"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                [cell.nowButton addTarget:self action:@selector(nowAction:) forControlEvents:UIControlEventTouchUpInside];
//                [cell.nextButton addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            cell.nowButton.tag = indexPath.row + 5000;
            cell.nextButton.tag = indexPath.row + 5000;
            if (self.dataArray.count > 0) {
                [cell configDataWithModel:self.dataArray[indexPath.row - 1]];
            }
            return cell;
        }

    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0) {
        WJCashQRCodeViewController * QRCodeVC = [[WJCashQRCodeViewController alloc]init];
        WJCashRateModel *model = self.dataArray[indexPath.row - 1];
        QRCodeVC.payTypeId = model.idFast;
        QRCodeVC.payMoney = self.amountStr;
        QRCodeVC.buttonNotShow = YES;
        [self.navigationController pushViewController:QRCodeVC animated:YES];
    }
}



#pragma mark - Setter and getter

- (UITableView *)mainTabelView{
    if (_mainTabelView == nil) {
        _mainTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
        _mainTabelView.delegate = self;
        _mainTabelView.dataSource = self;
        _mainTabelView.separatorInset = UIEdgeInsetsZero;
        _mainTabelView.backgroundColor = WJColorViewBg;
        _mainTabelView.separatorColor = WJColorSeparatorLine;
        _mainTabelView.tableFooterView = [UIView new];
    }
    return _mainTabelView;
}


- (UIView *)topBackgroundView
{
    if (_topBackgroundView == nil) {
        _topBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(97))];
        _topBackgroundView.backgroundColor = [UIColor whiteColor];
        
        UILabel *recepitLabel = [[UILabel alloc]initForAutoLayout];
        recepitLabel.text = @"金额:";
        recepitLabel.font = WJFont17;
        recepitLabel.textColor = WJColorDardGray3;
        [_topBackgroundView addSubview:recepitLabel];
        [_topBackgroundView addConstraints:[recepitLabel constraintsSize:CGSizeMake(48, 20)]];
        [_topBackgroundView addConstraints:[recepitLabel constraintsLeftInContainer:12]];
        [_topBackgroundView addConstraint:[recepitLabel constraintCenterYEqualToView:_topBackgroundView]];
        
        UILabel *yuanLabel = [[UILabel alloc]initForAutoLayout];
        yuanLabel.text = @"￥";
        yuanLabel.font = WJFont32;
        yuanLabel.textColor = WJColorDardGray3;
        [_topBackgroundView addSubview:yuanLabel];
        [_topBackgroundView addConstraints:[yuanLabel constraintsSize:CGSizeMake(35, 35)]];
        [_topBackgroundView addConstraints:[yuanLabel constraintsLeft:0 FromView:recepitLabel]];
        [_topBackgroundView addConstraint:[yuanLabel constraintCenterYEqualToView:_topBackgroundView]];
        
        self.amountLabel = [[UILabel alloc]initForAutoLayout];
        _amountLabel.text = self.amountStr;
        _amountLabel.font = WJFont45;
        _amountLabel.textColor = WJColorDardGray3;
        [_topBackgroundView addSubview:_amountLabel];
        [_topBackgroundView addConstraints:[_amountLabel constraintsSize:CGSizeMake(kScreenWidth - 100, 40)]];
        [_topBackgroundView addConstraints:[_amountLabel constraintsLeft:0 FromView:yuanLabel]];
        [_topBackgroundView addConstraint:[_amountLabel constraintCenterYEqualToView:_topBackgroundView]];
    }
    return _topBackgroundView;
}

- (APICashRateManager *)cashRateManager
{
    if (!_cashRateManager) {
        _cashRateManager = [[APICashRateManager alloc] init];
        _cashRateManager.delegate = self;
    }
    return _cashRateManager;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
