//
//  WJCompleteRealNameViewController.m
//  WanJiCard
//
//  Created by reborn on 16/6/16.
//  Copyright © 2016年 zOne. All rights reserved.
//
#import "WJCompleteRealNameViewController.h"
#import "APIRealNameInformationManager.h"

#define  TopIconViewTopMargin                           (iPhone6OrThan?(30.f):(20.f))
#define  attachLabelTopMargin                           (iPhone6OrThan?(15.f):(10.f))
#define  spaceMargin                                    (iPhone6OrThan?(ALD(0)):(ALD(15)))
#define  desLRightMargin                                (iPhone6OrThan?(ALD(20)):(ALD(45)))

@interface WJCompleteRealNameViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *realName;
    NSString *IDCard;
    NSString *bankCardID;
    NSString *registerPhone;
}
@property(nonatomic, strong)APIRealNameInformationManager *realNameInformationManager;
@property(nonatomic, strong)NSArray                       *listdataMiddle;
@property(nonatomic, strong)UITableView                   *mTb;
@end

@implementation WJCompleteRealNameViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"实名认证";
    self.view.backgroundColor = WJColorViewBg;
    [self initContentView];
    [self requestLoad];
}

- (void)initContentView
{
    [self.view addSubview:self.mTb];

    UIView * topHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(180))];
    topHeaderView.backgroundColor = WJColorViewBg;
    self.mTb.tableHeaderView = topHeaderView;
    
    UIImageView *topIconView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - ALD(100))/2, TopIconViewTopMargin, ALD(100), ALD(100))];
    topIconView.image = [UIImage imageNamed:@"Center_CheckIDCardOK"];
    [topHeaderView addSubview:topIconView];
    
    UILabel *attachLabel = [[UILabel alloc] init];
    attachLabel.text = @"已认证";
    attachLabel.font = [UIFont systemFontOfSize:14];
    attachLabel.textColor = [WJUtilityMethod colorWithHexColorString:@"#9099a6"];
    [attachLabel setTextAlignment:NSTextAlignmentCenter];
    attachLabel.lineBreakMode = NSLineBreakByCharWrapping;
//    CGSize txtSize = [attachLabel.text sizeWithAttributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    CGSize txtSize = [attachLabel.text sizeWithAttributes:@{NSFontAttributeName:WJFont16} constrainedToSize:CGSizeMake(1000000, 20)];

    attachLabel.frame = CGRectMake((kScreenWidth - txtSize.width)/2, topIconView.bottom + attachLabelTopMargin, txtSize.width, ALD(20));
    [topHeaderView addSubview:attachLabel];
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    
    if ([manager isKindOfClass:[APIRealNameInformationManager class]]) {
        NSDictionary *dic = [manager fetchDataWithReformer:nil];
        if ([dic isKindOfClass:[NSDictionary class]]) {
            
            realName = [dic objectForKey:@"custName"];
            IDCard = [dic objectForKey:@"idCode"];
            bankCardID = [dic objectForKey:@"acctId"];
            registerPhone = [dic objectForKey:@"mobilePhone"];
            
            [self.mTb reloadData];
        }
    }
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
}

#pragma mark - Request
- (void)requestLoad{
    [self showLoadingView];
    [self.realNameInformationManager loadData];
}


#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ALD(45);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [UIView new];
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"completeRealCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"completeRealCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.separatorInset = UIEdgeInsetsMake(0, ALD(12), 0, ALD(12));
        
        UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), 0, ALD(100), ALD(45))];
        nameL.tag = 2001;
        nameL.textColor = WJColorDarkGray;
        [cell.contentView addSubview:nameL];
        
        UILabel *contentL = [[UILabel alloc] initWithFrame:CGRectMake(nameL.right + spaceMargin, 0, kScreenWidth - ALD(110), ALD(45))];
        contentL.textColor = WJColorLightGray;
        contentL.tag = 2002;
        [cell.contentView addSubview:contentL];
    }
    
    UILabel *nameL = (UILabel *)[cell.contentView viewWithTag:2001];
    UILabel *contentL = (UILabel *)[cell.contentView viewWithTag:2002];

    NSDictionary * dic = [NSDictionary dictionary];    
    
    if (0 == indexPath.section) {
        
        if (0 == indexPath.row) {
            
            dic = [self.listdataMiddle  objectAtIndex:0];
            nameL.text = dic[@"key"];
            
            contentL.text = realName;;
            
        } else if (1 == indexPath.row) {
            
            dic = [self.listdataMiddle  objectAtIndex:1];
            nameL.text = dic[@"key"];
            contentL.text = IDCard;
        }

    }

    return cell;
}

-(NSArray *)listdataMiddle
{
    if(nil==_listdataMiddle)
    {
        _listdataMiddle=@[@{@"key":@"真实姓名"},
                          @{@"key":@"身份证号"},
                          @{@"key":@"银行卡"},
                          @{@"key":@"预留手机号"}
                          ];
    }
    return _listdataMiddle;
}

#pragma mark - 属性方法
- (UITableView *)mTb{
    if (_mTb == nil) {
        _mTb = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _mTb.delegate = self;
        _mTb.dataSource = self;
        _mTb.separatorInset = UIEdgeInsetsZero;
        _mTb.backgroundColor = WJColorViewBg;
        _mTb.scrollEnabled = NO;
        _mTb.separatorColor = WJColorSeparatorLine;
        _mTb.tableFooterView = [UIView new];
    }
    return _mTb;
}

-(APIRealNameInformationManager *)realNameInformationManager
{
    if (nil == _realNameInformationManager) {
        _realNameInformationManager = [[APIRealNameInformationManager alloc] init];
        _realNameInformationManager.delegate = self;
        
    }
    return _realNameInformationManager;
}

@end
