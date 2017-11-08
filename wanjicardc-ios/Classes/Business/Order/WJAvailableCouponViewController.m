//
//  WJAvailableCouponViewController.m
//  WanJiCard
//
//  Created by 孙琦 on 16/5/26.
//  Copyright © 2016年 zOne. All rights reserved.
//

#import "WJAvailableCouponViewController.h"
#import "WJAvailableCouponCell.h"
@interface WJAvailableCouponViewController ()

@end

@implementation WJAvailableCouponViewController
{
    WJAvailableCouponCell *oldCell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"可用优惠券";
    
    [self initViews];
}

#pragma mark - 初始化控件
- (void)initViews
{
    _mTb = [[UITableView alloc] initForAutoLayout];
    _mTb.delegate = self;
    _mTb.dataSource = self;
    _mTb.separatorInset = UIEdgeInsetsZero;
    _mTb.backgroundColor = WJColorViewBg;
    [self.view addSubview:_mTb];
    [self.view VFLToConstraints:@"H:|-[_mTb]-|" views:NSDictionaryOfVariableBindings(_mTb)];
    [self.view VFLToConstraints:@"V:|-[_mTb]-|" views:NSDictionaryOfVariableBindings(_mTb)];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 80, 22);
    [rightBtn setTitle:@"使用说明" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = WJFont14;
    [rightBtn addTarget:self action:@selector(useInstructionClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

#pragma mark - tableView初始化
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"availableCoupon";
    WJAvailableCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell)
    {
        cell = [[WJAvailableCouponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    if(indexPath.row == 0)
    {
        cell.selectImage.hidden = NO;
        cell.unSelectImage.hidden = YES;
        oldCell = cell;
    }
    cell.moneyLabel.text = @"￥50";
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:cell.moneyLabel.text];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:36] range:NSMakeRange(1,str.length-1)];
    cell.moneyLabel.attributedText = str;
    return cell;
}

#pragma mark - cell行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

#pragma mark - 行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

#pragma mark - 选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    oldCell.selectImage.hidden = YES;
    oldCell.unSelectImage.hidden = NO;
    WJAvailableCouponCell *cell = (WJAvailableCouponCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.selectImage.hidden = NO;
    cell.unSelectImage.hidden = YES;
    oldCell = cell;
    
    if(_selectCouponTypeBlock)
    {
        self.selectCouponTypeBlock(@"选择的优惠券");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 使用说明
- (void)useInstructionClick
{
    
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
