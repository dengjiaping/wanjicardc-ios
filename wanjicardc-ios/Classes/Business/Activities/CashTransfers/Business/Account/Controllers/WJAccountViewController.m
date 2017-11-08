//
//  WJAccountViewController.m
//  WanJiCard
//
//  Created by XT Xiong on 2016/11/22.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJAccountViewController.h"
#import "WJMyBankCardViewController.h"
#import "WJLoginViewController.h"
#import "WJMyBillViewController.h"
#import "WJPromptAddCardViewController.h"
#import "WJCashLoginViewController.h"
@interface WJAccountViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView      *headerView;
    UIImageView *avatarImageView;
    UILabel     *phoneL;
    UIButton    *exitButton;
}
@property(nonatomic,strong)NSArray      *listdataMiddle;
@property(nonatomic,strong)UITableView  *mTb;

@end

@implementation WJAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账户";
    // Do any additional setup after loading the view.
    [self initView];
    [self initBottomView];
    
    [self checkView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAvatarPressGesture)];
    [headerView  addGestureRecognizer:tapGesture];
}

- (void)initView
{
    [self.view addSubview:self.mTb];
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(160))];
    headerView.backgroundColor = [WJUtilityMethod colorWithHexColorString:@"#019cff"];
    headerView.userInteractionEnabled = YES;
    
    avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - ALD(70))/2, ALD(30), ALD(70), ALD(70))];
    avatarImageView.backgroundColor = [UIColor clearColor];
    avatarImageView.layer.masksToBounds = YES;
    avatarImageView.layer.cornerRadius = avatarImageView.width/2;
    [headerView addSubview:avatarImageView];
    
    phoneL = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - ALD(150))/2, avatarImageView.bottom, ALD(150), ALD(30))];
    phoneL.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:phoneL];

    self.mTb.tableHeaderView = headerView;
}


- (void)initBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    self.mTb.tableFooterView = bottomView;
    
    exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    exitButton.frame = CGRectMake(ALD(15), ALD(40), kScreenWidth - ALD(30), ALD(50));
    [exitButton setTitle:@"退出登录" forState:UIControlStateNormal];
    exitButton.layer.cornerRadius = 5;
    exitButton.backgroundColor = WJColorNavigationBar;
    exitButton.titleLabel.font = WJFont16;
    
    [exitButton addTarget:self action:@selector(exitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:exitButton];
}

- (void)checkView
{
    NSString *token = cashToken;
    if (token.length == 0 || token == nil) {
        
        avatarImageView.image = [UIImage imageNamed:@"headerImg"];
        phoneL.text = @"尚未登录";
        phoneL.textColor = WJColorWhite;
        phoneL.font = WJFont15;
        phoneL.textAlignment = NSTextAlignmentCenter;
        exitButton.hidden = YES;
        
        
    } else {

        avatarImageView.image = [UIImage imageNamed:@"headerImg"];
        
        NSString * userPhone = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:KCashUser] objectForKey:@"userPhone"];
        
        phoneL.text = userPhone;
        NSRange trange = NSMakeRange(3, 4);
        NSString *tPhoneStr = [phoneL.text stringByReplacingCharactersInRange:trange withString:@"＊＊＊＊"];
        phoneL.attributedText = [self attributedText:tPhoneStr];
        
        exitButton.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -event
-(void)tapAvatarPressGesture
{
    NSString *token = cashToken;
    if (token.length == 0 || token == nil) {
        
        [kDefaultCenter addObserver:self selector:@selector(loginFromAccount) name:@"LoginFromCashTransferAccount" object:nil];
        
        WJCashLoginViewController *cashLoginVC = [[WJCashLoginViewController alloc]init];
        cashLoginVC.cashLoginFrom = LoginFromCashAccount;
        WJNavigationController *nav = [[WJNavigationController alloc] initWithRootViewController:cashLoginVC];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
        
    } else {
        

    }

}

- (void)loginFromAccount
{
    [self checkView];
}

- (void)exitButtonAction:(id)sender
{
    [self userLogout];
    [self checkView];
}


- (void)userLogout
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KCashUser];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ALD(45);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ALD(15);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [UIView new];
    return headView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (nil==cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellWithIdentifier];
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = WJFont15;
        cell.separatorInset = UIEdgeInsetsMake(0, ALD(12), 0, ALD(12));
        [cell.textLabel setTextColor:WJColorDardGray3];

    }
    
    if(0 ==indexPath.section) {
        
        NSDictionary * dic = [self.listdataMiddle  objectAtIndex:indexPath.row];
        cell.imageView.image = [UIImage imageNamed:dic[@"icon"]];
        cell.textLabel.text = dic[@"text"];
    }

    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
            
        case 0:{
            switch (indexPath.row) {
                case 0:{
                    //我的银行卡
                    NSString *token = cashToken;
                    if (token.length == 0 || token == nil) {
                        
                        [kDefaultCenter addObserver:self selector:@selector(loginFromAccount) name:@"LoginFromCashTransferAccount" object:nil];
                        
                        WJCashLoginViewController *cashLoginVC = [[WJCashLoginViewController alloc]init];
                        cashLoginVC.cashLoginFrom = LoginFromCashAccount;
                        WJNavigationController *nav = [[WJNavigationController alloc] initWithRootViewController:cashLoginVC];
                        [self.navigationController presentViewController:nav animated:YES completion:nil];
                        
                    } else {
                        
                        NSString * bankAmount = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:KCashUser] objectForKey:@"bankAmount"];
                        
                        if ([bankAmount intValue] > 0) {
                            
                            WJMyBankCardViewController *vc = [[WJMyBankCardViewController alloc] init];
                            [self.navigationController pushViewController:vc animated:YES];
                            
                        } else {
                            
                            WJPromptAddCardViewController *promptAddCardVC = [[WJPromptAddCardViewController alloc] init];
                            promptAddCardVC.titleStr = @"我的银行卡";
                            [self.navigationController pushViewController:promptAddCardVC animated:YES];
                        }
                    }
                    

                }
                    break;
                case 1:{
                    // 我的账单
                    
                    NSString *token = cashToken;
                    if (token.length == 0 || token == nil) {
                        
                        [kDefaultCenter addObserver:self selector:@selector(loginFromAccount) name:@"LoginFromCashTransferAccount" object:nil];

                        WJCashLoginViewController *cashLoginVC = [[WJCashLoginViewController alloc]init];
                        cashLoginVC.cashLoginFrom = LoginFromCashAccount;
                        WJNavigationController *nav = [[WJNavigationController alloc] initWithRootViewController:cashLoginVC];
                        [self.navigationController presentViewController:nav animated:YES completion:nil];
                        
                    } else {
                        
                        WJMyBillViewController *vc = [[WJMyBillViewController alloc] init];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    
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

- (NSAttributedString *)attributedText:(NSString *)text{
    
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc]
                                         initWithString:text];
    NSDictionary *attributesForFirstWord = @{
                                             NSFontAttributeName : WJFont15,
                                             NSForegroundColorAttributeName : WJColorWhite,
                                             };
    
    [result setAttributes:attributesForFirstWord
                    range:NSMakeRange(0, 11)];
    return [[NSAttributedString alloc] initWithAttributedString:result];
}

#pragma mark - 属性方法
- (UITableView *)mTb{
    if (_mTb == nil) {
        _mTb = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 115) style:UITableViewStylePlain];
        
        _mTb.delegate = self;
        _mTb.dataSource = self;
        _mTb.separatorInset = UIEdgeInsetsZero;
        _mTb.backgroundColor = WJColorViewBg2;
        _mTb.scrollEnabled = NO;
        _mTb.separatorColor = WJColorSeparatorLine;
        _mTb.tableFooterView = [UIView new];
    }
    return _mTb;
}

-(NSArray *)listdataMiddle
{
    if(nil==_listdataMiddle)
    {
        _listdataMiddle=@[@{@"icon":@"myBankCard",@"text":@"我的银行卡"},
                          @{@"icon":@"myBill",@"text":@"我的账单"}
                          ];
    }
    return _listdataMiddle;
}

@end
