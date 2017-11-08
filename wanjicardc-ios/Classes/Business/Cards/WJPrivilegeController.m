//
//  WJCardDetailPrivilegeController.m
//  WanJiCard
//
//  Created by Harry Hu on 15/9/7.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

/**
 *  卡特权界面
 *
 *  @param void <#void description#>
 *
 *  @return <#return value description#>
 */
#import "WJPrivilegeController.h"
#import "WJCardDetailAllPrivilegeCell.h"

#import "APIBaseManager.h"

@interface WJPrivilegeController ()<UITableViewDataSource ,UITableViewDelegate, APIManagerCallBackDelegate>{
    NSInteger sectionNumber;
}

@property (nonatomic, strong) NSMutableArray *hadPrivileges;
@property (nonatomic, strong) NSMutableArray *morePrivileges;
@property (nonatomic, strong) UITableView *mTb;

@end

@implementation WJPrivilegeController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    if (!self.isMerchantPrivilege) {
        self.title = @"用户特权";
        self.eventID = @"iOS_act_cardprivilege";
    }else{
        self.title = @"服务·特权";
        self.eventID = @"iOS_act_bizprivilege";
    }
    
    
    if (!self.isMerchantPrivilege) {
        [self sortData:self.privilegeArray];
    }
    
    [self initContent];
    
//    [self requestLoad];
    
}



- (void)initContent{
    [self.view addSubview:self.mTb];
    [self.view addConstraints:[self.mTb constraintsFill]];
}

#pragma mark - APIManagerCallBackDelegate

- (void)requestLoad{
    [self showLoadingView];
}


- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    [self hiddenLoadingView];

    //处理数据
    [self sortData:[manager fetchDataWithReformer:nil]];
    
    //初始化TableView
    [self initContent];
}


- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
}


#pragma mark - Logic

- (void)sortData:(NSArray *)data{
    [[(NSArray *)data lastObject] setIsOwn:YES];
    NSSortDescriptor *desc1 = [[NSSortDescriptor alloc] initWithKey:@"isOwn" ascending:NO];
    NSMutableArray *result = [NSMutableArray arrayWithArray:[data sortedArrayUsingDescriptors:@[desc1]]];

    while (result.count > 0) {
        PayPrivilegeModel *obje = [result firstObject];
        if (obje.isOwn) {
            [self.hadPrivileges addObject:obje];
        }else{
            [self.morePrivileges addObject:obje];
        }
        [result removeObject:obje];
    }
    sectionNumber = (self.hadPrivileges.count > 0 && self.morePrivileges.count > 0) ? 2 : 1;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.isMerchantPrivilege ? 1 : sectionNumber;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isMerchantPrivilege) {
        return self.privilegeArray.count;
    }
    if (sectionNumber == 1) {
        return MAX(self.hadPrivileges.count, self.morePrivileges.count);
    }
    return section == 0 ? self.hadPrivileges.count : self.morePrivileges.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (!self.isMerchantPrivilege) {
        return ALD(45);
    }
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ALD(70);
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *head = [UIView new];
    head.backgroundColor = WJColorViewBg;
    
    UIView *infoBg = [[UIView alloc] initForAutoLayout];
    infoBg.backgroundColor = [UIColor whiteColor];
    [head addSubview:infoBg];
    
    UILabel *infoL = [[UILabel alloc] initForAutoLayout];
    
    infoL.text = section == 0 ? @"现有特权" : @"更多特权";
    infoL.font = WJFont16;
    infoL.textColor = WJColorDardGray3;
    [infoBg addSubview:infoL];
    
    UIView *line = [[UIView alloc] initForAutoLayout];
    line.backgroundColor = WJColorViewBg;
    [infoBg addSubview:line];
    
    
    [head VFLToConstraints:@"H:|-0-[infoBg]-0-|" views:NSDictionaryOfVariableBindings(infoBg)];
    [head addConstraint:[infoBg constraintBottomEqualToView:head]];
    [head addConstraint:[infoBg constraintHeight:ALD(30)]];
    
    [infoBg addConstraints:[infoL constraintsLeftInContainer:ALD(10)]];
    [infoBg addConstraints:[infoL constraintsRightInContainer:ALD(10)]];
    [infoBg VFLToConstraints:@"H:|-0-[line]-0-|" views:NSDictionaryOfVariableBindings(line)];
    [infoBg VFLToConstraints:@"V:|-0-[infoL]-0-[line(0.5)]-0-|" views:NSDictionaryOfVariableBindings(infoL, line)];
    
    return head;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WJCardDetailAllPrivilegeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[WJCardDetailAllPrivilegeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    PayPrivilegeModel *model = nil;
    if (self.isMerchantPrivilege) {
        model = self.privilegeArray[indexPath.row];
    }else if(sectionNumber == 1){
        model = self.hadPrivileges.count>0? self.hadPrivileges[indexPath.row]:self.morePrivileges[indexPath.row];
    }else{
        model = indexPath.section == 0 ? self.hadPrivileges[indexPath.row] : self.morePrivileges[indexPath.row];
    }
    

    [cell configData:model];
    return cell;
}


#pragma mark - 属性方法

- (UITableView *)mTb{
    if (_mTb == nil) {
        _mTb = [[UITableView alloc] initForAutoLayout];
        _mTb.delegate = self;
        _mTb.dataSource = self;
        _mTb.separatorInset = UIEdgeInsetsZero;
        _mTb.tableFooterView = [UIView new];
        _mTb.backgroundColor = WJColorViewBg;
    }
    return _mTb;
}


- (NSMutableArray *)hadPrivileges{
    if (_hadPrivileges == nil) {
        _hadPrivileges = [NSMutableArray array];
    }
    return _hadPrivileges;
}


- (NSMutableArray *)morePrivileges{
    if (_morePrivileges == nil) {
        _morePrivileges = [NSMutableArray array];
    }
    return _morePrivileges;
}


@end
